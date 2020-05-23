$(document).ready(function(){
    var token = localStorage.getItem("tokenPrincipal");
    var idProducto = localStorage.getItem("idProducto");
    
    getProductInfo(token,idProducto);

    function getProductInfo(token,idProducto){
        //var id=Number(idProducto);
        //var tok=token.toString();
        //console.log("id "+id+" token "+ tok );

        $.ajax({
            url: 'http://rene.260mb.net/ID2/Back-End/Usuario/getProduct',
            type:'GET',
            data:{
                token: token,
                productID: idProducto
            },
            dataType: "json",
            success: function(response){
                var prod=response;
                $('#marca').val(prod[0]['brand']);
                $('#color').val(prod[0]['color']);
                $('#idLab').val(prod[0]['inventory_num']);
                $('#idProd').val(prod[0]['serial_num']);
               
            }
           
        }) 
    }
    
    $('#btnAceptarID').click(function (e) { 
        e.preventDefault();
        // console.log("Hola");
        var token = localStorage.getItem("tokenPrincipal");
        updateProduct(token);
    });
    
    function updateProduct(token){
        //var material = $('#material').val();
        var marca = $('#marca').val();
        var color = $('#color').val();
        var idLab = $('#idLab').val();
        var idProd = $('#idProd').val();
        var idProduct = localStorage.getItem("idProducto");

        var tipoEstado = $("input[name='options']:checked").val();
        // console.log(`El tipo estado es ${tipoEstado}`);

        
        $.ajax({
            url: 'http://rene.260mb.net/ID2/Back-End/Usuario/updateProduct',
            type: 'POST',
            data: { 
                'token': token,
                'idProduct': idProduct,
                'material': "material",
                'marca': marca,
                'color': color,
                'idLab': idLab,
                'idProd':idProd,
                'tipoEstado':tipoEstado
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