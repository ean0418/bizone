<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 17.
  Time: 오후 11:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>게시글 작성</title>
  <style>
    @font-face {
      font-family: 'DotumMidum';
      src: url('${pageContext.request.contextPath}/resources/ttf/DotumMidum.ttf') format('truetype');
    }

    body {
      font-family: 'DotumMidum', sans-serif;
      color: #333;
      background-color: #ffffff;
    }

    .container {
      max-width: 900px;
      margin: 50px auto;
      padding: 30px 20px;
      background-color: #ffffff;
      border: 1px solid #e3e3e3;
      border-radius: 5px;
    }

    .page-title {
      font-size: 1.5em;
      font-weight: 600;
      color: #444;
      border-bottom: 2px solid #e3e3e3;
      padding-bottom: 10px;
      margin-bottom: 20px;
      text-align: center;
    }

    .form-group {
      margin-bottom: 15px;
    }

    .form-group label {
      display: block;
      font-weight: bold;
      margin-bottom: 5px;
    }

    .form-group input,
    .form-group textarea {
      width: 100%;
      padding: 10px;
      border: 1px solid #ced4da;
      border-radius: 4px;
      box-sizing: border-box;
    }

    .form-group textarea {
      height: 200px;
      resize: none;
    }

    .btn-container {
      display: flex;
      justify-content: flex-start;
      gap: 10px;
      margin-top: 20px;
    }

    .btn {
      padding: 8px 15px;
      border: 1px solid #ced4da;
      background-color: white;
      color: #495057;
      cursor: pointer;
      border-radius: 4px;
      transition: border 0.3s;
      font-weight: bold;
    }

    .btn:hover {
      border: 1px solid;
      background-color: #101E4E;
      color: white;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="page-title">게시글 작성</div>
  <form action="${contextPath}/board/insert" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    <div class="form-group">
      <label for="bb_title">제목</label>
      <input type="text" id="bb_title" name="bb_title" placeholder="제목을 입력하세요." required>
    </div>
    <div class="form-group">
      <label for="bb_bm_id">작성자</label>
      <input type="text" id="bb_bm_id" name="bb_bm_id" value="${sessionScope.loginMember.bm_id}" readonly>
    </div>
    <div class="form-group">
      <label for="bb_content">내용</label>
      <textarea id="bb_content" name="bb_content" placeholder="내용을 입력하세요." required></textarea>
    </div>
    <div class="btn-container">
      <button type="submit" class="btn">작성</button>
      <a href="${contextPath}/board/list" class="btn">목록으로</a>
    </div>
  </form>
</div>
</body>
</html>
