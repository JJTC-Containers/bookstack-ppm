#!/bin/sh
set -ex

if [ ! -f /app/.env ]; then
    php artisan key:generate --no-interaction --force
fi
php artisan migrate --no-interaction --force

echo "Setting folder permissions for www-data:"
chown -R www-data:bookstack bootstrap/cache public/uploads storage

php artisan cache:clear
php artisan view:clear

echo "Starting Nginx:"
nginx

echo "Getting PPM ready:"
trapIt() {
    "$@" &
    pid="$!"
    trap 'kill -INT $pid' INT TERM
    while kill -0 $pid >/dev/null 2>&1; do
        wait $pid
        ec="$?"
    done
    exit $ec
}

echo "Starting PPM:"
trapIt /ppm/vendor/bin/ppm start --ansi --no-interaction --config=ppm.json
