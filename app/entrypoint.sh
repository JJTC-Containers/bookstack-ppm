#!/bin/sh
set -ex

if [ ! -f /app/.env ]; then
    php artisan key:generate --no-interaction --force
fi
php artisan migrate --no-interaction --force

php artisan cache:clear
php artisan view:clear

echo "Getting PPM ready:"
trapIt() {
    "$@" &
    pid="$!"
    for SGNL in INT TERM CHLD USR1; do
        trap "kill -$SGNL $pid" "$SGNL";
    done
    while kill -0 $pid >/dev/null 2>&1; do
        wait $pid
        ec="$?"
    done
    exit $ec
}

echo "Starting Nginx & PPM:"
multirun "nginx" "$( trapIt /ppm/vendor/bin/ppm start --ansi --no-interaction --config=ppm.json )"
