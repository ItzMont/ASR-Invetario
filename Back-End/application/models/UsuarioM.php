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
            $query = $this->db->query("CALL InitSession(".$this->db->escape($userName).")");
            $resultSet = $query->result();
            //mysqli_next_result( $this->db->conn_id);
            if(!empty($resultSet)){
                $arrData = array("idUser" => $resultSet['idusuario'],"session" =>  $resultSet['idsession']);
                $token = AUTHORIZATION::generateToken($arrData);
                if(CreateSession($resultSet['idsession'],$resultSet['idusuario'],$token)){
                    $resultSet = array_push($resultSet,$token);
                }else{
                    return array("error" => "No se pudo crear la sesion.");
                }
            }
            return $resultSet;
        }

        

        private function CreateSession($idsession,$idUser,$token){
            $query = $this->db->query("CALL CreateSession(".$this->db->escape($idsession).",".$this->db->escape($idUser).",".$this->db->escape($token).")");
            $result = $query->row_array();
            mysqli_next_result($this->db->conn_id);
            return $result;
        }

        function getUsuarioID(){
            $query =    "
                            SELECT
                                *
                            FROM
                                usuario
                        ";
            return $this->db->query($query);

        }

        //=================FUNCIONES DE TIPO POST=================//
        function validatedLogin($email,$contra){
            $query =    "SELECT
                            id_usuario,
                            nombre,
                            apellidoP,
                            apellidoM,
                            email,
                            fechaNac,
                            nombreRol,
                            valuePermission
                        FROM
                            usuario
                            LEFT JOIN(rol) ON usuario.rol_id = rol.id_rol
                        WHERE
                            usuario.email = ".$this->db->escape($email)." AND
                            pass = ".$this->db->escape($contra)."
                        ";
            return $this->db->query($query);
        }

        function createAbo($nombre,$apellidoP,$apellidoM,$email,$pass,$fechaNac,$cuentaBanco,$costoBase,$descripcion,$cedulaPro){
            $query =    "INSERT INTO usuario(
                            nombre,
                            apellidoP,
                            apellidoM,
                            email,
                            pass,
                            fechaNac,
                            rol_id
                        )
                        VALUES(
                            ".$this->db->escape($nombre).",
                            ".$this->db->escape($apellidoP).",
                            ".$this->db->escape($apellidoM).",
                            ".$this->db->escape($email).",
                            ".$this->db->escape($pass).",
                            ".$this->db->escape($fechaNac).",
                            2
                        )
                        ";
            $result = $this->db->query($query);
            if($result){
                $utlimoID = $this->db->insert_id();
                $query =    "INSERT INTO abogado(
                                cuentaBanco,
                                costoBase,
                                descripcion,
                                cedulaPro,
                                usuario_id
                            )
                            VALUES(
                                ".$this->db->escape($cuentaBanco).",
                                ".$this->db->escape($costoBase).",
                                ".$this->db->escape($descripcion).",
                                ".$this->db->escape($cedulaPro).",
                                ".$utlimoID."
                            )
                            ";
                $result = $this->db->query($query);
                if($result)
                    $result = $utlimoID;
            }
            return $result;
        }

        function createCli($nombre,$apellidoP,$apellidoM,$email,$pass,$fechaNac,$metodoPago){
            $query =    "INSERT INTO usuario(
                            nombre,
                            apellidoP,
                            apellidoM,
                            email,
                            pass,
                            fechaNac,
                            rol_id
                        )
                        VALUES(
                            ".$this->db->escape($nombre).",
                            ".$this->db->escape($apellidoP).",
                            ".$this->db->escape($apellidoM).",
                            ".$this->db->escape($email).",
                            ".$this->db->escape($pass).",
                            ".$this->db->escape($fechaNac).",
                            3
                        )
                        ";
            $result = $this->db->query($query);
            if($result){
                $utlimoID = $this->db->insert_id();
                $query =    "INSERT INTO cliente(
                                metodoPago,
                                usuario_id
                            )
                            VALUES(
                                ".$this->db->escape($metodoPago).",
                                ".$utlimoID."
                            )
                            ";
                $result = $this->db->query($query);
                if($result)
                    $result = $utlimoID;
            }
            return $result;
        }

        //=================FUNCIONES DE TIPO GET=================//
        function getAbogadoID($id){
            $query =    "SELECT
                            nombre,
                            apellidoP,
                            apellidoM,
                            email,
                            fechaNac,                            
                            valuePermission,
                            cuentaBanco,
                            costoBase,
                            descripcion,
                            cedulaPro
                        FROM
                            usuario
                            LEFT JOIN(rol) ON usuario.rol_id = rol.id_rol 
                            LEFT JOIN(abogado) ON usuario.id_usuario = abogado.usuario_id
                        WHERE
                            usuario.id_usuario = ".$this->db->escape($id)." AND
                            rol.valuePermission = 1
                        ";
            return $this->db->query($query);
        }

        function getClientID($id){
            $query =    "SELECT
                            nombre,
                            apellidoP,
                            apellidoM,
                            email,
                            fechaNac,                            
                            valuePermission,
                            metodoPago
                        FROM
                            usuario
                            LEFT JOIN(rol) ON usuario.rol_id = rol.id_rol 
                            LEFT JOIN(cliente) ON usuario.id_usuario = cliente.usuario_id
                        WHERE
                            usuario.id_usuario = ".$this->db->escape($id)." AND
                            rol.valuePermission = 2
                        ";
            return $this->db->query($query);
        }

    }
