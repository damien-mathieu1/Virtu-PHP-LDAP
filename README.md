# Project Name

Simple 2 stack docker project to test LDAP authentication with PHP. It is possible to connect to two different LDAP servers which are: 
- Docker LDAP (`CONFIG="docker"`)
- IUT of Montpellier LDAP (`CONFIG="iut"`)

## Prerequisites

- Docker: [Installation Guide](https://docs.docker.com/get-docker/)
- Docker Compose: [Installation Guide](https://docs.docker.com/compose/install/)

## Getting Started

1. Clone the repository:

    ```bash
    #SSH
    git clone git@github.com:damien-mathieu1/Virtu-PHP-LDAP.git
    #HTTPS
    git clone https://github.com/damien-mathieu1/Virtu-PHP-LDAP.git
    ```

2. Navigate to the project directory:

    ```bash
    cd Virtu-PHP-LDAP
    ```

3. Build and run the Docker containers:

    ```bash
    docker-compose up -d
    ```

4. Access the application in your browser:

    ```
    http://localhost:8080/index.php
    ```
5. Connect to the LDAP server with the following credentials:

    ```
    Username: cn=admin,dc=example,dc=org
    Password: admin
    ```
        
## Configuration

- Update the LDAP settings in the `docker-compose.yml` file to match your LDAP server configuration.

## Usage

- Connect to a LDAP server with a simple login form and get the authentication result.
- You can chose between two LDAP servers:
    - Docker LDAP (`CONFIG="docker"`)
    - IUT of Montpellier LDAP (`CONFIG="iut"`)
- To chose the LDAP server, you have to change the `CONFIG` variable of the php stack in the `docker-compose.yml` file.

## Tips
- To fast run php script use the following command:
    ```bash
    docker  run -p 8080:8080 --rm -v $(pwd):$(pwd) php:8.2-cli php -S 0.0.0.0:8080  $(pwd)/index.php
    ```

## Contributors

- [Damien Mathieu](https://github.com/damien-mathieu1)
- [Quentin MELOTTE](https://github.com/Nayggets)
- [Florimond CARON](https://github.com/flocaron)
- [Alexandre AFONSO](https://github.com/Aleexx3)

## License

- [MIT License](https://opensource.org/licenses/MIT)
