$(document).ready(function(){
    var token2=localStorage.getItem("tokenPrincipal");
    console.log(token2);
    
    
    $.ajax({
        url: 'http://localhost:8080/ASR-Inventario/Back-End/Usuario/getDash',
        type: 'GET',
        data: { token: token2 },
        success: function(response){
            console.log(response);

            var table = "<table class='table table-responsive-sm table-responsive-md'><tbody>";

            response.forEach(element => {
                
            });


            table += "</tbody></table>";
        }
    })

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
});