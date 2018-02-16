set -e
source secrets.sh
echo "Purging posts list cache"
curl -X DELETE "https://api.cloudflare.com/client/v4/zones/13f84c3ce59abf8d0e7a6ef82a2d0385/purge_cache" \
     -H "X-Auth-Email: $email" \
     -H "X-Auth-Key: $cloudflare_api_key" \
     -H "Content-Type: application/json" \
     --data '{"files":["https://assertnotmagic.com/js/posts_data.js"]}'

echo ""
echo "Complete!"