FROM php:8.2-apache

# Installiere Systemabhängigkeiten für PHP-Erweiterungen
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
  && docker-php-ext-install pdo_mysql zip

# Installiere Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Setze das Arbeitsverzeichnis
WORKDIR /var/www/html

# Installiere PHPMailer direkt
RUN composer require phpmailer/phpmailer --no-interaction --optimize-autoloader

# Kopiere den Rest der App
COPY . .

# Setze die Rechte für die Verzeichnisse, nachdem alles kopiert wurde
RUN chown -R www-data:www-data /var/www/html && \
    mkdir -p /var/www/html/app/uploads && \
    chmod -R 775 /var/www/html/app/uploads

# Konfiguriere Apache, um index.php als Standarddatei zu verwenden
RUN echo "DirectoryIndex index.php" > /etc/apache2/conf-available/directory-index.conf && \
    a2enconf directory-index

# Set the document root to the app directory
RUN sed -i -e 's|/var/www/html|/var/www/html/app|g' /etc/apache2/sites-available/000-default.conf

# Ensure PHP loads environment variables
RUN echo 'variables_order = "EGPCS"' > /usr/local/etc/php/conf.d/zz-load-env-vars.ini

# Expose Port 80
EXPOSE 80

# Starte Apache
CMD ["apache2-foreground"]
