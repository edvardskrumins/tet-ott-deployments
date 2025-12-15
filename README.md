## Initial setup
```
cd tet-ott-deployments
```
```
cp env.example .env
cp analytics-module/.env.example analytics-module/.env
cp content-module/.env.example content-module/.env
cp helper-module/.env.example helper-module/.env
cp tet-ott/.env.example tet-ott/.env

```
 
```
docker compose exec -it php-analytics-module php artisan key:generate 
docker compose exec -it php-content-module php artisan key:generate
docker compose exec -it php-tet-ott php artisan key:generate
```

```
docker compose exec php-tet-ott composer update tet-ott/content-module tet-ott/analytics-module
```