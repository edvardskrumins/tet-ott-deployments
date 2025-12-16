#!/bin/sh
set -e

echo "Ensuring storage and bootstrap/cache directories exist and are writable"
mkdir -p /var/www/html/storage/framework/{sessions,views,cache}
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache

echo "Ensuring vendor directory is writable"
mkdir -p /var/www/html/vendor
chmod -R 775 /var/www/html/vendor 2>/dev/null || true

echo "Installing Composer dependencies"
composer install --no-interaction --prefer-dist --optimize-autoloader

echo "Running migrations"
php artisan migrate 

echo "Running database seeding"
php artisan db:seed

echo "Starting Laravel Octane on port ${OCTANE_PORT} with ${OCTANE_WORKERS} workers and ${OCTANE_TASK_WORKERS} task workers"
exec php artisan octane:start --server=swoole --host=0.0.0.0 --port=${OCTANE_PORT} --workers=${OCTANE_WORKERS} --task-workers=${OCTANE_TASK_WORKERS} 

