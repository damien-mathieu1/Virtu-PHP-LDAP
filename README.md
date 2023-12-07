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
5. Connect to the admin LDAP server with the following credentials:

    ```
    Username: admin
    Password: password
    ```
6. Populate the LDAP server with the following command:

    ```bash
    ./import-openldap-user.sh
    ```
7. When KeyCloak is running, you can access the admin panel with the following URL:

    ```
    http://localhost:8080
    ```
8. Connect to the admin panel with the following credentials:

    ```
    Username: admin
    Password: admin
    ```
9. Bind the LDAP server to KeyCloak with the following command:

    ```bash
    ./init.sh
    ```
10. Access KeyCloak LDAP SSO :
- Go to http://localhost:80/index.php
- Click on "Login with SSO button"
- Login with credential : username : mathieud, password: mathieud
- Then you should be logged in 

11. Try API acces :
- On http://localhost:80/index.php
- Click the public api button to get a callback from the api
- Click on the private API button and you should get block from having a response
- If you are logged the private API button should return the user with which you are authenticated  
        
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
- ldap://192.168.1.23:389

- List all KeyCloak endpoints
-     ```
          http://localhost:8080/realms/virtu-corp/.well-known/openid-configuration
      ```

## Contributors

- [Damien Mathieu](https://github.com/damien-mathieu1)
- [Quentin MELOTTE](https://github.com/Nayggets)
- [Florimond CARON](https://github.com/flocaron)
- [Alexandre AFONSO](https://github.com/Aleexx3)

## License

- [MIT License](https://opensource.org/licenses/MIT)
