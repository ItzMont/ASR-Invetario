$(document).ready(function(){
    var token2=localStorage.getItem("tokenPrincipal");
    var id;
    

    $.ajax({
        url: 'https://asrinventario.000webhostapp.com/Back-End/Usuario/getDash',
        type: 'GET',
        data: { 'token': token2 },
        datatype: "JSON",
        success: function(response){
            $('#columna1').text("ID Inventario");
            $('#columna2').text("No. Serial");
            $('#columna3').text("Color");
            $('#columna4').text("Marca");
            console.log(response)
            var tabla = response;
            let i = '';
            tabla.forEach(tabla => {
                i += `<tr>
                <td><a>${tabla.idproducto} </a></td>
                <td>${tabla.serial_num}</td>
                <td>${tabla.color}</td>
                <td>${tabla.brand}</td>
                
                <td>${tabla.area}</td>
                <td>${tabla.edificio}</td>
                <td>${tabla.tipoEstado}</td>
                <td><button type="submit" class="btn btn-outline-dark btn-sm" value="${tabla.idproducto}" id="modificar">Modificar </button> </td>
                </tr>` 
                    
            });
            $('#myTable').html(i);
        }
    })
    /*-------------Linea dentro de la tabla quitada por problema con modificar y dar de alta---------------------------------------------------------
    <td>${tabla.model}</td>
    */
    $(document).on("click",'#modificar',(function(e){    
        var idProducto = $(this).val();
        //alert(idProducto);
        //console.log(idProducto);
        localStorage.setItem("idProducto",idProducto); 
        //alert("Funciono");
        window.location.href = "modificaciones.html";
    }));

    //-----------------------------------------------------------------------------
        
    $('#id_inven').click(function(){
        $.ajax({
            url: 'https://asrinventario.000webhostapp.com/Back-End/Usuario/getDash',
            type: 'GET',
            data: { 'token': token2 },
            datatype: "JSON",
            success: function(response){
                console.log(response)

                $('#columna1').text("ID Inventario");
                $('#columna2').text("No. Serial");
                $('#columna3').text("Color");
                $('#columna4').text("Marca");
                
                var tabla = response;
                let i = '';
                tabla.forEach(tabla => {
                    i += `<tr>
                    <td><a>${tabla.idproducto} </a></td>
                    <td>${tabla.serial_num}</td>
                    <td>${tabla.color}</td>
                    <td>${tabla.brand}</td>
                    
                    <td>${tabla.area}</td>
                    <td>${tabla.edificio}</td>
                    <td>${tabla.estado}</td>
                    <td><button type="submit" class="btn btn-outline-dark btn-sm" value="${tabla.idproducto}" id="modificar">Modificar </button> </td>
                    </tr>` 
                        
                });
                $('#myTable').html(i);
            }
        })
    });

    $('#no_serial').click(function(){
        $.ajax({
            url: 'https://asrinventario.000webhostapp.com/Back-End/Usuario/getDash',
            type: 'GET',
            data: { 'token': token2 },
            datatype: "JSON",
            success: function(response){
                console.log(response)

                $('#columna1').text("No. Serial");
                $('#columna2').text("ID Inventario");
                $('#columna3').text("Color");
                $('#columna4').text("Marca");
                
                var tabla = response;
                let i = '';
                tabla.forEach(tabla => {
                    i += `<tr>
                    <td>${tabla.serial_num}</td>
                    <td><a>${tabla.idproducto} </a></td>
                    <td>${tabla.color}</td>
                    <td>${tabla.brand}</td>
                    
                    <td>${tabla.area}</td>
                    <td>${tabla.edificio}</td>
                    <td>${tabla.estado}</td>
                    <td><button type="submit" class="btn btn-outline-dark btn-sm" value="${tabla.idproducto}" id="modificar">Modificar </button> </td>
                    </tr>` 
                        
                });
                $('#myTable').html(i);
            }
        })            
    });

    $('#marca').click(function(){
        $.ajax({
            url: 'https://asrinventario.000webhostapp.com/Back-End/Usuario/getDash',
            type: 'GET',
            data: { 'token': token2 },
            datatype: "JSON",
            success: function(response){
                console.log(response)

                $('#columna1').text("Marca");
                $('#columna2').text("ID Inventario");
                $('#columna3').text("No. Serial");
                $('#columna4').text("Color");
                
                var tabla = response;
                let i = '';
                tabla.forEach(tabla => {
                    i += `<tr>
                    <td>${tabla.brand}</td>
                    <td><a>${tabla.idproducto} </a></td>
                    <td>${tabla.serial_num}</td>
                    <td>${tabla.color}</td>
                    
                    
                    <td>${tabla.area}</td>
                    <td>${tabla.edificio}</td>
                    <td>${tabla.estado}</td>
                    <td><button type="submit" class="btn btn-outline-dark btn-sm" value="${tabla.idproducto}" id="modificar">Modificar </button> </td>
                    </tr>` 
                        
                });
                $('#myTable').html(i);
            }
        })           
    });

    $('#color').click(function(){
        $.ajax({
            url: 'https://asrinventario.000webhostapp.com/Back-End/Usuario/getDash',
            type: 'GET',
            data: { 'token': token2 },
            datatype: "JSON",
            success: function(response){
                console.log(response)

                $('#columna1').text("Color");
                $('#columna2').text("ID Inventario");
                $('#columna3').text("No. Serial");
                $('#columna4').text("Marca");
                
                var tabla = response;
                let i = '';
                tabla.forEach(tabla => {
                    i += `<tr>
                    <td>${tabla.color}</td>
                    <td><a>${tabla.idproducto} </a></td>
                    <td>${tabla.serial_num}</td>
                    <td>${tabla.brand}</td>
                    
                    <td>${tabla.area}</td>
                    <td>${tabla.edificio}</td>
                    <td>${tabla.estado}</td>
                    <td><button type="submit" class="btn btn-outline-dark btn-sm" value="${tabla.idproducto}" id="modificar">Modificar </button> </td>
                    </tr>` 
                        
                });
                $('#myTable').html(i);
            }
        })            
    });

    //-----------------------------------------------------------------------------

    $('#btnAceptarID').click(function (e) { 
        e.preventDefault();
        addProdct();
    });
    

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
    $('#myInput').keyup(function(){
        let search = $('#myInput').val();
        console.log(search);
        $.ajax({
            url: 'https://asrinventario.000webhostapp.com/Back-End/Usuario/getDash',
            type: 'GET',
            success: function(response){
                console.log(response);
                var input, filter, table, tr, td, i, txtValue;
                input = document.getElementById("myInput");
                filter = input.value.toUpperCase();
                table = document.getElementById("myTable");
                tr = table.getElementsByTagName("tr");
                for (i = 0; i < tr.length; i++) {
                    td = tr[i].getElementsByTagName("td")[0];
                    if (td) {
                    txtValue = td.textContent || td.innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                    }       
                }
            }
        })
    })

});