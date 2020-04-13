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

class Usuario extends CI_Controller{

	use REST_Controller {
		REST_Controller::__construct as private __resTraitConstruct;
    }
	
	public function login_post(){
		
		$this->load->model('UsuarioM');
		$payload = json_decode($this->input->post('payload'));
		
		if($this->UsuarioM->verifiyCount($payload->userName,$payload->contra)){
			$resulSet = $this->UsuarioM->ContinueLoginSucceful($payload->userName);
			if(!empty($resulSet) && !array_key_exists('error',$resulSet)){
				$arrToToken = array("idUser" => $resulSet['idusuario'],"session" => $resulSet["idsession"]);
				$token = AUTHORIZATION::generateToken($arrToToken);

				unset($resulSet['idsession']);
				unset($resulSet['idusuario']);
		
				$resulSet = array_merge($resulSet,["token" => $token],["error" => 0]);
				$this->response($resulSet);

			}else{
				$resulSet = array("error" => 101, "message" => "Contact the administrator.");
			}
		}
		else
			$resulSet = array("error" => 100, "message" => "Credentials are incorrect.");
		
		$this->response($resulSet);
	}

	public function logout_post(){
		$this->load->model('UsuarioM');
		$payload = json_decode($this->input->post('payload'));

		
		$arrOfToken = AUTHORIZATION::validateToken($payload->token);

		/*
			Revisar si el token no esta corrupto
		*/

		$idUser = $arrOfToken->idUser;

		$resultQuery = $this->UsuarioM->CloseSession($idUser);
		
		if(!array_key_exists('error',$resultQuery)){
			$resulSet = array("error" => 0);
		}else{
			$resulSet = array("error" => 103, "message" => "Contact the administrator.");
		}

		$this->response($resulSet);
	}
}
