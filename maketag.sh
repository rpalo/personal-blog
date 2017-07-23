#!/bin/bash
function usage {
  echo "Usage: $0 <tagname>"
}

if [ $# -ne 1 ]; then
  usage && exit 1
fi

tag=$1
cat<<EOF>./tags/$tag.md
---
layout: tagpage
tag: $tag
permalink: /tags/$tag/
---
EOF
