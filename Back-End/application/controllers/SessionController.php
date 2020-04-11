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

class SessionController extends CI_Controller{

	use REST_Controller {
		REST_Controller::__construct as private __resTraitConstruct;
    }
	
	public static function CreateSession($idsession,$idusuario,$token){
        $session = session_id($idsession);
        if(session != ""){
            session_start();

            $_SESSION["user"] = $idusuario;
            $_SESSION["token"] = $token;

            session_write_close();

            return true;
        }else{
           return false; 
        }    
    }
}
