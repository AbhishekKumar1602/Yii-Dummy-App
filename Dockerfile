# Use PHP 8.1 FPM Base Image with Ubuntu
FROM php:8.1-fpm

# Install Nginx and Other Necessary Packages
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    nginx \
    bash \
    curl \
    git \
    unzip \
    zip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    apt-transport-https \
    locales \
    gcc \
    g++ \
    make \
    autoconf \
    libc-dev \
    pkg-config \
    unixodbc \
    unixodbc-dev \
    gnupg \
    ca-certificates \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Microsoft ODBC Driver 18 for SQL Server and Tools
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Install PHP ODBC Drivers
RUN pecl install sqlsrv-5.10.1 \
    && pecl install pdo_sqlsrv-5.10.1 \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Copy Custom Nginx Configuration
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Set Working Directory
WORKDIR /var/www/html

# Copy Application Files
COPY . .

# Install PHP Dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Ensure Proper Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/frontend/runtime \
    && chmod -R 775 /var/www/html/frontend/web/assets \
    && chmod -R 775 /var/www/html/backend/runtime \
    && chmod -R 775 /var/www/html/backend/web/assets

# Expose the Port 80 on Container
EXPOSE 80

# Start PHP-FPM and Nginx
CMD ["sh", "-c", "php-fpm -D && nginx -g 'daemon off;'"]
