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

  curl -XPOST "${ES_URL}/${INDICES}/data/" -d "$( jo text="${text}" title="${title}" heading="${heading}" location="${location}" )"
}

delete_indices(){
  curl -XDELETE "${ES_URL}/${INDICES}/"
}

main() {

  delete_indices

  files=$(find ${DIR}/docs -name '*.md' )

  for file in ${files}
  do
    post2es ${file}
  done
}

main $@

