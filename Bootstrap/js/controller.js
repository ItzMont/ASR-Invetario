$(document).ready(function(){
    var token2=localStorage.getItem("tokenPrincipal");
    console.log(token2);
    var id;
    
    $.ajax({
        url: 'http://localhost/ASR-Inventario/Back-End/Usuario/getDash',
        type: 'GET',
        data: { 'token': token2 },
        datatype: "JSON",
        success: function(response){
            var tabla = response;
            let i = ``;
            tabla.forEach(tabla => {
                i += `<tr>
                <td><a href="modificaciones.html" id="modificar">${id = tabla.inventarynum} </a></td>
                <td>${tabla.serialnum}</td>
                <td>${tabla.color}</td>
                <td>${tabla.brand}</td>
                <td>${tabla.model}</td>
                <td>${tabla.area}</td>
                <td>${tabla.edificio}</td>
                <td>${tabla.estado}</td>
                <td> <a href="modificaciones.html"></a> </td>
                </tr>` 
                    
            });
            $('#myTable').html(i);
        }
    })

    $(document).on("click",'#modificar',(function(e){    
        var idProducto = id;
        localStorage.setItem("idProducto",idProducto); 
        console.log(idProducto);
        alert("Funciono");     
    }));

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
    $('#myInput').keyup(function(){
        let search = $('#myInput').val();
        console.log(search);
        $.ajax({
            url: 'http://localhost/ASR-Inventario/Back-End/Usuario/getDash',
            type: 'GET',
            success: function(response){
                console.log(response);
            }
        })
    })
});