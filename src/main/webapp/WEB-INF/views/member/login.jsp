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
    <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.2/kakao.min.js" integrity="sha384-TiCUE00h649CAMonG018J2ujOgDKW/kVWlChEuu4jK2vxfAAD0eZxzCKakxg55G4" crossorigin="anonymous"></script>

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
            padding: 30px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            text-align: center;
        }

        h2 {
            font-size: 24px;
            color: #101E4E;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 10px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: #101E4E;
            box-shadow: 0 0 5px rgba(16, 30, 78, 100);
        }

        .btn-primary {
            background-color: #101E4E;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        .mypage-container {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            margin-top: 60px; /* 로그인 컨테이너를 아래로 이동 */
        }
        .btn-primary:hover {
            background-color: #101E4E;
        }

        .kakaobtn {
            margin-top: 20px;
        }

        .kakaobtn a {
            background-color: #FEE500;
            color: #3c1e1e;
            padding: 8px;
            display: block;
            border-radius: 8px;
            font-weight: bold;
        }

        .kakaobtn img {
            height: 20px;
            vertical-align: middle;
        }

        .or-seperator {
            margin: 20px 0;
            color: #888;
            font-size: 14px;
            font-weight: bold;
        }

        .text-center a {
            color: #888;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
        }

        .text-center a:hover {
            color: #101E4E;
        }
    </style>
</head>
<body>
<div class="mypage-container">
    <div class="login-container">
        <form action="${contextPath}/member.login" name="loginForm" method="post" onsubmit="return loginCheck();">
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
            <br>
            <div class="form-group loginbtn">
                <button type="submit" id="login_submit" class="btn btn-primary w-100">로그인</button>
            </div>

            <div class="or-seperator"><b>or</b></div>

            <div class="form-group kakaobtn">
                <a class="p-2" href='https://kauth.kakao.com/oauth/authorize?client_id=412e7727ffd0b8900060854044814879&redirect_uri=http://localhost/kakaologin&response_type=code'>
                    <img src="../resources/image/kakao_login.png" style="height:60px">
                </a>
            </div>

        </form>

        <div class="text-center mt-4">아이디를 까먹으셨습니까? <a href="${contextPath}/idFindForm.go">아이디 찾기</a></div>
        <div class="text-center mt-2">비밀번호를 까먹으셨습니까? <a href="${contextPath}/pwFindForm.go">비밀번호 찾기</a></div>
        <div class="text-center mt-2">아직 회원이 아니십니까? <a href="${contextPath}/signupForm.go">회원가입</a></div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>