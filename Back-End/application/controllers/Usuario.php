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

require_once 'SessionController.php';

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
				if(SessionController::CreateSession($resulSet['idsession'],$resulSet['idusuario'],$resulSet['token'])){
					
					unset($resulSet['idsession']);
					unset($resulSet['idusuario']);
			
					$this->response($resulSet);
				}else{
					$resulSet = array("error" => 101, "message" => "Contact the administrator.");
				}
			}else{
				$resulSet = array("error" => 101, "message" => "Contact the administrator.");
			}
		}
		else
			$resulSet = array("error" => 100, "message" => "Credentials are incorrect.");
		
		$this->response($resulSet);
	}


	/*
	public function test_get(){
        $this->load->model('UsuarioM');
        $array = $this->UsuarioM->getUsuarioID();
        $result = $array->result_array();
		$this->response($result);
	}

	//=================FUNCIONES DE TIPO POST=================//
	public function login_post(){
		$email = $this->input->post('email');
		$contra = $this->input->post('contra');
		$this->load->model('UsuarioM');
		$result = $this->UsuarioM->validatedLogin($email,$contra);
		$result = $result->result_array();
		if(!empty($result)){
			$respuesta = array("respuesta" => "Inicio de sesion exitoso","error" => 0);
		}else if(empty($result)){
			$respuesta = array("respuesta" => "Error comprueba sus credenciales", "error" => 11);
		}else{
			$respuesta = array("respuesta" => "Error al ejecutar su operación", "error" => 12);
		}
		$this->response($respuesta);
	}

	public function createAbogado_post(){
		$nombre = $this->input->post('nom');
		$apellidoP = $this->input->post('apeP');
		$apellidoM = $this->input->post('apeM');
		$email = $this->input->post('email');
		$pass = $this->input->post('contra');
		$fechaNac = $this->input->post('fechaN');
		$cuentaBanco = $this->input->post('cuentBanc');
		$costoBase = $this->input->post('costBas');
		$descripcion = $this->input->post('descri');
		$cedulaPro = $this->input->post('ceduPro');
		$this->load->model('UsuarioM');
		$resultId = $this->UsuarioM->createAbo($nombre,$apellidoP,$apellidoM,$email,$pass,$fechaNac,$cuentaBanco,$costoBase,$descripcion,$cedulaPro);
		if($resultId != false){
			$respuesta = array("respuesta" => "Se creo el abogado exitosamente","id:" => $resultId,"error" => 0);
		}else{
			$respuesta = array("respuesta" => "Error al crear cliente", "error" => 11);
		}
		$this->response($respuesta);
	}

	public function createClient_post(){
		$nombre = $this->input->post('nom');
		$apellidoP = $this->input->post('apeP');
		$apellidoM = $this->input->post('apeM');
		$email = $this->input->post('email');
		$pass = $this->input->post('contra');
		$fechaNac = $this->input->post('fechaN');
		$metodoPago = $this->input->post('metoPago');
		$this->load->model('UsuarioM');
		$resultId = $this->UsuarioM->createCli($nombre,$apellidoP,$apellidoM,$email,$pass,$fechaNac,$metodoPago);
		if($resultId != false){
			$respuesta = array("respuesta" => "Se creo el cliente exitosamente","id:" => $resultId,"error" => 0);
		}else{
			$respuesta = array("respuesta" => "Error al crear cliente", "error" => 11);
		}
		$this->response($respuesta);
	}

	//=================FUNCIONES DE TIPO GET=================//
	public function abogadoID_get(){
		$id = $this->input->get('id');
        $this->load->model('UsuarioM');
        $array = $this->UsuarioM->getAbogadoID($id);
        $result = $array->result_array();
		if(!empty($result)){
			$respuesta = array("respuesta" => "Se obtuvieron los datos correctamente.","resultado" => $result,"error" => 0);
		}else if(empty($result)){
			$respuesta = array("respuesta" => "Error compruebe su informacion", "error" => 11);
		}else{
			$respuesta = array("respuesta" => "Error al ejecutar su operación", "error" => 12);
		}
		$this->response($respuesta);
	}

	public function clienteID_get(){
		$id = $this->input->get('id');
        $this->load->model('UsuarioM');
        $array = $this->UsuarioM->getClientID($id);
        $result = $array->result_array();
		if(!empty($result)){
			$respuesta = array("respuesta" => "Se obtuvieron los datos correctamente.","resultado" => $result,"error" => 0);
		}else if(empty($result)){
			$respuesta = array("respuesta" => "Error compruebe su informacion", "error" => 11);
		}else{
			$respuesta = array("respuesta" => "Error al ejecutar su operación", "error" => 12);
		}
		$this->response($respuesta);
	}*/
}
