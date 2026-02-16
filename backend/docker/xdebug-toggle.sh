#!/bin/sh
# Toggle Xdebug on/off in container

XDEBUG_CONFIG="/usr/local/etc/php/conf.d/xdebug.ini"

if [ "$1" = "on" ]; then
    echo "Enabling Xdebug..."
    docker-compose exec -e XDEBUG_MODE=debug backend sh -c "php -r 'echo ini_get(\"xdebug.mode\");'"
    # Note: This requires Xdebug to be installed (add to Dockerfile if needed)
elif [ "$1" = "off" ]; then
    echo "Xdebug is already disabled by default (XDEBUG_MODE=off in docker-compose.yml)"
else
    echo "Usage: $0 [on|off]"
    exit 1
fi
