$(document).ready(function(){
    var token2=localStorage.getItem("tokenPrincipal");
    console.log(token2);
    
    
    $.ajax({
        url: 'http://localhost/ASR-Inventario/Back-End/Usuario/getDash',
        type: 'GET',
        data: { token: token2 },
        success: function(response){
            console.log(response);
        }
    })

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
});