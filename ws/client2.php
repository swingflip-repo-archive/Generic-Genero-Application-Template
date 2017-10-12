<?php

require_once "lib/nusoap.php";

error_reporting(E_ALL);
ini_set('display_errors', 1);
 
$client = new nusoap_client("http://www.ryanhamlin.co.uk/ws/ws/ws.php?wsdl", true);
$error  = $client->getError();
 
if ($error) {
    echo "<h2>Constructor error</h2><pre>" . $error . "</pre>";
}
 
$result = $client->call("ws_funcs.process_image", array("client_key" => "znbi58mCGZXSBNkJ5GouFuKPLqByReHvtrGj7aXXuJmHGFr89Xp7uCqDcVCv",
                                                        "requestee"=>"Ryan",
                                                        "requesteddate"=>"2017-04-25 21:20:24",
                                                        "payload"=>"ABCDEFG123"));
 
if ($client->fault) {
    echo "<h2>Fault</h2><pre>";
    print_r($result);
    echo "</pre>";
} else {
    $error = $client->getError();
    if ($error) {
        echo "<h2>Error</h2><pre>" . $error . "</pre>";
    } else {
        echo "<h2>Main</h2>";
        echo $result;
    }
}
 
// show soap request and response
echo "<h2>Request</h2>";
echo "<pre>" . htmlspecialchars($client->request, ENT_QUOTES) . "</pre>";
echo "<h2>Response</h2>";
echo "<pre>" . htmlspecialchars($client->response, ENT_QUOTES) . "</pre>";

?>

