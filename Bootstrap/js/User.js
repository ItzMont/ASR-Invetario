$(document).ready(function () {
    $('#formID').submit(function (e) { 
        e.preventDefault();

        var userName = $('#userInput').val();
        var contra = $('#contraInput').val();

        var payload = {
            'userName' : userName,
            'contra': contra
        }; 
        
        $.ajax({
            type: "POST",
            url: "http://localhost:8080/Proyecto/Back-End/Usuario/login",
            data: payload,
            dataType: "json",
            beforeSend: function(){
              $('.fa').css({'display': ''});
              $('#login').css({'display': 'none'});
            },
            success: function (response) {
              if(response['error'] == 0){
                localStorage.setItem("tokenPrincipal",response['token']);
                window.location.href = "dash.html";
              }else{
                alert(response['message']);
                $('#contraInput').val("");
              }
            },
            error: function(){
              alert("Error: No se realizar login.");
            },
            complete: function() {
              $('.fa').css('display','none');
              $('#login').css({'display': ''});
            },
        });
    });
});