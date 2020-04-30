$(document).ready(function(){
    var token = localStorage.getItem("tokenPrincipal");
    console.log(token);
    
    $('#btnAceptarID').click(function (e) { 
        e.preventDefault();
        addProdct();
    });
    
    function addProdct(){
        var material = $('#material').val();
        var marca = $('#marca').val();
        var color = $('#color').val();
        var idLab = $('#idLab').val();
        var idProd = $('#idProd').val();



        $.ajax({
            url: 'http://localhost/Proyecto/Back-End/Usuario/addProduct',
            type: 'POST',
            data: { 
                'token': token,
                'material': "NORMAL",
                'marca': marca,
                'color': color,
                'idLab': idLab,
                'idProd':idProd
            },
            dataType: "json",
            success: function(response){
                console.log(response);
                alert("Se agrego correctamente");
                window.location.href = "dash.html";
            }
        })
    }

    

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
});