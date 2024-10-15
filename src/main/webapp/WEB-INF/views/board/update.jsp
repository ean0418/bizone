<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 18.
  Time: 오후 6:31
  To change this template use File | Settings | File Templates.
--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>--%>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>--%>
<%--&lt;%&ndash;<%@ include file="../board/style.jsp"%>&ndash;%&gt;--%>
<%--<html>--%>
<%--<head>--%>
<%--  <title>Update Page</title>--%>
<%--  <style>--%>
<%--    .container {--%>
<%--      margin-top: 50px;--%>
<%--    }--%>
<%--    h2 {--%>
<%--      text-align: center;--%>
<%--      margin-bottom: 30px;--%>
<%--    }--%>
<%--    .form-group label {--%>
<%--      font-weight: bold;--%>
<%--    }--%>
<%--    .form-group input, .form-group textarea {--%>
<%--      width: 100%;--%>
<%--      padding: 10px;--%>
<%--      margin-top: 5px;--%>
<%--      border-radius: 4px;--%>
<%--      border: 1px solid #ddd;--%>
<%--    }--%>
<%--    .btn {--%>
<%--      padding: 8px 15px;--%>
<%--      background-color: #007bff;--%>
<%--      color: white;--%>
<%--      border: none;--%>
<%--      border-radius: 4px;--%>
<%--      cursor: pointer;--%>
<%--      text-decoration: none;--%>
<%--      margin-top: 10px;--%>
<%--    }--%>
<%--    .btn:hover {--%>
<%--      background-color: #0056b3;--%>
<%--    }--%>
<%--    .btn-container {--%>
<%--      text-align: right;--%>
<%--      margin-top: 20px;--%>
<%--    }--%>
<%--  </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--  <div class="container">--%>
<%--    <h2 style="text-align: center">게시글 수정</h2>--%>

<%--    <form action="${contextPath}/board/update" method="post">--%>
<%--      <input type="hidden" name="bb_no" value="${board.bb_no}">--%>
<%--      <div class="form-group">--%>
<%--        <label for="bb_title">제목</label>--%>
<%--        <input type="text" class="form-control" id="bb_title" name="bb_title" value="${board.bb_title}" required>--%>
<%--      </div>--%>
<%--      <div class="form-group">--%>
<%--        <label for="bb_bm_nickname">작성자</label>--%>
<%--        <input type="text" class="form-control" id="bb_bm_nickname" name="bb_bm_nickname" value="${board.bb_bm_nickname}" readonly>--%>
<%--      </div>--%>
<%--      <div class="form-group">--%>
<%--        <label for="bb_content">내용</label>--%>
<%--        <textarea class="form-control" id="bb_content" name="bb_content" rows="3" required>${board.bb_content}</textarea>--%>
<%--      </div>--%>

<%--      <div class="btn-container">--%>
<%--        <input type="submit" class="btn btn-default" value="수정" style="margin-top: 50px;">--%>
<%--      </div>--%>
<%--    </form>--%>
<%--  </div>--%>
<%--</body>--%>
<%--</html>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>게시글 수정</title>
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
  <div class="page-title">게시글 수정</div>
  <form action="${contextPath}/board/update" method="post">
    <input type="hidden" name="bb_no" value="${board.bb_no}">
    <div class="form-group">
      <label for="bb_title">제목</label>
      <input type="text" id="bb_title" name="bb_title" value="${board.bb_title}" required>
    </div>
    <div class="form-group">
      <label for="bb_bm_id">작성자</label>
      <input type="text" id="bb_bm_id" name="bb_bm_id" value="${board.bb_bm_id}" readonly>
    </div>
    <div class="form-group">
      <label for="bb_content">내용</label>
      <textarea id="bb_content" name="bb_content" required>${board.bb_content}</textarea>
    </div>
    <div class="btn-container">
      <button type="submit" class="btn">수정</button>
      <a href="${contextPath}/board/list" class="btn">목록으로</a>
    </div>
  </form>
</div>
</body>
</html>

