
<form action="login.php" method="POST">
  <label for="username">Username:</label>
  <input type="text" id="username" name="username" required><br><br>
  
  <label for="password">Password:</label>
  <input type="password" id="password" name="password" required><br><br>
  
  <input type="submit" value="Login">
</form>

<?php
$config = getenv('CONFIG');

if ($config == 'docker') {
  $keycloakUrl = 'http://localhost:8080';
  $keycloakRealm = 'virtu-corp';
  $keycloakClientId = 'ldap-service';
}
elseif ($config == 'iut') {
  $keycloakUrl = 'http://localhost:8080';
  $keycloakRealm = 'virtu-corp-iut';
  $keycloakClientId = 'ldap-service';
}
else {
  die('CONFIG environment variable not set (docker or iut)');
}


if(!$_GET){
  
  $url = 'http://localhost:8080/auth/realms/appsdeveloperblog/protocol/openid-connect/token';
  $data = array(
      'grant_type' => 'authorization_code',
      'client_id' => 'photo-app-code-flow-client',
      'client_secret' => '3424193f-4728-4d19-8517-d450d7c6f2f5',
      'code' => 'c081f6ca-ae87-40b6-8138-5afd4162d181.f109bb89-cd34-4374-b084-c3c1cf2c8a0b.1dc15d06-d8b9-4f0f-a042-727eaa6b98f7',
      'redirect_uri' => 'http://localhost:8081/callback'
  );

  $ch = curl_init($url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_POST, true);
  curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
  curl_setopt($ch, CURLOPT_HTTPHEADER, array(
      'Content-Type: application/x-www-form-urlencoded'
  ));

  $response = curl_exec($ch);

  if ($response === false) {
      echo 'Erreur cURL : ' . curl_error($ch);
  }

  curl_close($ch);

  // Décode la réponse JSON
  $response_data = json_decode($response, true);

  if ($response_data && isset($response_data['access_token'])) {
      $access_token = $response_data['access_token'];
      // Utilisez l'access_token comme nécessaire
      echo 'Access Token : ' . $access_token;
  } else {
      echo 'Erreur lors de l\'obtention du token.';
  }
}


echo '<button>';
echo '<a href="'.$keycloakUrl.'/realms/'.$keycloakRealm.'/protocol/openid-connect/auth?client_id='.$keycloakClientId.'&response_type=code">';
echo 'SSO Login';
echo '</a>';
echo '</button>';


// <button>
//   <a href="http://localhost:8080/realms/virtu-corp/protocol/openid-connect/auth?client_id=ldap-service&response_type=code">
//     SSO Login
//   </a>
// </button>

?>