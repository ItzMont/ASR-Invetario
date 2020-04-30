$(document).ready(function(){
    var token = localStorage.getItem("tokenPrincipal");
    var idProducto = localStorage.getItem("idProducto");
    console.log(token);
    console.log(idProducto);
    getProductInfo(token,idProducto);

    function getProductInfo(token,idProducto){
        //var id=Number(idProducto);
        //var tok=token.toString();
        //console.log("id "+id+" token "+ tok );

        $.ajax({
            url: 'http://localhost/Proyecto/Back-End/Usuario/getProduct',
            type:'GET',
            data:{
                token: token,
                productID: idProducto
            },
            dataType: "json",
            success: function(response){
                console.log(response);
                var prod=response;
                console.log(prod);
                $('#marca').val(prod[0]['brand']);
                $('#color').val(prod[0]['color']);
                $('#idLab').val(prod[0]['inventory_num']);
                $('#idProd').val(prod[0]['serial_num']);
                /*
                console.log(prod);
                console.log(response[0]["brand"]);
                console.log(response['color']);
                console.log(response['inventory_num']);
                console.log(response['serial_num']);
                //alert(response);
                //window.location.href = "modificaciones.html";*/
            }
           
        }) 
    }
    
    $('#btnAceptarID').click(function (e) { 
        e.preventDefault();
        // console.log("Hola");
        var token = localStorage.getItem("tokenPrincipal");
        addProdct(token);
    });
    
    function addProdct(token){
        //var material = $('#material').val();
        var marca = $('#marca').val();
        var color = $('#color').val();
        var idLab = $('#idLab').val();
        var idProd = $('#idProd').val();
        var idProduct = localStorage.getItem("idProducto");


        $.ajax({
            url: 'http://localhost/Proyecto/Back-End/Usuario/updateProduct',
            type: 'POST',
            data: { 
                'token': token,
                'idProduct': idProduct,
                'material': "material",
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