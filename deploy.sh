#!/bin/bash
set -o errexit

name="$1"

echo
echo "--- 1/5 Building the site in Production Mode ---"
echo
export JEKYLL_ENV=production
bundle exec jekyll build

echo
echo "--- 2/5 Pushing this repo to GitHub ---"
echo
git add .
git commit -m "$name"
git push

echo
echo "--- 3/5 Deploying the built site to GitHub ---"
echo
cd _site
git add .
git commit -m "$name"
git push

echo
echo "--- 4/5 Waiting for GitHub to start serving the new build ---"
echo
for (( i=10; i > 0; i-- )); do
    echo -en "\r$i"
    sleep 1
done

echo
echo "--- 5/5 Purging posts list cache ---"
echo

cd ..
source secrets.sh
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/13f84c3ce59abf8d0e7a6ef82a2d0385/purge_cache" \
     -H "X-Auth-Email: $email" \
     -H "X-Auth-Key: $cloudflare_api_key" \
     -H "Content-Type: application/json" \
     --data '{"files":["https://assertnotmagic.com/js/posts_data.js"]}'

echo
echo "--- Complete! ---"
echo
