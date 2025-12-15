#!/bin/bash
set -e

echo "Installing Composer dependencies..."
composer install --no-interaction --prefer-dist --optimize-autoloader

echo "Declaring RabbitMQ queue..."
php artisan rabbitmq:queue-declare default 

echo "Launching supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

