<?php

$config = getenv('CONFIG');

if ($config == 'docker') {
    $keycloakUrl = 'http://localhost:8080';
    $keycloakRealm = 'virtu-corp';
    $keycloakClientId = 'ldap-service';
} elseif ($config == 'iut') {
    $keycloakUrl = 'http://localhost:8080';
    $keycloakRealm = 'virtu-corp-iut';
    $keycloakClientId = 'ldap-service';
} else {
    die('CONFIG environment variable not set (docker or iut)');
}

if (isset($_GET['code']) && !isset($_COOKIE['access_token'])) {

    $url = 'http://keycloak:8080/realms/virtu-corp/protocol/openid-connect/token';
    $data = array(
        'grant_type' => 'authorization_code',
        'client_id' => 'ldap-service',
        'code' => $_GET['code'],
    );

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        'Content-Type: application/x-www-form-urlencoded'
    ));

    $response = curl_exec($ch);
    // echo $response;
    if ($response === false) {
        // echo 'Erreur cURL : ' . curl_error($ch);
    }

    curl_close($ch);

    // Décode la réponse JSON
    $response_data = json_decode($response, true);

    if ($response_data && isset($response_data['access_token'])) {
        $access_token = $response_data['access_token'];
        $refresh_token = $response_data['refresh_token'];
        // Utilisez l'access_token comme nécessaire
        // echo 'Access Token : ' . $access_token;
        setcookie("access_token", $access_token, time() + 3600, "/");
        setcookie("refresh_token", $refresh_token, time() + 3600, "/");
    } else {
        // echo 'Erreur lors de l\'obtention du token.';
    }
}

?>

<h1>
    Connected successfully
</h1>

<?php

if (isset($_POST['button1'])) {
    $ch = curl_init();
    try {
        $url = 'http://backend:3000/api/public';
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_MAXREDIRS, 1);

        $response = curl_exec($ch);

        if (curl_errno($ch)) {
            echo curl_error($ch);
            die();
        }

        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if ($http_code == intval(200)) {
            echo $response;
        } else {
            echo "Ressource introuvable : " . $http_code;
        }
    } catch (\Throwable $th) {
        throw $th;
    } finally {
        curl_close($ch);
    }
}
if (isset($_POST['button2'])) {
    $url = 'http://backend:3000/api/private';
    $ch = curl_init($url);
    try {
        $headers = [
            'Authorization: Bearer ' . $_COOKIE['access_token'],
            'Content-Type: application/json',
        ];

        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

        $response = curl_exec($ch);


        if (curl_errno($ch)) {
            echo curl_error($ch);
            die();
        }

        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if ($http_code == intval(200)) {
            echo $response;
        } else {
            echo "Ressource introuvable : " . $http_code;
        }
    } catch (\Throwable $th) {
        throw $th;
    } finally {
        curl_close($ch);
    }
}
?>


<form method="post">
    <input type="submit" name="button1" class="button" value="Public API Endpoint" />

    <input type="submit" name="button2" class="button" value="Private API Endpoint" />
</form>