$(document).ready(function(){
    var token = localStorage.getItem("tokenPrincipal");
    console.log(token);
    
    //Cargamos a los docentes
    $.ajax({
        url: 'http://rene.260mb.net/ID2/Back-End/Usuario/getDocentesForDD',
        type: 'GET',
        data: { 'token': token },
        datatype: "JSON",
        success: function(response){
            // console.table(response);
            console.log(response)
            var tabla = response;
            let i = '';
            tabla.forEach(tabla => {
                i += `<button class="dropdown-item nombreDocenteDD" value="${tabla.idresponsable}">${tabla.docenteResponsable}</button>`;    
            });
            $('#docentesDD').append(i);

            $('.nombreDocenteDD').click(function (e) { 
                e.preventDefault();
                var buttonClicked = $(this);
                
                $('#dropdownMenuButton').html(buttonClicked.html());
                $('#dropdownMenuButton').val(buttonClicked.val());
                
            });
        }
    })



    $('#btnAceptarID').click(function (e) { 
        e.preventDefault();
        addProdct();
    });
    
    function addProdct(){
        var responsable = $('#dropdownMenuButton').val();
        var marca = $('#marca').val();
        var color = $('#color').val();
        var idLab = $('#idLab').val();
        var idProd = $('#idProd').val();



        $.ajax({
            url: 'http://rene.260mb.net/ID2/Back-End/Usuario/addProduct',
            type: 'POST',
            data: { 
                'token': token,
                'responsable': responsable,
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

    function showAllClaveDocente(){

    }

    $('#logout').click(function(){
        localStorage.removeItem("tokenPrincipal");            
    });
    
});