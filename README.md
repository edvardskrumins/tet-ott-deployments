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
docker compose exec php-analytics-module php artisan key:generate 
docker compose exec php-content-module php artisan key:generate
docker compose exec php-tet-ott php artisan key:generate
```
```
docker compose exec php-tet-ott php artisan vendor:publish --provider="TetOtt\ContentModule\ContentModuleServiceProvider"

docker compose exec php-tet-ott php artisan vendor:publish --provider="TetOtt\AnalyticsModule\AnalyticsModuleServiceProvider"

docker compose exec php-tet-ott php artisan migrate

docker compose exec php-tet-ott php artisan db:seed
```
```
docker compose exec php-tet-ott composer update tet-ott/content-module tet-ott/analytics-module tet-ott/helper-module
```

```
docker compose exec php-tet-ott curl -X POST http://localhost:8001/api/analytics-module/logs   -H "Content-Type: application/json"   -d '{"content_id": 1, "action": "play"}'
```

```
docker compose exec php-content-module php artisan test
docker compose exec php-analytics-module php artisan test
 ```