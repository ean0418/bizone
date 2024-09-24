<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 19.
  Time: 오후 12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background-color: white;
      color: #101E4E;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      overflow: hidden;
    }

    /* 컨테이너 스타일 */
    .container {

      background-color: white;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
      text-align: center;
      width: 100%;
      max-width: 500px;
      transition: transform 0.3s ease, box-shadow 0.3s ease;

    }
  form {
    margin-bottom: 50px;
  }
    .container:hover {
      transform: translateY(-5px);
      box-shadow: 0 15px 35px rgba(0, 0, 0, 0.7);
    }

    /* 제목 스타일 */
    h1 {
      font-size: 28px;
      margin-bottom: 20px;
      color: #101E4E;
      background: linear-gradient(135deg, #3498db, #8e44ad);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      text-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    }

    /* 스텝 표시기 */
    .step-indicator {
      display: flex;
      justify-content: center;
      margin-bottom: 20px;
    }


    .step-indicator span {
      display: inline-flex; /* flex를 사용하여 가로 및 세로로 중앙 배치 */
      justify-content: center; /* 가로 중앙 정렬 */
      align-items: center; /* 세로 중앙 정렬 */
      width: 35px; /* 원의 너비 */
      height: 35px; /* 원의 높이 */
      border-radius: 50%; /* 원형으로 만듦 */
      background-color: #101E4E; /* 기본 원 배경색 */
      color: white;
      font-weight: bold;
      margin: 0 10px;
      font-size: 16px; /* 숫자 크기 */
    }

    .step-indicator .active {
      background-color: #101E4E; /* 활성화된 스텝의 배경색 */
    }
    /* 설명 문구 */
    p {
      font-size: 18px;
      color: #d3d7da;
      margin-bottom: 30px;
    }

    /* 로그인 버튼 스타일 */
    .btn {
      display: inline-block;
      padding: 15px 30px;
      background-color: #3498db;
      color: white;
      text-decoration: none;
      border-radius: 10px;
      font-size: 18px;
      transition: background-color 0.3s ease, transform 0.2s ease;
    }
  p {
    color: #101E4E;
  }
    .btn:hover {
      background-color: #2980b9;
      transform: scale(1.05);
    }
  </style>
  <body>
  <form action="${contextPath}/member.step3" method="post">
  <div class="container">
    <h1>회원가입 완료</h1>
    <div class="step-indicator">
      <span>1</span> → <span>2</span> → <span class="active">3</span>
    </div>
    <p>회원가입이 완료되었습니다. 로그인하여 다양한 서비스를 이용해보세요.</p>
    <a href="${contextPath}/member.login.go" class="btn">로그인</a>
  </div>
    </form>
  </body>
</html>
