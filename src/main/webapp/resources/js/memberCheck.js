function signupCheck() {
    let bm_id = document.signupForm.bm_id;
    let bm_pw = document.signupForm.bm_pw;
    let bm_pw_confirm = document.signupForm.bm_pw_confirm;
    let bm_name = document.signupForm.bm_name;
    let bm_nickname = document.signupForm.bm_nickname;
    let bm_address = document.signupForm.bm_address;
    let bm_phoneNum = document.signupForm.bm_phoneNum;
    let bm_birthday = document.signupForm.bm_birthday;
    let bm_mail = document.signupForm.bm_mail;

    if (isEmpty(bm_id)) {
        alert("Please Fill in ID Properly.");
        bm_id.value = "";
        bm_id.focus();
        return false;
    } else if (isEmpty(bm_pw) || notEqualPw(bm_pw, bm_pw_confirm)) {
        alert("Please Fill in Password Properly.");
        bm_pw.value = "";
        bm_pw_confirm.value = "";
        bm_pw.focus();
        return false;
    } else if (isEmpty(bm_name)) {
        alert("Please Fill in Name Properly.");
        bm_name.value = "";
        bm_name.focus();
        return false;
    } else if (isEmpty(bm_nickname)) {
        document.getElementById('bm_nickname').value = bm_id;
    } else if (isEmpty(bm_address)) {
        alert("Please Fill in Address Properly.");
        bm_address.value = "";
        bm_address.focus();
        return false;
    } else if (isEmpty(bm_phoneNum) || isNotNumber(bm_phoneNum)) {
        alert("Please Fill in Phone Number Properly.");
        bm_phoneNum.value = "";
        bm_phoneNum.focus();
        return false;
    } else if (isEmpty(bm_birthday)) {
        alert("Please Fill in Birthday Properly.");
        bm_birthday.value = "";
        bm_birthday.focus();
        return false;
    } else if (isEmpty(bm_mail)) {
        alert("Please Fill in Mail Properly.");
        bm_mail.value = "";
        bm_mail.focus();
        return false;
    }
    return true;

}

function loginCheck() {
    let bm_id = document.loginForm.bm_id;
    let bm_pw = document.loginForm.bm_pw;

    if (isEmpty(bm_id) || containsAnother(bm_id)) {
        alert("Please Fill in ID Properly.");
        bm_id.value = "";
        bm_id.focus();
        return false;
    } else if (isEmpty(bm_pw)) {
        alert("Please Fill in Password Properly.");
        bm_pw.value = "";
        bm_pw.focus();
        return false;
    }
    return true;
}

function updateCheck() {
    let bm_pw = document.updateForm.bm_pw;
    let bm_pw_confirm = document.updateForm.bm_pw_confirm;
    let bm_name = document.updateForm.bm_name;
    let bm_nickname = document.updateForm.bm_nickname;
    let bm_address = document.updateForm.bm_address;
    let bm_phoneNum = document.updateForm.bm_phoneNum;
    let bm_birthday = document.updateForm.bm_birthday;
    let bm_mail = document.updateForm.bm_mail;

    if (isEmpty(bm_pw) || notEqualPw(bm_pw, bm_pw_confirm)) {
        alert("Please Fill in Password Properly.");
        bm_pw.value = "";
        bm_pw_confirm.value = "";
        bm_pw.focus();
        return false;
    } else if (isEmpty(bm_name)) {
        alert("Please Fill in Name Properly.");
        bm_name.value = "";
        bm_name.focus();
        return false;
    } else if (isEmpty(bm_nickname)) {
        document.getElementById('bm_nickname').value = bm_id;
    } else if (isEmpty(bm_address)) {
        alert("Please Fill in Address Properly.");
        bm_address.value = "";
        bm_address.focus();
        return false;
    } else if (isEmpty(bm_phoneNum) || isNotNumber(bm_phoneNum)) {
        alert("Please Fill in Phone Number Properly.");
        bm_phoneNum.value = "";
        bm_phoneNum.focus();
        return false;
    } else if (isEmpty(bm_birthday)) {
        alert("Please Fill in Birthday Properly.");
        bm_birthday.value = "";
        bm_birthday.focus();
        return false;
    } else if (isEmpty(bm_mail)) {
        alert("Please Fill in Mail Properly.");
        bm_mail.value = "";
        bm_mail.focus();
        return false;
    }
    return true;

}