# PHP - KEYCLOAK - LDAP

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
    ./init.sh
    ```

4. Access the application in your browser:

    ```bash
    http://localhost:8080/index.php
    ```
5. Connect to the LDAP server with the following credentials:

    ```
    ADMIN :
    Username: admin
    Password: password
    
    LIST OF USERS :
    admin/password
    mathieud/mathieud
    caronf/caronf
    afonsoa/afonsoa
    melotteq/melotteq
    ```
6. When KeyCloak is running, you can access the admin panel with the following URL:

    ```
    http://localhost:8080
    ```
7. Connect to the admin panel with the following credentials:

    ```
    Username: admin
    Password: admin
    ```
8. Bind the LDAP server to KeyCloak with the following command:

    ```bash
    ./init.sh
    ```
9. Access KeyCloak LDAP SSO :
- Go to http://localhost:80/index.php
- Click on "Login with SSO button"
- Login with credential : username : mathieud, password: mathieud
- Then you should be logged in 

10. Try API access :
- On http://localhost:80/index.php
- Click the public api button to get a callback from the api
- Click on the private API button and you should get block from having a response
- If you are logged the private API button should return the user with which you are authenticated and the list of user registered in your keycloak instance
        
## Configuration

- Update the LDAP settings in the `docker-compose.yml` file to match your LDAP server configuration.

## Usage

- Connect to a LDAP server with a simple login form and get the authentication result.
- You can chose between two LDAP servers:
    - Docker LDAP (`CONFIG="docker"`)
    - IUT of Montpellier LDAP (`CONFIG="iut"`)
- To chose the LDAP server, you have to change the `CONFIG` variable of the php stack in the `docker-compose.yml` file.

## Contributors

- [Damien Mathieu](https://github.com/damien-mathieu1)
- [Quentin MELOTTE](https://github.com/Nayggets)
- [Florimond CARON](https://github.com/flocaron)
- [Alexandre AFONSO](https://github.com/Aleexx3)

## License

- [MIT License](https://opensource.org/licenses/MIT)
