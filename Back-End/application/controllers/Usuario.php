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
require_once 'CreatorPDF.php';

class Usuario extends CI_Controller{

	use REST_Controller {
		REST_Controller::__construct as private __resTraitConstruct;
    }
	
	public function login_post(){
		
		$this->load->model('UsuarioM');
		//Forma normal dde recibir los datos
		// $payload = json_decode($this->input->post('payload'));
		// $userName = $payload->userName;
		// $contra = $payload->contra;
		
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$userName = $this->input->post('userName');
		$contra = $this->input->post('contra');

		
		if($this->UsuarioM->verifiyCount($userName,$contra)){
			$resulSet = $this->UsuarioM->ContinueLoginSucceful($userName);
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
		// //Forma normal dde recibir los datos
		// $payload = json_decode($this->input->post('payload'));
		// $token = $payload->token;
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$token = $this->input->post('token');

		try{
			$arrOfToken = AUTHORIZATION::validateToken($token);

			$idUser = $arrOfToken->idUser;

			$resultQuery = $this->UsuarioM->CloseSession($idUser);
			
			if(!array_key_exists('error',$resultQuery)){
				$resulSet = array("error" => 0);
			}else{
				$resulSet = array("error" => 103, "message" => "Contact the administrator.");
			}
			
		}catch(Exception $e){
			$resulSet = array("error" => 104, 'message' => "Error contacte al administrador.");
		}

		$this->response($resulSet);
	}

	public function addProduct_post(){
		$this->load->model('UsuarioM');
		// //Forma normal dde recibir los datos
		// $payload = json_decode($this->input->get('payload'));
		// $token = $payload->token;
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$token = $this->input->post('token');
		$material = $this->input->post('material');
		$marca = $this->input->post('marca');
		$color = $this->input->post('color');
		$idLab = $this->input->post('idLab');
		$idProd = $this->input->post('idProd');

		$resulSet = $idProd;
		
		try{
			$arrOfToken = AUTHORIZATION::validateToken($token);

			$idUser = $arrOfToken->idUser;
			$idSesion = $arrOfToken->session;

			

			$resultQuery = $this->UsuarioM->InsertProduct($idUser,$idSesion,$idLab,$idProd,$color,$marca);
			
			//$resulSet = $resultQuery;

			if(array_key_exists('error',$resultQuery) && $resultQuery['error'] == 0){
				$resulSet = $resultQuery;
			}else{
				$resulSet = array("error" => 103, "message" => "Contact the administrator.");
			}
			
		}catch(Exception $e){
			$resulSet = array("error" => 104, 'message' => "Error contacte al administrador.");
		}
		
		$this->response($resulSet);
	}

	public function updateProduct_post(){
		$this->load->model('UsuarioM');
		// //Forma normal dde recibir los datos
		// $payload = json_decode($this->input->get('payload'));
		// $token = $payload->token;
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$token = $this->input->post('token');
		$idProduct = $this->input->post('idProduct');
		$material = $this->input->post('material');
		$marca = $this->input->post('marca');
		$color = $this->input->post('color');
		$idLab = $this->input->post('idLab');
		$idProd = $this->input->post('idProd');

		$resulSet = $idProd;
		
		try{
			$arrOfToken = AUTHORIZATION::validateToken($token);

			$idUser = $arrOfToken->idUser;
			$idSesion = $arrOfToken->session;

			

			$resultQuery = $this->UsuarioM->UpdateProduct($idUser,$idSesion,$idProduct,$idLab,$idProd,$color,$marca);
			
			//$resulSet = $resultQuery;

			if(array_key_exists('error',$resultQuery) && $resultQuery['error'] == 0){
				$resulSet = $resultQuery;
			}else{
				$resulSet = array("error" => 103, "message" => "Contact the administrator.");
			}
			
		}catch(Exception $e){
			$resulSet = array("error" => 104, 'message' => "Error contacte al administrador.");
		}
		
		$this->response($resulSet);
	}

	public function getDash_get(){
		$this->load->model('UsuarioM');
		// //Forma normal dde recibir los datos
		// $payload = json_decode($this->input->get('payload'));
		// $token = $payload->token;
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$token = $this->input->get('token');

		try{
			$arrOfToken = AUTHORIZATION::validateToken($token);

			$idUser = $arrOfToken->idUser;
			$idSesion = $arrOfToken->session;

			$resultQuery = $this->UsuarioM->GetDash($idUser,$idSesion);
			
			// $resulSet = $resultQuery;

			if(!array_key_exists('error',$resultQuery)){
				$resulSet = $resultQuery;
			}else{
				$resulSet = array("error" => 103, "message" => "Contact the administrator.");
			}
			
		}catch(Exception $e){
			$resulSet = array("error" => 104, 'message' => "Error contacte al administrador.");
		}

		$this->response($resulSet);
	}

	public function test_post(){
		//$payload = $this->input->post('payload');

		//$this->response(array("key" => $payload['userName']));
		//$this->response(array("key" => 1));
		//$payload = json_decode($this->input->post(true));
		$userName = $this->input->post('userName');
		if(!empty($userName)){
			$this->response(array("userName" => $userName));
		}else{
			$this->response(array("key" => "No llega valor"));
		}


	}

	public function createReport_get(){
		CreatorPDF::createReport();
		//$this->response(array("key" => "Hola"));
	}
}
