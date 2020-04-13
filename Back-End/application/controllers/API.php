<?php
defined('BASEPATH') OR exit('No direct script access allowed');
header('Access-Control-Allow-Origin: *');
header("Content-Type: multipart/form-data ; charset=utf-8");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");


use Restserver\libraries\REST_Controller;
use Restserver\libraries\REST_Controller_Definitions;

require APPPATH . '/libraries/REST_Controller_Definitions.php';
require APPPATH . '/libraries/REST_Controller.php';
require APPPATH . '/libraries/Format.php';

class API extends CI_Controller{

	use REST_Controller {
		REST_Controller::__construct as private __resTraitConstruct;
	}

	public function demo_get(){
		$tokenData['id'] = 1;

		$output['token'] = AUTHORIZATION::generateToken($tokenData);
		$array = AUTHORIZATION::validateToken($output['token']);
		
		$this->response($output['token']);
		// $array = array("Hola");
		// $this->response($array);
		//echo("Hola");
	}
	
}
