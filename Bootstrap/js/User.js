$(document).ready(function () {
    $('#formID').submit(function (e) { 
        e.preventDefault();

        
        // var payload = {
        //     userName : $('#userInput').val(),
        //     contra: $('#contraInput').val()
        // };
        var userName = $('#userInput').val();
        var contra = $('#contraInput').val();

        var payload = {
            'userName' : userName,
            'contra': contra
        }; 

        $.ajax({
            type: "POST",
            url: "http://localhost:8080/Proyecto_ID_2/Back-End/Usuario/login",
            data: payload,
            dataType: "json",
            success: function (response) {
                alert("Funciono");
                console.log(response);
            },
            error: function(){
                alert("No Funciono");
            }
        });


        //
        
        // var userName = $('#userInput').val();
        // var contra = $('#contraInput').val();
    
        // var payload = {
        //     name: 'usserName',
        //     vaue: userName
        // }; //{name: 'userName' ,value: userName,name: 'contra', value: contra};

        // console.log(payload);

        // $.ajax({
        //     type: "post",
        //     url: "http://localhost:8080/Proyecto_ID_2/Back-End/Usuario/login",
        //     data: payload,
        //     dataType: "json",
        //     // beforeSend: function(){
        //     //     $('.fa').css('display','inline');
        //     // }
        // }).done(function(response){
        //     $('span').html("Correcto");
        //     console.log(response);
        // }).fail(function(){
        //     alert("No funciono");
        //     //$('span').html("Incorrecto");
        // }).always(function(){ //Esta parte se ejecuta siempre que se realiza el request
        //     // $('.fa').hide();
        // });

        // $.ajax({
        //     type: "POST",
        //     url: "http://localhost:8080/Proyecto_ID_2/Back-End/Usuario/login",
        //     data: payload,
        //     dataType: "json",
        //     success: function (response) {
        //         console.log(reponse);
        //     },
        //     error: function(xhr, status, error) {
        //         //var err = eval("(" + xhr.responseText + ")");
        //         //alert(err.Message);
        //         alert("Hay un error.");
        //     }
        // });
        
    });
});