<?php
defined('BASEPATH') OR exit('No direct script access allowed');
// header('Access-Control-Allow-Origin: *');
// header("Content-Type: multipart/form-data ; charset=utf-8");
// header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");


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
	
	public function test_get(){
		$this->response(array('1' => 'Hola'));
	}

	public function testPDF_get(){
		$pdf = new CreatorPDF();
		$pdf->AddPage();
		$pdf->SetFont('Arial','B',16);
		$pdf->Cell(40,10,'Hello World!');
		$pdf->Output();
	}

	public function loginTest_post(){
		$this->load->model('UsuarioM');
		$respone = $this->UsuarioM->verifiyCount("hola","hola");
		$this->response(array($respone));
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

		if(!empty($userName) && !empty($contra)){
			if($this->UsuarioM->verifiyCount($userName,$contra)){
				$resulSet = $this->UsuarioM->ContinueLoginSucceful($userName);
				if(!empty($resulSet) && !array_key_exists('error' , $resulSet)){
					$arrToToken = array("idUser" => $resulSet['idusuario'],"session" => $resulSet["idsession"]);
					$token = AUTHORIZATION::generateToken($arrToToken);
	
					unset($resulSet['idsession']);
					unset($resulSet['idusuario']);
			
					$resulSet = array_merge($resulSet,["token" => $token],["error" => 0]);
					$this->response($resulSet);

					// $this->response(array('aqui es donde deberia ir el token',$resulSet));
	
				}else{
					$resulSet = array("error" => 101, "message" => "Contact the administrator.","result" => $resulSet);
				}
			}
			else
				$resulSet = array("error" => 100, "message" => "Credentials are incorrect.");
			
			$this->response($resulSet);
		}else{
			$this->response(array('respuesta','no se enviaron valores'));
			// header('Location: ./../../index.html');
		}

		//$this->response(array($userName,$contra));
	}

	public function logout_post(){
		$this->load->model('UsuarioM');
		// //Forma normal dde recibir los datos
		// $payload = json_decode($this->input->post('payload'));
		// $token = $payload->token;
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$token = $this->input->post('token');

		if(!empty($token)){
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
		}else{
			header('Location: ./../../index.html');
		}

		
	}

	public function addProduct_post(){
		$this->load->model('UsuarioM');


		$token = $this->input->post('token');
		$responsable = $this->input->post('responsable');
		$marca = $this->input->post('marca');
		$color = $this->input->post('color');
		$idLab = $this->input->post('idLab');
		$idProd = $this->input->post('idProd');

		// $resulSet = $idProd;
		
		// $this->response(array(
		// 	"token" => $token,
		// 	"responsable" => $responsable,
		// 	"marca" => $marca,
		// 	"color" => $color,
		// 	"idLab" => $idLab,
		// 	"idProd" => $idProd
		// ));

		if(!empty($token)){
			try{
				$arrOfToken = AUTHORIZATION::validateToken($token);
	
				$idUser = $arrOfToken->idUser;
				$idSesion = $arrOfToken->session;
	
				
	
				$resultQuery = $this->UsuarioM->InsertProduct($idUser,$idSesion,$idLab,$idProd,$color,$marca,$responsable);
				
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
		}else{
			header('Location: ./../../index.html');
		}

		
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
		$tipoEstado = $this->input->post('tipoEstado');

		$resulSet = $idProd;
		
		if(!empty($token) && !empty($idProduct)){
			try{
				$arrOfToken = AUTHORIZATION::validateToken($token);
	
				$idUser = $arrOfToken->idUser;
				$idSesion = $arrOfToken->session;
	
				
	
				$resultQuery = $this->UsuarioM->UpdateProduct($idUser,$idSesion,$idProduct,$idLab,$idProd,$color,$marca,$tipoEstado);
				
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
		}else{
			header('Location: ./../../index.html');
		}

		
	}

	public function getDash_get(){
		$this->load->model('UsuarioM');
		// //Forma normal dde recibir los datos
		// $payload = json_decode($this->input->get('payload'));
		// $token = $payload->token;
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$token = $this->input->get('token');

		if(!empty($token)){
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
		}else{
			header('Location: ./../../index.html');
		}
	}

	public function getProduct_get(){
		$this->load->model('UsuarioM');
		// //Forma normal dde recibir los datos
		// $payload = json_decode($this->input->get('payload'));
		// $token = $payload->token;
		// $productID = $payload->productID;
		//=====================================================
		//Forma para el Front-End de recuperar la informacion
		$token = $this->input->get('token');
		$productID = $this->input->get('productID');

		if(!empty($token) && !empty($productID)){
			try{
				$arrOfToken = AUTHORIZATION::validateToken($token);
	
				$idUser = $arrOfToken->idUser;
				$idSesion = $arrOfToken->session;
	
				$resultQuery = $this->UsuarioM->GetProductByID($idUser,$idSesion,$productID);
				
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
		}else{
			header('Location: ./../../index.html');
		}
	}

	public function getDocentesForDD_get(){
		$this->load->model('UsuarioM');
		$token = $this->input->get('token');
		
		if(!empty($token)){
			try{
				$arrOfToken = AUTHORIZATION::validateToken($token);
	
				$idUser = $arrOfToken->idUser;
				$idSesion = $arrOfToken->session;
	
				$resultQuery = $this->UsuarioM->getDocDD($idUser,$idSesion);
				
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
		}else{
			header('Location: ./../../index.html');
		}
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


	//=========NO TIENE BUEN FUNCIONAMIENTO PORQUE ES NECESARIO DEFINIR UN DASH
	
	// public function createReportAllProducts_get(){
	// 	$this->load->model('UsuarioM');
	// 	// //Forma normal dde recibir los datos
	// 	// $payload = json_decode($this->input->get('payload'));
	// 	// $token = $payload->token;
	// 	//=====================================================
	// 	//Forma para el Front-End de recuperar la informacion
	// 	$token = $this->input->get('token');
		
	// 	if(!empty($token)){
	// 		try{
	// 			$arrOfToken = AUTHORIZATION::validateToken($token);
	
	// 			$idUser = $arrOfToken->idUser;
	// 			$idSesion = $arrOfToken->session;
	
	// 			$resultQuery = $this->UsuarioM->GetDash($idUser,$idSesion);
	
	// 			if(!array_key_exists('error',$resultQuery)){
	
	// 				$pdf = new CreatorPDF();
	
	// 				$pdf->createReportAllProducts($resultQuery);
	
	// 				$pdf->Output('D','MyPDF.pdf');
	// 			}else{
	// 				$resulSet = array("error" => 103, "message" => "Contact the administrator.");
	// 			}
				
	// 		}catch(Exception $e){
	// 			$resulSet = array("error" => 104, 'message' => "Error contacte al administrador.");
	// 		}
	// 	}else{
	// 		// header('Location: ./../../index.html');
	// 	}

	// 	// $pdf = new CreatorPDF();
	// 	// $pdf->createReportAllProducts('hola');








	// 	//=======
	// 	// $resultQuery = $this->UsuarioM->GetDash(1,5);
	
	// 	// if(!array_key_exists('error',$resultQuery)){

	// 	// 	$pdf = new CreatorPDF();

	// 	// 	$pdf->createReportAllProducts($resultQuery);

	// 	// }else{
	// 	// 	$resulSet = array("error" => 103, "message" => "Contact the administrator.");
	// 	// }

		
		
	// }
}
