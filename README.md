## CDN

An nginx proxy that serves S3 files that are not public in a certain bucket with a prefix.
It uses AWS signature version 2 for authentication therefore version 4 is not supported.
It supports serving different sizes of an image with query string parameter. Images are cached using nginx proxy cache.

```
# run a demo using the environment variables inside .env file

docker-compose up --build
```

```
helm upgrade --install --create-namespace -n cdn --set image.tag=<version>,registryCreds=xxx,env.API_ACCESS_KEY=xxx,env.API_ACCESS_SECRET=xxx,env.API_BUCKET=xxx,env.API_URL=http://localhost:9000 cdn helm/cdn-web
```
