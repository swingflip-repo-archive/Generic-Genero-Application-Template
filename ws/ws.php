<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

//call library 
require_once ('lib/nusoap.php'); 

// Webservice Functions
class ws_funcs 
{
	public function check_service($client_key) 
	{ 	
        	//Basic passkey to prevent spam.
        	$key='znbi58mCGZXSBNkJ5GouFuKPLqByReHvtrGj7aXXuJmHGFr89Xp7uCqDcVCv';

		if($client_key == NULL)
		{ 
			return 'You haven\'t passed your access key!'; 
		} 
		
		if($client_key != $key)
		{
			return 'Your access key doesn\'t match the server access key';			
		}
		
		$result = "OK"; 
		return $result; 
	}

	public function process_image($client_key,$requestee,$requesteddate,$payload)
	{
                //Basic passkey to prevent spam.
                $key='znbi58mCGZXSBNkJ5GouFuKPLqByReHvtrGj7aXXuJmHGFr89Xp7uCqDcVCv';
		
		//Database connection
		$connection = mysqli_connect('localhost','ryanham1_ws_user','1uP;23xxaW+!','ryanham1_WS');

		//Check connection
		if (mysqli_connect_errno())
		{
       			 return 'Failed to connect to MySQL Database: ' . mysqli_connect_error();
		}

                if($client_key == NULL)
                {
                        return 'You haven\'t passed your access key!';
                }

                if($client_key != $key)
                {
                        return 'Your access key doesn\'t match the server access key';
                }

		if($requestee == NULL)
		{
			return 'You need to pass a valid requestee';
		}
		
		if($requesteddate == NULL)
		{
			return 'You need to pass a valid requested date';
                }

		if($payload == NULL)
		{
			return 'You passed an empty payload!';
		}

		if(!mysqli_query($connection, "INSERT INTO processed_images VALUES(0,'".$requestee."','".$requesteddate."','".$payload."')"))
		{
			return 'MySQL ERROR: Unable to process image! Error: '.$connection->error;
		}
		
		$result = "OK";
                return $result;

	} 
}


//using soap_server to create server object 
$server = new soap_server; 
$server->configureWSDL('imageWS', 'http://www.ryanhamlin.co.uk/ws/imageWS');

//register functions that works on server 
$server->register('ws_funcs.check_service',
	array('client_key'=>'xsd:string'),
	array('return'=>'xsd:string'),
	'http://www.ryanhamlin.co.uk/ws/imageWS',
	'http://www.ryanhamlin.co.uk/ws/imageWS#check_service',
	'rpc',
	'encoded',
	'Test the image webservice connection');

$server->register('ws_funcs.process_image',
	array('client_key'=>'xsd:string', 'requestee'=>'xsd:string', 'requesteddate'=>'xsd:string', 'payload'=>'xsd:string'),
        array('return'=>'xsd:string'),
        'http://www.ryanhamlin.co.uk/ws/imageWS2',
        'http://www.ryanhamlin.co.uk/ws/imageWS2#process_image',
        'rpc',
        'encoded',
        'Send process request and payload to image webservice');


// create HTTP listener 
@$server->service(file_get_contents("php://input"));
 
?>
