#!/bin/sh
set -ex

if [ ! -f .env ]; then
    php artisan key:generate --no-interaction --force
fi
php artisan migrate --no-interaction --force

php artisan cache:clear
php artisan view:clear

echo "Starting PPM:"
/ppm/vendor/bin/ppm start --ansi --no-interaction --config=ppm.json
