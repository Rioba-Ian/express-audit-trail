## README.md

**Project Name:** Audit Trail API

This project implements an API to retrieve a user's audit trail and final balance from a PostgreSQL database.

## Technologies Used

- Node.js and Express.js for the API server
- PostgreSQL for the database
- Docker for containerization

## Setup Instructions

### Requirements

- Docker and Docker Compose installed on your system.
- A PostgreSQL database instance running and accessible.

### Prerequisites

1. Update the `.env` file in the `src` directory with your database credentials:

   - `POSTGRES_USER`: The username for your PostgreSQL database.
   - `POSTGRES_PASSWORD`: The password for your PostgreSQL database.
   - `POSTGRES_DB`: The name of the database containing the audit trail data.

2. Build the Docker images:

```bash
docker-compose build
```

### Running the API

1. Start the containers:

```bash
docker-compose up
```

2. The API will be accessible at http://localhost:3000.

## API Endpoints

- **GET /healthcheck:** Returns "Ok." to verify the API is running.
- **GET /audit-trail/:userId:** Returns the user's audit trail and final balance.

## Contributing

Pull requests are welcome! Please open an issue for any bugs or feature requests.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
