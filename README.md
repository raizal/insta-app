# Instagram Clone

A full-stack Instagram clone built with Laravel (backend) and React (frontend).

## Project Structure

- `backend-insta-clone/` - Laravel backend API
- `frontend-insta-clone/` - React frontend application
- `docker/` - Docker configuration files for development and production

## Development Setup

### Prerequisites

- Docker and Docker Compose
- Git

### Running the Development Environment

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd instagram-clone
   ```

2. Start the development environment:
   ```bash
   docker-compose -f docker-compose-dev.yml up -d
   ```

3. Access the applications:
   - dev site: http://localhost:8000

4. To stop the development environment:
   ```bash
   docker-compose -f docker-compose-dev.yml down
   ```

## Production Deployment

### Prerequisites

- Docker and Docker Compose
- Git

### Running the Production Environment

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd instagram-clone
   ```

2. Configure environment variables (optional):
   ```bash
   # Set the base URL for your production environment
   export VITE_BASE_URL=https://your-production-domain.com
   ```

3. Start the production environment:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

4. Access the application:
   - Production site: http://localhost:8080

5. To stop the production environment:
   ```bash
   docker-compose -f docker-compose.prod.yml down
   ```

## Environment Variables

### Development
- Frontend environment variables are stored in `frontend-insta-clone/.env`
- Backend environment variables are stored in `backend-insta-clone/.env`

### Production
- `VITE_BASE_URL` - The base URL for API requests (defaults to http://localhost:8080)

## Database

The application uses MySQL for both development and production environments:

- Development: 
  - Host: localhost
  - Port: 3306
  - Database: laravel
  - Username: user
  - Password: password

- Production:
  - The same credentials are used but in an isolated container

## Troubleshooting

- If you encounter permission issues, ensure that storage directories have proper permissions:
  ```bash
  docker-compose exec app chown -R www-data:www-data /var/www/backend/storage
  ```

- For database connection issues, check if the MySQL container is healthy:
  ```bash
  docker-compose ps mysql
  ```
