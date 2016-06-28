#!/bin/bash

echo "$@"

case "$1" in
  md2es)
    project=${2:-sample}
    exec /bin/bash -c "/md2es.sh $project"
    ;;
  reveal)
    project=${2:-sample}
    ;;
  usage)
    _usage
    exit 1
    ;;
  *)
    exec /bin/bash -c "mkdocs $*"
esac

