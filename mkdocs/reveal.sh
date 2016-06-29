#!/bin/bash

PORT=8001

_usage(){
cat << EOF
Usage: /reveal.sh [command] [project] [filename]

  simple server for revealjs slide to pdf

Options:
  command(required)    [start|reset|replace]
  project(required),   mkdocs project.
  filename,            slide markdown.
EOF
exit 1
}

set_markdown(){
  PROJECT=$2
  DIR="/docs/$PROJECT"

  # ANSI Color
  MAGENTA=$(tput setaf 5)
  RESET=$(tput sgr0)

  # copy files
  cp ${DIR}/$3 ${DIR}/reveal/

  images_from_markdown=$( cat $3 | grep '\!\[' \
                                 | grep -v 'https://\|http://' \
                                 | sed -e 's/\r//g' \
                                       -e 's/\!\[.*\](//' \
                                       -e 's/).*//' \
                        )
  images_from_reveal=$( cat $3 | grep 'data-background' \
                               | grep -v '#' \
                               | sed -e 's/.*data-background=//g' \
                                     -e 's/-->//g' \
                                     -e 's/\"//g' \
                                     -e "s/\'//g" \
                      )
  images=$( echo "${images_from_markdown[@]}" "${images_from_reveal[@]}")
  # copy image
  subdir=$( echo $3 | sed -e 's/.*\/\(.*\)\/.*/\1/' )
  [ ! -e "${DIR}/reveal/${subdir}" ] && mkdir ${DIR}/reveal/${subdir}
  for image in ${images}
  do
    if [ "${subdir}" != "" ]; then
      cp ${DIR}/docs/${subdir}/${image} ${DIR}/reveal/${image}
    else
      cp ${DIR}/docs/${image} ${DIR}/reveal/${image}
    fi
  done

  # replace markdownfile to index.html
  filename=$(echo $3 | awk -F"/" "{print \$NF}")
  sed -ie "s/data-markdown=\".*\"/data-markdown=\"${filename}\"/" reveal/index.html

  # print endpoint
  echo "please access revealjs slide. ${MAGENTA} 'port ${PORT}' ${RESET}"
  echo "convert to pdf in chrome. ${MAGENTA} 'http://[hostname]:${PORT}/?print-pdf/#' ${RESET}"
}

start_server(){
  PROJECT=$2
  cd "/docs/$PROJECT/reveal"
 
  python -m SimpleHTTPServer ${PORT}
}

reset_markdown(){
  PROJECT=$2
  cd "/docs/$PROJECT"

  git clean -df reveal
  git checkout reveal
  echo "Creaned reveal directory"
}

[ -n "$1" ] && [ -n "$2" ] || _usage

case "$1" in
  start)
    [ -n "$3" ] || _usage
    set_markdown $@
    start_server $@
    ;;
  reset)
    reset_markdown $@
    ;;
  replace)
    [ -n "$3" ] || _usage
    set_markdown $@
    ;;
  *)
    _usage
    exit 1
esac

