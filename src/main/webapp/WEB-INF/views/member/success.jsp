<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 11:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인 성공</title>
    <link rel="stylesheet" type="text/css" href="../resources/css/loginSuccess.css">
</head>
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #f5f6fa;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    /* 로그인 성공 메인 컨테이너 */
    .login-success-container {
        background-color: #fff;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        text-align: center;
        width: 400px;
    }

    /* 환영 메시지 */
    .welcome-section {
        margin-bottom: 30px;
    }

    .user-id {
        font-size: 1.2rem;
        color: #101e4e;
    }

    .welcome-section h1 {
        font-size: 2rem;
        color: #101e4e;
        margin-bottom: 10px;
    }

    .welcome-message {
        color: #737373;
        font-size: 1.2rem;
    }

    /* 메뉴 버튼 스타일 */
    .menu-buttons {
        display: flex;
        justify-content: space-between;
        gap: 10px;
    }

    .menu-buttons button {
        padding: 10px 20px;
        font-size: 1rem;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    /* 정보 버튼 */
    .info-btn {
        background-color: #2ecc71;
        color: white;
    }

    .info-btn:hover {
        background-color: #27ae60;
    }

    /* 로그아웃 버튼 */
    .logout-btn {
        background-color: #e74c3c;
        color: white;
    }

    .logout-btn:hover {
        background-color: #c0392b;
    }

    /* 상권 분석 버튼 */
    .analyze-btn {
        background-color: #3498db;
        color: white;
    }

    .analyze-btn:hover {
        background-color: #2980b9;
    }
</style>
<body>
<div class="login-success-container">
    <div class="welcome-section">
        <p class="user-id">${sessionScope.loginMember.bm_id }</p>
        <h1>${sessionScope.loginMember.bm_name } 님</h1>
        <p class="welcome-message">어서오세요</p>
    </div>

    <div class="menu-buttons">
        <button onclick="memberInfoGo();" class="info-btn">정보</button>
        <button onclick="logout();" class="logout-btn">로그아웃</button>
        <button onclick="analyze();" class="analyze-btn">상권 분석</button>
    </div>
</div>

<script type="text/javascript" src="../resources/js/memberCheck.js"></script>
<script type="text/javascript" src="../resources/js/validChecker.js"></script>
<script type="text/javascript" src="../resources/js/function.js"></script>

<script>
    function analyze() {
        location.href = '/business-analysis';  // 상권 분석 페이지로 이동하는 링크
    }
</script>
</body>
</html>
