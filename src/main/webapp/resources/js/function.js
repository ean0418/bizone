
// 로그아웃 함수
function logout() {
    let really = confirm("정말 로그아웃 하시겠습니까?");
    if (really) {
        location.href = "/member.logout"; // 로그아웃 경로로 이동
    }
}

// 회원 정보 페이지로 이동하는 함수
function memberInfoGo() {
    location.href = "/member.info.go"; // 회원 정보 페이지로 이동
}

// 회원가입 페이지로 이동하는 함수
function signUpgo() {
    location.href = "/member.step1"; // 회원가입 페이지로 이동
}
function analyze() {
    location.href = "/main";
}