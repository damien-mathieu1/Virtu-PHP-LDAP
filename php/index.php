
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
  $keycloakRealm = 'virtu-corp';
  $keycloakClientId = 'ldap-service';
}
else {
  die('CONFIG environment variable not set (docker or local)');
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