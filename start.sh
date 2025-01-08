#!/bin/bash

# Wait for MySQL to be ready
until nc -z -v -w30 mysql 3306
do
  echo "Waiting for MySQL to be ready..."
  sleep 5
done

# Wait for Redis to be ready
until nc -z -v -w30 redis 6379
do
  echo "Waiting for Redis to be ready..."
  sleep 5
done

# Copy .env file if not exists
if [ ! -f .env ]; then
    cp .env.example .env
fi

# Generate application key if not set
if ! grep -q "^APP_KEY=" .env || grep -q "^APP_KEY=$" .env; then
    php artisan key:generate
fi

# Run database migrations
php artisan migrate --force

# Create admin user if not exists
php artisan tinker --execute="
if (!\App\Models\User::where('email', 'admin@example.com')->exists()) {
    \App\Models\User::create([
        'name' => 'Admin',
        'email' => 'admin@example.com',
        'password' => bcrypt('password')
    ]);
}
"

# Start the application
php artisan serve --host=0.0.0.0 --port=8000