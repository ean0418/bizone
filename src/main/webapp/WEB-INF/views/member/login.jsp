<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
    window.Kakao.init("412e7727ffd0b8900060854044814879");

    function kakaoLogin() {
        window.Kakao.Auth.login({
            scope: 'profile_nickname, profile_image',
            success: function (authObj) {
                console.log(authObj);
                Window.Kakao.API.request({
                    url:'/v2/user/me',
                    success: res => {
                        const kakao_account = res.kakao_account;
                    }
                })
            }
        });
    }

</script>
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: white;
        color: #d3d7da;
        margin: 0;
        display: flex;
    }

    /* 로그인 테이블 스타일 */
    #loginTbl {
        width: 100%;
        max-width: 400px; /* 폼의 최대 너비 설정 */
        background-color: #2b2e33;
        padding: 40px;
        margin: 20vh auto auto;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        text-align: center;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    #loginTbl:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.7);
    }

    /* 로그인 제목 */
    #loginTbl td:first-child {
        font-size: 28px;
        font-weight: bold;
        color: white;
        letter-spacing: 2px;
        margin-bottom: 30px;
    }

    /* 입력 필드 스타일 */
    input.i1 {
        width: 90%;
        padding: 15px;
        margin: 15px 0;
        border: 1px solid #555;
        border-radius: 8px;
        background-color: rgba(46, 51, 56, 0.8);
        color: #d3d7da;
        box-sizing: border-box;
        font-size: 16px;
        transition: border-color 0.3s ease, background-color 0.3s ease, box-shadow 0.3s ease;
    }

    input.i1:focus {
        border-color: #5dade2;
        background-color: rgba(46, 51, 56, 1);
        box-shadow: 0 0 8px rgba(93, 173, 226, 0.7);
        outline: none;
    }

    /* 버튼 스타일 */
    button {
        width: 90%;
        margin: 15px 0;
        padding: 15px 0;
        background-color: #2ecc71;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 18px;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }

    button:hover {
        background-color: #27ae60;
        transform: scale(1.02);
    }

    form {
        margin: auto 0;
    }

    .loginApi {
        max-width: 400px;
        text-align: center;
        margin: 30px auto;
    }
</style>
<body>
<form action="member.login" name="loginForm" method="post" onsubmit="return loginCheck();">
    <table id="loginTbl">
        <tr>
            <td align="center" style="padding-top: 10px;">
                LOGIN
            </td>
        </tr>
        <tr>
            <td align="center">
                <input name="bm_id" placeholder="ID" autocomplete="off" maxlength="10"
                       autofocus="autofocus" class="i1">
            </td>
        </tr>
        <tr>
            <td align="center">
                <input name="bm_pw" placeholder="PASSWORD" autocomplete="off" maxlength="10" type="password" class="i1">
            </td>
        </tr>
        <tr>
            <td align="center">
                <button>로그인</button>
            </td>
        </tr>
    </table>
    <div class="loginApi">
        <a href="javascript:kakaoLogin();"><img class="loginApiImage" src="../../../resources/image/kakao_login.png" alt=""></a>
    </div>
</form>
</body>
</html>
