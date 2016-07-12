#!/bin/bash

ES_URL='http://elasticsearch:9200'
PROJECT=${1:-sample}
INDICES="mkdocs_$PROJECT"

DIR="/docs/$PROJECT"

post2es() {
  file=$1
  title=$(cat ${file} | sed -e 's/^#\+//g' | head -n 1)
  heading=$(cat ${file} | grep -P '^#+' | sed -e 's/#//g')
  text=$(cat ${file} | sed -e 's/^#\+//g' -e 's/^-\| \+-//g' )
  location=$(echo ${file} | sed -e 's/.\+\/docs//' -e 's/\.md//')

  echo $file

  curl -XPOST "${ES_URL}/${INDICES}/data/" -d "$( /usr/local/bin/jo text="${text}" title="${title}" heading="${heading}" location="${location}" )"
}

delete_indices(){
  curl -XDELETE "${ES_URL}/${INDICES}/"
}

create_indices(){
  curl -XPUT "${ES_URL}/${INDICES}?pretty" -d "\
  {
    \"index\":{
      \"analysis\":{
        \"tokenizer\" : {
          \"kuromoji\" : {
            \"type\" : \"kuromoji_tokenizer\"
          }
        },
        \"analyzer\" : {
          \"default\" : {
            \"type\" : \"custom\",
            \"tokenizer\" : \"kuromoji_tokenizer\",
            \"filter\" : [\"kuromoji_baseform\",\"pos_filter\",\"cjk_width\",\"stemmer\",\"lowercase\"]
          }
        },
        \"filter\" : {
          \"pos_filter\" : {
            \"type\" : \"kuromoji_part_of_speech\",
            \"stoptags\" : [\"接続詞\",\"助詞\",\"助詞-格助詞\",\"助詞-格助詞-一般\",\"助詞-格助詞-引用\",\"助詞-格助詞-連語\",\"助詞-接続助詞\",\"助詞-係助詞\",\"助詞-副助詞\",\"助詞-間投助詞\",\"助詞-並立助詞\",\"助詞-終助詞\",\"助詞-副助詞／並立助詞／終助詞\",\"助詞-連体化\",\"助詞-副詞化\",\"助詞-特殊\",\"助動詞\",\"記号\",\"記号-一般\",\"記号-読点\",\"記号-句点\",\"記号-空白\",\"記号-括弧開\",\"記号-括弧閉\",\"その他-間投\",\"フィラー\",\"非言語音\"]
          },
          \"stemmer\" : {
            \"type\" : \"kuromoji_stemmer\",
            \"minimum_length\" : 2
          }
        }
      },
      \"mappings\": {
        \"default\": {
          \"_timestamp\": {\"enabled\": true, \"path\": \"published_at\"},
          \"_all\": {\"enabled\": true, \"analyzer\": \"kuromoji_analyzer\"},
          \"properties\" : {
            \"title\" : { \"type\": \"string\" },
            \"text\" : { \"type\": \"string\" },
            \"heading\" : { \"type\": \"string\" }
          }
        }
      }
    }
  }"
}

main() {

  delete_indices
  create_indices

  files=$(find ${DIR}/docs -name '*.md' )

  for file in ${files}
  do
    post2es ${file}
  done
}

main $@

