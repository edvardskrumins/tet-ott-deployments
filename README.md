## Initial setup
```
cd tet-ott-deployments
```
```
cp env.example .env
cp analytics-module/.env.example .env
cp content-module/.env.example .env
cp helper-module/.env.example .env
cp tet-ott/.env.example .env

```
 
```
docker compose exec -it php-analytics-module php artisan key:generate 
docker compose exec -it php-content-module php artisan key:generate
docker compose exec -it php-tet-ott php artisan key:generate
```