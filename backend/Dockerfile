# Build stage
FROM php:8.4-cli-alpine AS builder

WORKDIR /app

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-progress --no-scripts

# Runtime stage
FROM php:8.4-fpm-alpine

WORKDIR /app

# Install runtime dependencies and build tools for PHP extensions
RUN apk add --no-cache \
    postgresql-client \
    sqlite \
    sqlite-dev \
    nginx \
    supervisor \
    && apk add --no-cache --virtual .build-deps \
    build-base \
    autoconf \
    && docker-php-ext-install pdo pdo_sqlite \
    && docker-php-ext-configure pdo_mysql \
    && docker-php-ext-install pdo_mysql \
    && apk del .build-deps

# Copy PHP application from builder
COPY --from=builder /app /app

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p /app/storage/logs \
    && mkdir -p /var/log/supervisor \
    && chmod -R 775 /app/storage \
    && chmod -R 775 /app/bootstrap/cache

# Copy nginx config
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy supervisord config
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port
EXPOSE 80

# Run supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
