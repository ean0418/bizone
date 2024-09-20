<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bizone 로그인</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f5f7;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-container {
            width: 400px;
            padding: 40px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #101E4E;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            box-shadow: none;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: #101E4E;
            box-shadow: 0 0 5px rgba(0, 122, 204, 0.5);
        }

        .btn-primary {
            background-color: #101E4E;
            border: none;
            padding: 10px;
            border-radius: 8px;
            font-size: 16px;
        }

        .btn-primary:hover {
            background-color: #2e3b70;
        }

        .loginbtn {
            text-align: center;
            margin-top: 20px;
        }

        .or-seperator {
            text-align: center;
            margin: 20px 0;
            font-size: 16px;
            color: #888;
        }

        .kakaobtn {
            text-align: center;
            margin-top: 20px;
        }

        .kakaobtn button {
            background-color: #FEE500;
            border: none;
            padding: 10px;
            width: 100%;
            border-radius: 8px;

            color: #3c1e1e; /* 카카오 글씨 색상 */
        }

        .kakaobtn img {
            height: 25px;
            vertical-align: middle;
        }

        .text-center a {
            color: #888;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .text-center a:hover {
            color: #101E4E;
        }
    </style>
</head>
<body>

<div class="login-container">
    <form action="member.login" name="loginForm" method="post" onsubmit="return loginCheck();">
        <input type="hidden" name="login_ok" value="1"/>

        <h2>로그인</h2>

        <div class="form-group">
            <label class="id">아이디</label>
            <input type="text" class="form-control" name="bm_id" autofocus="autofocus" autocomplete="off" placeholder="ID 입력..." required="required">
        </div>

        <div class="form-group mt-3">
            <label class="bm_pw">비밀번호</label>
            <input type="password" class="form-control" name="bm_pw" autocomplete="off" placeholder="Password 입력..." required="required">
        </div>

        <div class="form-group loginbtn">
            <button type="submit" id="login_submit" class="btn btn-primary w-100">로그인</button>
        </div>

        <div class="or-seperator"><b>or</b></div>

        <div class="form-group kakaobtn">
            <button id="login-kakao-btn" onclick="location.href='https://kauth.kakao.com/oauth/authorize?client_id=412e7727ffd0b8900060854044814879&redirect_uri=http://localhost/kakao.login&response_type=code'">
                <img src="../resources/image/kakao_login.png" alt="카카오 로그인">
            </button>
        </div>
    </form>

    <div class="text-center mt-4">비밀번호를 까먹으셨습니까? <a href="/pwFindForm.do">비밀번호 찾기</a></div>
    <div class="text-center mt-2">아직 회원이 아니십니까? <a href="/signupForm.do">회원가입</a></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
