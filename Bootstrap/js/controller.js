$(document).ready(function(){
    var token2=localStorage.getItem("tokenPrincipal");
    console.log(token2);
    
    
    $.ajax({
        url: 'http://localhost:8080/ASR-Inventario/Back-End/Usuario/getDash',
        type: 'GET',
        data: { token: token2 },
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

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
});