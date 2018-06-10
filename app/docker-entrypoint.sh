#!/bin/bash
set -ex

php artisan key:generate --no-interaction --force
php artisan migrate --no-interaction --force

echo "Setting folder permissions for uploads"
chown -R www-data:www-data public/uploads storage/uploads /ppm

php artisan cache:clear
php artisan view:clear

echo "Starting Nginx:"
nginx

echo "Getting PPM ready:"
trapIt () { "$@"& pid="$!"; trap 'kill -INT $pid' INT TERM; while kill -0 $pid > /dev/null 2>&1; do wait $pid; ec="$?"; done; exit $ec;};

echo "Starting PPM:"
trapIt su-exec www-data:www-data /ppm/vendor/bin/ppm start --ansi --port=8080 --socket-path=/ppm/run --pidfile=/ppm/ppm.pid --bootstrap=laravel --static-directory=public/ --app-env=prod
