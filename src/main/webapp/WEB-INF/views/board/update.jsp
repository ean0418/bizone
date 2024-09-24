<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 18.
  Time: 오후 6:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../board/style.jsp"%>
<html>
<head>
  <title>Update Page</title>
  <style>
    .container {
      margin-top: 50px;
    }
    h2 {
      text-align: center;
      margin-bottom: 30px;
    }
    .form-group label {
      font-weight: bold;
    }
    .form-group input, .form-group textarea {
      width: 100%;
      padding: 10px;
      margin-top: 5px;
      border-radius: 4px;
      border: 1px solid #ddd;
    }
    .btn {
      padding: 8px 15px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      text-decoration: none;
      margin-top: 10px;
    }
    .btn:hover {
      background-color: #0056b3;
    }
    .btn-container {
      text-align: right;
      margin-top: 20px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2 style="text-align: center">게시글 수정</h2>

    <form action="${contextPath}/board/update" method="post">
      <input type="hidden" name="bb_no" value="${board.bb_no}">
      <div class="form-group">
        <label for="bb_title">제목</label>
        <input type="text" class="form-control" id="bb_title" name="bb_title" value="${board.bb_title}" required>
      </div>
      <div class="form-group">
        <label for="bb_bm_nickname">작성자</label>
        <input type="text" class="form-control" id="bb_bm_nickname" name="bb_bm_nickname" value="${board.bb_bm_nickname}" readonly>
      </div>
      <div class="form-group">
        <label for="bb_content">내용</label>
        <textarea class="form-control" id="bb_content" name="bb_content" rows="3" required>${board.bb_content}</textarea>
      </div>

      <div class="btn-container">
        <input type="submit" class="btn btn-default" value="수정" style="margin-top: 50px;">
      </div>
    </form>
  </div>
</body>
</html>
