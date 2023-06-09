#!/usr/bin/env sh
set -eu

envsubst '${API_URL} ${API_ACCESS_KEY} ${API_ACCESS_SECRET} ${API_BUCKET}' < /etc/nginx/http.d/default.conf.template > /etc/nginx/http.d/default.conf
rm /etc/nginx/http.d/default.conf.template

exec "$@"
