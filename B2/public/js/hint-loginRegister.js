/**
 * Created by Payne on 2015/7/10.
 */
$(document).ready(function(){
    $('#login_userID').keyup(function(){
        $.ajax({
            url:"/thinkphp/index.php/Home/Index/hintLogin",
            data:{
                userID:$('#login_userID').val()
            },
            type:'get',
            error:function(XMLHttpRequest, textStatus, errorThrown){
                alert(XMLHttpRequest.status);
                alert(XMLHttpRequest.readyState);
                alert(textStatus);
            },
            success:function($data){
                if($data=='ok'){
                    $('#hint_login_userID').removeClass("glyphicon glyphicon-ok");
                    $('#hint_login_userID').addClass("glyphicon glyphicon-ok");
                }else{
                    $('#hint_login_userID').removeClass("glyphicon glyphicon-ok");
                }
            }
        });
    });
    $('.register_form :input').keyup(function(){
        $.ajax({
            url:"/thinkphp/index.php/Home/Index/hintRegister",
            data:{
                userID:$('#userID').val(),
                password:$('#password').val(),
                repassword:$('#repassword').val()
            },
            type:'get',
            dataType:'json',
            error:function(XMLHttpRequest, textStatus, errorThrown){
                alert(XMLHttpRequest.status);
                alert(XMLHttpRequest.readyState);
                alert(textStatus);
            },
            success:function($data){
                $data = $.getJSON($data,true);
                alert($data);
                if($data['userID']==true){//userID可用
                    $('#hint_userID').removeClass("glyphicon glyphicon-ok");
                    $('#hint_userID').addClass("glyphicon glyphicon-ok");
                }else{//userID不可用
                    $('#hint_userID').removeClass("glyphicon glyphicon-ok");
                }
                if($data['repassword']==true){//重复密码正确
                    $('#hint_repassword').removeClass("glyphicon glyphicon-ok");
                    $('#hint_repassword').addClass("glyphicon glyphicon-ok");
                }else{
                    $('#hint_repassword').removeClass("glyphicon glyphicon-ok");
                }
            }
        });
    });
});