#!/bin/bash
set -e
name=$1
JEKYLL_ENV=production
bundle exec jekyll build
git add .
git commit -m "$name"
git push
cd _site
git add .
git commit -m "$name"
git push
sleep 5
source secrets.sh
echo "Purging posts list cache"
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/13f84c3ce59abf8d0e7a6ef82a2d0385/purge_cache" \
     -H "X-Auth-Email: $email" \
     -H "X-Auth-Key: $cloudflare_api_key" \
     -H "Content-Type: application/json" \
     --data '{"files":["https://assertnotmagic.com/js/posts_data.js"]}'

echo ""
echo "Complete!"