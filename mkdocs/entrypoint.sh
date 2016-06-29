#!/bin/bash

echo "$@"

_usage(){
  cat <<EOF
$(basename ${0}) is entrypoint script. with docker + elasticsearch + mkdocs

Usage:
    $(basename ${0}) [command] [<options>]

Options:
    md2es     post markdown text to elasticsearch
    reveal    serve revealjs presentation
    usage     print $(basename ${0}) usage
    *         mkdocs commands.
EOF
}

case "$1" in
  md2es)
    project=${2:-sample}
    exec /bin/bash -c "/md2es.sh ${project}"
    ;;
  reveal)
    cmd=${2:start}
    project=${3:-sample}
    file=$4
    exec /bin/bash -c "/reveal.sh ${cmd} ${project} ${file}"
    ;;
  usage)
    _usage
    exit 1
    ;;
  *)
    exec /bin/bash -c "mkdocs $*"
esac

