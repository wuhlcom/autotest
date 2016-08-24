
/**
 * Created by Administrator on 2016/5/17.
 */
/**
 * 加密
 */
function encrypt(str){
    var rsa_n = 'D42E861C04CFB9EBB1368A682EC22BDCA364A35E1C5DF1D43FC4F24197D4B798BCB7FD0192774749C4DED8B659002B4ABEA2F11F7896BCEE5CD615D31EF8936823ED6760CA01D91F677F1459019383679D78BE72FE67E7C1C3FDA1A514B5FE35879A9A9DC90EAE059948CD222F4C69F37F23F0864112CD4A8AE2B4FD9EC36297';
    setMaxDigits(131); //131 => n的十六进制位�?/2+3
    var key  = new RSAKeyPair("10001", '', rsa_n); //10001 => e的十六进�?
    return encryptedString(key, str+'\x01'); //不支持汉�?
}
function tips(content){
    var timer;
    $('#tipContent').text(content);
    $('#tips').show();
    clearTimeout(timer);
    timer = setTimeout(function(){
        $('#tips').hide();
    },3000);
}

function emailOrTelphone(value){
    if(value == '') return false;
    value = value.replace(/(^\s*)|(\s*$)/g,'');
    var regEmail = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
    var regTelphone = /^1[3|4|5|7|8]\d{9}$/;
    if(value.indexOf('@') == -1){
        return regTelphone.test(value);
    }else{
        return regEmail.test(value);
    }
}
function sendajax(url,data,callback){
    $.ajax({
        type:"post",
        url: url,
        data:data,
        success:callback
    });
}