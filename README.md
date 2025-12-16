# TET OTT 

Laravel Octane project demonstrating modular Laravel package development. 
Features content management and asynchronous analytics logging via RabbitMQ.

## Initial setup

### Pull project from the repository
```
git clone --recurse-submodules -j8 git@github.com:edvardskrumins/tet-ott-deployments.git
cd tet-ott-deployments
```

### Create .env files
```
cp env.example .env
cp analytics-module/.env.example analytics-module/.env
cp content-module/.env.example content-module/.env
cp helper-module/.env.example helper-module/.env
cp tet-ott/.env.example tet-ott/.env
```
⚠️ **Port Requirements**

The following ports must be available on your host:
- `8000` - Content Module (server 1)
- `8001` - Analytics Module (server 2)
- `8002` - Tet-OTT Main (server 3)
- `3306` - MySQL
- `5672` - RabbitMQ
- `15672` - RabbitMQ UI
- `8080` - Webhook Receiver

**Update `docker-compose.yml` if any ports conflict.**

### Run docker compose
```
docker compose up
```
### Generate APP_KEY for projects
```
docker compose exec php-analytics-module php artisan key:generate 
docker compose exec php-content-module php artisan key:generate
docker compose exec php-tet-ott php artisan key:generate
```

## Tests
Run PHPUnit functional tests with the following command:
```
docker compose exec php-content-module php artisan test
docker compose exec php-analytics-module php artisan test
```
### Check if returns content (visit in web browser)
From ***content-module (server 1)***:
```
http://localhost:8000/api/content-module/contents
```
From ***tet-ott (server 3)*** where ***content-module (server 1)*** is installed as a Composer package:
```
http://localhost:8002/api/content-module/contents
```

## Dispatch asynchronous job using RabbitMQ
From ***tet-ott (server 3)*** where analytics-module is installed as a Composer package:
```
docker compose exec php-tet-ott curl -X POST http://localhost:8002/api/analytics-module/logs \
  -H "Content-Type: application/json" \
  -d '{"content_id": 1, "action": "play"}'
``` 
or directly from ***analytics-module (server 2)***:
```
docker compose exec php-analytics-module curl -X POST http://localhost:8001/api/analytics-module/logs \
  -H "Content-Type: application/json" \
  -d '{"content_id": 1, "action": "play"}'
```
This dispatches the [`LogContentInteraction`](https://github.com/edvardskrumins/analytics-module/blob/main/app/Jobs/LogContentInteraction.php) job to RabbitMQ. The job is **processed by the `queue-worker` container**, which:
1. Saves the content interaction to the database (`content_logs` table)
2. Sends an HTTP POST request to the `analytics-webhook` container (httpbin) with analytics data

RabbitMQ queue can be monitored from dashboard available at:
```
http://localhost:15672
```

## Project structure
- **content-module/** (Server 1, Port: 8000)
  - Includes: `helper-module` (via Composer)
  - CRUD operations: [`ContentController`](https://github.com/edvardskrumins/content-module/blob/main/app/Http/Controllers/ContentController.php)
  
- **analytics-module/** (Server 2, Port: 8001)
  - Includes: `helper-module` (via Composer)
  - Logging operations: [`LogController`](https://github.com/edvardskrumins/analytics-module/blob/main/app/Http/Controllers/LogController.php)
  
- **tet-ott/** (Main Project - Server 3, Port: 8002)
  - Includes: `analytics-module` (via Composer)
  - Includes: `content-module` (via Composer)
  - Includes: `helper-module` (via Composer)
  
- **helper-module/**
  - Shared constants: [`ContentActions`](https://github.com/edvardskrumins/helper-module/blob/main/src/Constants/ContentActions.php)
  - Provides single source of truth for content action types (play, pause, complete, like, share) used by all modules

### Redis Caching
All servers (content-module, analytics-module, and tet-ott) use Redis for caching via a shared Redis container. The Redis service runs on port `6379` and is accessible to all PHP Octane instances for session storage and application caching.


## VCS 

## Publish package resources
```
docker compose exec php-tet-ott php artisan vendor:publish --provider="TetOtt\ContentModule\ContentModuleServiceProvider"

docker compose exec php-tet-ott php artisan vendor:publish --provider="TetOtt\AnalyticsModule\AnalyticsModuleServiceProvider"
```
## Update composer
```
docker compose exec php-tet-ott composer update tet-ott/content-module tet-ott/analytics-module tet-ott/helper-module
```


