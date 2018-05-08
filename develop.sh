#!/usr/bin/env bash

if [ ! -z "$BUILD_NUMBER" ]; then
    export XDEBUG_HOST=$(/sbin/ifconfig docker0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
else
    export XDEBUG_HOST=$(ipconfig getifaddr en1)
fi

export CONTAINER_ENV=${CONTAINER_ENV:-local}
export APP_ENV=${APP_ENV:-local}
export APP_PORT=${APP_PORT:-80}
export DB_PORT=${DB_PORT:-3306}
export DB_ROOT_PASS=${DB_ROOT_PASS:-secret}
export DB_NAME=${DB_NAME:-helpspot}
export DB_USER=${DB_NAME:-helpspot}
export DB_PASS=${DB_NAME:-secret}

COMPOSE_FILE="dev"
TTY=""

if [ ! -z "$BUILD_NUMBER" ]; then
    COMPOSE_FILE="ci"
    TTY="-T"
fi

COMPOSE="docker-compose -f docker-compose.${COMPOSE_FILE}.yml"

if [ $# -gt 0 ]; then
    if [ "$1" == "art" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            app \
            php artisan "$@"
    elif [ "$1" == "composer" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            app \
            composer "$@"
    elif [ "$1" == "test" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            app \
            ./vendor/bin/phpunit "$@"
    elif [ "$1" == "t" ]; then
        shift 1
        $COMPOSE exec \
            app \
            sh -c "cd /var/www/html && ./vendor/bin/phpunit $@"
    elif [ "$1" == "npm" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            node \
            npm "$@"
    elif [ "$1" == "gulp" ]; then
        shift 1
        $COMPOSE run --rm $TTY \
            -w /var/www/html \
            node \
            ./node_modules/.bin/gulp "$@"
    else
        $COMPOSE "$@"
    fi
else
    $COMPOSE ps
fi