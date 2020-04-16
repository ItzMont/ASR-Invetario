$(document).ready(function(){
    var token2=localStorage.getItem("tokenPrincipal");
    console.log(token2);
    var id;
    
    $.ajax({
        url: 'http://localhost:8080/ASR-Inventario/Back-End/Usuario/getDash',
        type: 'GET',
        data: { 'token': token2 },
        datatype: "JSON",
        success: function(response){

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