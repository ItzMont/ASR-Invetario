$(document).ready(function () {
  //Verify any token that can exist
  verifyIfExistToken();

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
            url: "https://asrinventario.000webhostapp.com/Back-End/Usuario/login",
            // url: "https://asrinventario.000webhostapp.com/Back-End/MyController/loginTest",
            data: payload,
            dataType: "json",
            beforeSend: function(){
              $('.fa').css({'display': ''});
              $('#login').css({'display': 'none'});
            },
            success: function (response) {
              if(response['error'] == 0){
                console.log(response);
                localStorage.setItem("tokenPrincipal",response['token']);
                window.location.href = "dash.html";
              }else{
                alert(response['message']);
                console.log(response);
                $('#contraInput').val("");
              }
            },
            error: function(){
              alert("Error: No se pudo realizar el login.");
              $('#contraInput').val("");
            },
            complete: function() {
              $('.fa').css('display','none');
              $('#login').css({'display': ''});
            },
        });
    });
    
    function verifyIfExistToken(){
      if (localStorage.getItem("tokenPrincipal") !== null) {
        // window.location.href = "dash.html";
        // console.log(localStorage.getItem("tokenPrincipal"));
      }
    }


});