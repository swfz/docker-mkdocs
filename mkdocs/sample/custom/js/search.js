require([
    base_url + '/mkdocs/js/mustache.min.js',
    base_url + '/js/elasticsearch.jquery.js',
    base_url + '/js/config.js',
    'text!search-results-template.mustache',
], function (Mustache, elasticsearch, config, results_template) {
   "use strict";

   var client = new $.es.Client({
     host: config.esEndpoint + ":9200",
     headers: {
       'Accept': 'application/json',
       'Content-Type': 'application/json'
     },
     log: 'trace'
   });

    function getSearchTerm()
    {
        var sPageURL = window.location.search.substring(1);
        var sURLVariables = sPageURL.split('&');
        for (var i = 0; i < sURLVariables.length; i++)
        {
            var sParameterName = sURLVariables[i].split('=');
            if (sParameterName[0] == 'q')
            {
                return decodeURIComponent(sParameterName[1].replace(/\+/g, '%20'));
            }
        }
    }
    function searchFromEs(query){
      var request = client.search({
        index: 'mkdocs_sample',
        body: {
          query: {
            bool: {
              should: [
                { "match": { "title":   { "query": query, "boost": 5 } } },
                { "match": { "heading": { "query": query, "boost": 4 } } },
                { "match": { "text":    { "query": query, "boost": 3 } } }
              ]
            }
          }
        }
      });

      var search_results = document.getElementById("mkdocs-search-results");
      request.then(function(res){
        var results = res.hits.hits;
        if (results.length > 0){
            for (var i=0; i < results.length; i++){
                var result = results[i];
                var doc = result._source;
                doc.score    = result._score;
                doc.summary  = doc.text.substring(0, 200);
                var html = Mustache.to_html(results_template, doc);
                search_results.insertAdjacentHTML('beforeend', html);
            }
        } else {
            search_results.insertAdjacentHTML('beforeend', "<p>No results found</p>");
        }
      });
    }

    var search = function(){
        var query = document.getElementById('mkdocs-search-query').value;
        var search_results = document.getElementById("mkdocs-search-results");
        while (search_results.firstChild) {
            search_results.removeChild(search_results.firstChild);
        }

        if(query === ''){
            return;
        }

        searchFromEs(query);

        if(jQuery){
            /*
             * We currently only automatically hide bootstrap models. This
             * requires jQuery to work.
             */
            jQuery('#mkdocs_search_modal a').click(function(){
                jQuery('#mkdocs_search_modal').modal('hide');
            })
        }
    };

    var search_input = document.getElementById('mkdocs-search-query');

    var term = getSearchTerm();
    if (term){
      console.log(term);
        search_input.value = term;
        search();
    }

    search_input.addEventListener("keyup", search);

});
