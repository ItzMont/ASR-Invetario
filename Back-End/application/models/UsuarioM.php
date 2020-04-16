<?php
    class UsuarioM extends CI_Model {
        
        public function __construct(){
            parent::__construct();
            $this->load->database();
        }

        public function verifiyCount($userName,$contra){
            $query = $this->db->query("CALL GetUserForLogin(".$this->db->escape($userName).")");
            $passHashed =  $query->row_array();
            mysqli_next_result( $this->db->conn_id);
            if(!empty($passHashed)){
                //$passHashed = password_hash($contra, PASSWORD_DEFAULT, ['cost' => 15]);
                if(password_verify($contra,$passHashed['contraASR'])){
                    return true;
                }
            }else{
                return false;
            }
        }

        public function ContinueLoginSucceful($userName){
            $query = $this->db->query("CALL GetUserByUserName(".$this->db->escape($userName).")");
            $dataUser = $query->row_array();
            mysqli_next_result( $this->db->conn_id);
            if(!empty($dataUser)){
                $query = $this->db->query("CALL CreateSession(".$this->db->escape($dataUser['idusuario']).",@idsession)");
                $idsessionUser = $query->row_array();
                mysqli_next_result( $this->db->conn_id);
                
                if(!empty($idsessionUser)){
                    $resultSet = array_merge($dataUser,$idsessionUser);
                   
                }else{
                    unset($dataUser);
                    $resultSet = array("error" => 11, "message" => "No se pudo crear una session para el usuario");
                }
            }else{
                $resultSet = array("error" => 10, "message" => "No se encontraron datos del usuario.");
            }
            return $resultSet;
        }

        public function CloseSession($iduser){
            $query = $this->db->query("CALL LogOut(".$this->db->escape($iduser).")");
            $result = $this->db->affected_rows();
            mysqli_next_result($this->db->conn_id);
            
            if($result == 1){
                return array();
            }elseif($result > 1){
                return array("error" => 201 );
            }else{
                return array("error" => 202 );
            }
        }

        public function GetDash($idUser,$idSesion){
            if($this->ValidatedUser($idUser,$idSesion)){
                $query = $this->db->query("CALL GetDashAdmin()");
                $resultSet = $query->result_array(); 
                mysqli_next_result($this->db->conn_id);
            }else{
                $resultSet = array("error" => 302 );
            }

            return $resultSet;
        }

        public function ValidatedUser($idUser,$idSesion){
            $query = $this->db->query("CALL ValidatedSessionUser(".$this->db->escape($idUser).",".$this->db->escape($idSesion).")");
            $result = $query->row_array();
            mysqli_next_result($this->db->conn_id);
            if(!empty($result)){//Refinar esto comprobando si el resultado efectivamente fue 1
                return true;
            }else{
                // return false;
                return true;
            }
        }
    }
