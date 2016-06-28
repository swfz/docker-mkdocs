#!/bin/bash

PORT=8001

_usage(){
cat << EOF
Usage: /reveal.sh [project] [filename]

  simple server for revealjs slide to pdf

Options:
  project(required),  mkdocs project.
  filename(required), slide markdown.
EOF
exit 1
}

main(){
  PROJECT=$1
  DIR="/docs/$PROJECT"

  # ANSI Color
  MAGENTA=$(tput setaf 5)
  RESET=$(tput sgr0)

  # copy files
  cp ${DIR}/$2 ${DIR}/reveal/

  images_from_markdown=$( cat $2 | grep '\!\[' \
                                 | grep -v 'https://\|http://' \
                                 | sed -e 's/\r//g' \
                                       -e 's/\!\[.*\](//' \
                                       -e 's/).*//' \
                        )
  images_from_reveal=$( cat $2 | grep 'data-background' \
                               | grep -v '#' \
                               | sed -e 's/.*data-background=//g' \
                                     -e 's/-->//g' \
                                     -e 's/\"//g' \
                                     -e "s/\'//g" \
                      )
  images=$( echo "${images_from_markdown[@]}" "${images_from_reveal[@]}")
  # copy image
  subdir=$( echo $2 | sed -e 's/.*\/\(.*\)\/.*/\1/' )
  [ ! -e "${DIR}/reveal/${subdir}" ] && mkdir ${DIR}/reveal/${subdir}
  for image in ${images}
  do
    cp ${DIR}/docs${image} ${DIR}/reveal/${image}
  done

  # replace markdownfile to index.html
  filename=$(echo $2 | awk -F"/" "{print \$NF}")
  sed -ie "s/data-markdown=\".*\"/data-markdown=\"${filename}\"/" reveal/index.html

  # print endpoint
  echo "please access revealjs slide. ${MAGENTA} 'port ${PORT}' ${RESET}"
  echo "convert to pdf in chrome. ${MAGENTA} 'http://[hostname]:${PORT}/?print-pdf/#' ${RESET}"

}

[ -n "$1" ] && [ -n "$2" ] && main "$@" || _usage

