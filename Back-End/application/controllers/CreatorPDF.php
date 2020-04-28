<?php
    defined('BASEPATH') OR exit('No direct script access allowed');
    require APPPATH . '/third_party/fpdf/fpdf.php';
    //require_once APPPATH.'controllers/';
    //require_once 'logoFCC.png';

    //require './../img';
    class CreatorPDF{
        //$URL_IMG = './../../img';
        public static $headerHeight = 80;

        public static function createReport(){
            //$img = 'logoFCC.png'
            //echo $img;
            
            $pdf = new FPDF();
            $pdf->AddPage("L");
            
            //$this->header();
            $pdf->SetFont('Arial','B',16);
            //$pdf->Image('logoFCC',10,8,33,0,'PNG');
            $pdf->Cell(40,10,'¡Hola, Mundo!',1);
            $pdf->Image('./img/logoFCC.png',10,10,-300);
            $pdf->Output();
        }


        // public static function createReport(){
        //     // $directorio = './application/controllers/logoFCC.png';
        //     // $ficheros1  = scandir($directorio);
            
        //     // print_r($ficheros1);


        //     if(file_exists('./application/controllers/logoFCC.png'))
        //         echo 'El archivo existe';
        //     else    
        //         echo 'El archivo no existe';
        // }


        private function header(){
            //$this->Image('logoFCC.png',10,8,33);
        }
    }
?>


