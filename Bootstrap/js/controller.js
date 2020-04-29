$(document).ready(function(){
    var token2=localStorage.getItem("tokenPrincipal");
    console.log(token2);
    var id;
    
    

    $.ajax({
        url: 'http://localhost/Proyecto/Back-End/Usuario/getDash',
        type: 'GET',
        data: { 'token': token2 },
        datatype: "JSON",
        success: function(response){
            console.log(response)
            var tabla = response;
            let i = '';
            tabla.forEach(tabla => {
                i += `<tr>
                <td><a>${tabla.idproducto} </a></td>
                <td>${tabla.serial_num}</td>
                <td>${tabla.color}</td>
                <td>${tabla.brand}</td>
                <td>${tabla.model}</td>
                <td>${tabla.area}</td>
                <td>${tabla.edificio}</td>
                <td>${tabla.estado}</td>
                <td><button type="submit" class="btn btn-outline-dark btn-sm" value="${tabla.idproducto}" id="modificar">Modificar </button> </td>
                </tr>` 
                    
            });
            $('#myTable').html(i);
        }

        
    })

    
        
  

        $('#modificar').click(function(){
          //$(this).hide();
            //localStorage.removeItem($(this).val()); 
            //alert($(this).val());
            
            //var idProducto = $(this).val();
            //alert(idProducto);
            //console.log(idProducto);
            //localStorage.setItem("idProducto",idProducto); 
            //alert("Funciono");
            window.location.href = "modificaciones.html";
            id=document.getElementById("modificar").value;
            alert(id);
        });

/*
        function modifyProd(id){
        id=document.getElementById("#modificar").value;
        alert(id);
    }
    
/* $(document).on("click",'#modificar',(function(e){    
        var idProducto = $(this).val();
        alert(idProducto);
        console.log(idProducto);
        localStorage.setItem("idProducto",idProducto); 
        alert("Funciono");
        //window.location.href = "modificaciones.html";
    }));
*/
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
            url: 'http://localhost/Proyecto/Back-End/Usuario/getDash',
            type: 'GET',
            success: function(response){
                console.log(response);
            }
        })
    })

});