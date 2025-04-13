# Multi-stage build for combined Laravel backend and React frontend
FROM php:8.2-fpm AS php-base

# Install dependencies for PHP
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    supervisor \
    procps \
    gnupg \
    default-mysql-client

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install pnpm
RUN npm install -g pnpm

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set up directories for supervisord and nginx
WORKDIR /var/www

# Create directories for the project
RUN mkdir -p /var/www/backend/public
RUN mkdir -p /var/www/frontend/dist

# Copy supervisord configuration
COPY docker/prod/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy Nginx configuration
COPY docker/prod/nginx/default.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/sites-enabled/default

# Copy entrypoint script
COPY docker/prod/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory for backend
WORKDIR /var/www/backend

# Copy backend files
COPY backend-insta-clone /var/www/backend

# Install backend dependencies
RUN composer install --optimize-autoloader --no-dev

# Set permissions
RUN chown -R www-data:www-data /var/www/backend/storage /var/www/backend/bootstrap/cache

# Set working directory for frontend
WORKDIR /var/www/frontend

# Copy frontend files
COPY frontend-insta-clone /var/www/frontend

# Install frontend dependencies
RUN pnpm install

# Set environment variables for frontend build
ARG VITE_BASE_URL=http://localhost:8080
ENV VITE_BASE_URL=${VITE_BASE_URL}

# Build frontend with environment variables
RUN pnpm run build

# Make sure permissions are set correctly
RUN chown -R www-data:www-data /var/www/frontend/dist

# Expose port
EXPOSE 80

WORKDIR /var/www/backend

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"] 