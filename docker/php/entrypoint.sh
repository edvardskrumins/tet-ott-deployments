#!/bin/sh
set -e

echo "Installing Composer dependencies"
composer install --no-interaction --prefer-dist --optimize-autoloader

echo "Starting Laravel Octane on port ${OCTANE_PORT} with ${OCTANE_WORKERS} workers and ${OCTANE_TASK_WORKERS} task workers"
exec php artisan octane:start --server=swoole --host=0.0.0.0 --port=${OCTANE_PORT} --workers=${OCTANE_WORKERS} --task-workers=${OCTANE_TASK_WORKERS} --watch

