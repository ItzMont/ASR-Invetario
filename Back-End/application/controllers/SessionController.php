<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class SessionController extends CI_Controller{

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
