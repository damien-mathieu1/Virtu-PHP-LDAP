
<?php
// FILEPATH: /home/damien/iut/S5/virtu/Virtu-PHP-LDAP/login.php

// LDAP server details
$config = getenv('CONFIG');
if($config == 'docker'){
    $ldapServer = 'ldap';
    $ldapBaseDn = "dc=virtu,dc=org";
    $ldapPort = 389;
}
elseif($config == 'iut'){
    $ldapServer = "10.10.1.30";
    $ldapBaseDn = "dc=info,dc=iutmontp,dc=univ-montp2,dc=fr";
    $ldapPort = 389;
}
else{
    die('CONFIG environment variable not set (docker or local)');
}
$ldapConn = false;

// User credentials
$username = $_POST['username']; 
$password = $_POST['password'];
if ($username == "admin") {
    $usernameLdap="cn=".$username.",".$ldapBaseDn;
}
else {
    $usernameLdap="cn=".$username.",ou=users,".$ldapBaseDn;
}

// Connect to the LDAP server
$ldapConn = ldap_connect($ldapServer, $ldapPort);
if (!$ldapConn) {
    die('Failed to connect to LDAP server');
}

// Set LDAP options
ldap_set_option($ldapConn, LDAP_OPT_PROTOCOL_VERSION, 3);

// Bind to the LDAP server with user credentials
$ldapBind = ldap_bind($ldapConn, $usernameLdap, $password);
if (!$ldapBind) {
    die('LDAP authentication failed');
}

// LDAP authentication successful
echo 'LDAP authentication successful';

// Close the LDAP connection
ldap_unbind($ldapConn);
?>
