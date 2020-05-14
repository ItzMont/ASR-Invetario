<?php
defined('BASEPATH') OR exit('No direct script access allowed');

use Restserver\libraries\REST_Controller;
use Restserver\libraries\REST_Controller_Definitions;

require APPPATH . '/libraries/REST_Controller_Definitions.php';
require APPPATH . '/libraries/REST_Controller.php';
require APPPATH . '/libraries/Format.php';

class MyController extends CI_Controller{

	use REST_Controller {
		REST_Controller::__construct as private __resTraitConstruct;
	}

	public function test_get(){
		$array = array("Hola");
		$this->response($array);
	}

	public function loginTest_post(){
		$this->load->model('UsuarioM');
		$respone = $this->UsuarioM->verifiyCount("hola","hola");
		$this->response(array($respone));
	}
}
