#!/bin/bash
set -e

# Create necessary directories if they don't exist
mkdir -p /var/log/supervisor
mkdir -p /var/log/nginx
mkdir -p /var/www/backend/storage/logs
mkdir -p /var/www/backend/storage/framework/views
mkdir -p /var/www/backend/storage/framework/cache
mkdir -p /var/www/backend/storage/framework/sessions

# Set proper permissions
chown -R www-data:www-data /var/www/backend/storage
chown -R www-data:www-data /var/www/backend/bootstrap/cache
chown -R www-data:www-data /var/www/frontend/dist

# Generate the key if not already generated
cd /var/www/backend
cp .env.example .env
php artisan key:generate --no-interaction

# Create a MySQL script to check if MySQL is up
cat > /tmp/wait-for-mysql.sh << 'EOL'
#!/bin/bash
set -e

host="$1"
shift
cmd="$@"

until mysqladmin ping -h"$host" -u"$DB_USERNAME" -p"$DB_PASSWORD" --silent; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up - executing commands"
exec $cmd
EOL

chmod +x /tmp/wait-for-mysql.sh

# Wait for MySQL and run migrations
cd /var/www/backend
if [ "$DB_CONNECTION" = "mysql" ]; then
  echo "Waiting for MySQL to be ready..."
  /tmp/wait-for-mysql.sh "$DB_HOST" php artisan migrate --force
fi

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 