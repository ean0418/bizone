function bye() {
    let t = prompt("탈퇴 긔? Y/N");
    if (t == "Y") {
        location.href = "DeleteMemberController";
    }
}

function boardDelete(b_no) {
    let t = confirm("진짜 글 삭제 ?");
    if (t) {
        location.href = "BoardDeleteController?b_no=" + b_no;
    }
}

function boardUpdate(b_no) {
    // alert(b_no);
    b_text = prompt("변경 내용");
    // alert(b_text);
    if (b_text.length < 200) {
        location.href = "BoardUpdateController?b_no=" + b_no + "&b_text=" + encodeURI(b_text);
    }
}

function logout() {
    let really = confirm("리얼루다가 ?");
    if (really) {
        location.href = "LoginController";
    }
}

function memberInfoGo() {
    location.href = "MemberInfoController";
}


function signUpgo() {
    location.href = "SignupController";
}
