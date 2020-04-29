<?php
    defined('BASEPATH') OR exit('No direct script access allowed');
    require APPPATH . '/third_party/fpdf/fpdf.php';
    
    const URL_IMG = "./img/";

    class CreatorPDF extends FPDF{
        private $font;
        private $fontSize;
        private $marginSize = 10;

        private static $headerHeight = 80;

        function header(){
            //Variables
            $this->font = 'Arial';
            $this->fontSize = 15;

            //Dimentions of header
            $headerHeight = 15;

            //Dimentions of logo
            $logoWidth = $headerHeight;
            $logoheight = $headerHeight;

            //Get the position of x and y for render 
            $positionX = $this->GetX();
            $positionY = $this->GetY();

            // Arial bold 15
            $this->SetFont($this->font,'B',$this->fontSize);

            // Título
            $this->Cell(0,$headerHeight,'ASR-Inventario',0,0,'C');

            //Set date
            $this->SetFont('Arial','B',$this->fontSize - 5);
            $dateWiddth = 30;
            $dateHeight = $headerHeight;

            $this->SetX($this->GetX() - $dateWiddth);

            $this->Cell($dateWiddth,$dateHeight,'Fecha: 28/04/2020',0,0,'C');

            //Set the positions for render title in line of logo ASR
            $this->SetX($positionX);
            $this->SetY($positionY);

            $this->Image(URL_IMG.'ASR_logo.jpeg',null,null,$logoWidth,$logoheight);
            
            // Salto de línea
            //$this->Ln(5);
            $this->Ln(30);

            
        }

        // Pie de página
        function Footer()
        {
            // Posición: a 1,5 cm del final
            $this->SetY(-15);
            // Arial italic 8
            $this->SetFont('Arial','B',8);
            // Número de página
            $this->Cell(0,10,'Page '.$this->PageNo().'/{nb}',0,0,'C');
        }

        function putWaterMarkIMG(){
            $waterMarkWidth = 130;
            $waterMarkHeight = 130;

            //Set the tranparency for image
            $this->SetAlpha(0.3);

            //Calculate of x and y to center the image
            $waterMark_PX = ($this->GetPageWidth() - $waterMarkWidth) / 2;
            $waterMark_PY = ($this->GetPageHeight() - $waterMarkHeight) / 2;

            $this->Image(URL_IMG.'FCC_logo.png',$waterMark_PX,$waterMark_PY,$waterMarkWidth,$waterMarkHeight);

            //Restore full opacity
            $this->SetAlpha(1);
        }

        function createReportAllProducts($dataMatrix){
            //Functions for construction of format
            $this->AliasNbPages();
            $this->AddPage();

             // Título del reporte
             $this->SetFont($this->font,'B',$this->fontSize - 1);
             $this->Cell(0,$this->fontSize / 2,'Reporte de todos los productos',1,0,'C');
             $this->Ln();
             $this->Ln(3);

             //Variables
             $this->font = 'Arial';
             $this->fontSize = 8;

            $this->SetFont($this->font,'B',$this->fontSize);

            //Body Format
            $header = array(    "ID Inventario",
                                "No. Serial",
                                "Color",
                                "Marca",
                                "Modelo",
                                "ID Area",
                                "ID Ubicacion",
                                "Estado"
                            );


            $this->printMatrix($header,$dataMatrix);
            $this->putWaterMarkIMG();
            $this->Output();
        }


        function printMatrix($header,$matrix = null){
            //Set size width for columns
            $widthColumn = ($this->GetPageWidth() - (2 * $this->marginSize))  / sizeof($header);

            for($i = 0; $i< sizeof($header); $i++){
                $this->Cell($widthColumn,$this->fontSize/2,$header[$i],1,0,'C'); 
            }

            //Salto de linea para los valores de la matriz

            $this->Ln();

            $this->SetFont($this->font,'',$this->fontSize);

            foreach($matrix as $row){
                foreach($row as $value){
                    $this->Cell($widthColumn,$this->fontSize/2,"EMPTY",1,0,'C'); 
                }
                $this->Ln();
            }

            // for($i = 0; $i< 40; $i++){
            //     for($j = 0; $j< sizeof($header); $j++){
            //         $this->Cell($widthColumn,$this->fontSize/2,"EMPTY",1,0,'C'); 
            //     }
            //     $this->Ln();
            // }
        }


        //=================================FUNCTIONS FOR TRANSPARENCY IN IMAGES
        protected $extgstates = array();

        // alpha: real value from 0 (transparent) to 1 (opaque)
        // bm:    blend mode, one of the following:
        //          Normal, Multiply, Screen, Overlay, Darken, Lighten, ColorDodge, ColorBurn,
        //          HardLight, SoftLight, Difference, Exclusion, Hue, Saturation, Color, Luminosity
        function SetAlpha($alpha, $bm='Normal')
        {
            // set alpha for stroking (CA) and non-stroking (ca) operations
            $gs = $this->AddExtGState(array('ca'=>$alpha, 'CA'=>$alpha, 'BM'=>'/'.$bm));
            $this->SetExtGState($gs);
        }

        function AddExtGState($parms)
        {
            $n = count($this->extgstates)+1;
            $this->extgstates[$n]['parms'] = $parms;
            return $n;
        }

        function SetExtGState($gs)
        {
            $this->_out(sprintf('/GS%d gs', $gs));
        }

        function _enddoc()
        {
            if(!empty($this->extgstates) && $this->PDFVersion<'1.4')
                $this->PDFVersion='1.4';
            parent::_enddoc();
        }

        function _putextgstates()
        {
            for ($i = 1; $i <= count($this->extgstates); $i++)
            {
                $this->_newobj();
                $this->extgstates[$i]['n'] = $this->n;
                $this->_put('<</Type /ExtGState');
                $parms = $this->extgstates[$i]['parms'];
                $this->_put(sprintf('/ca %.3F', $parms['ca']));
                $this->_put(sprintf('/CA %.3F', $parms['CA']));
                $this->_put('/BM '.$parms['BM']);
                $this->_put('>>');
                $this->_put('endobj');
            }
        }

        function _putresourcedict()
        {
            parent::_putresourcedict();
            $this->_put('/ExtGState <<');
            foreach($this->extgstates as $k=>$extgstate)
                $this->_put('/GS'.$k.' '.$extgstate['n'].' 0 R');
            $this->_put('>>');
        }

        function _putresources()
        {
            $this->_putextgstates();
            parent::_putresources();
        }
            
    }
?>


