$(document).ready(function(){
    var token = localStorage.getItem("tokenPrincipal");
    console.log(token);
    var idProduct = localStorage.getItem("idProducto");
    console.log("ID: "+idProduct);

    
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
        var idProduct = localStorage.getItem("idProducto");
        console.log(idProduct);

        $.ajax({
            url: 'http://localhost/ASR-Inventario/Back-End/Usuario/updateProduct',
            type: 'POST',
            data: { 
                'token': token,
                'idProduct': idProduct,
                'material': material,
                'marca': marca,
                'color': color,
                'idLab': idLab,
                'idProd':idProd
            },
            dataType: "json",
            success: function(response){
                console.log(response);
                alert("Se modificó correctamente");
                window.location.href = "dash.html";
            }
        })
    }

    

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
});