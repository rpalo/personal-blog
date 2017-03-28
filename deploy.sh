#!/bin/bash
set -e
name=$1
git add .
git commit -m "$name"
git push
cd _site
git add .
git commit -m "$name"
git push
echo "Complete!"