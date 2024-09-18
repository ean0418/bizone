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
</head>
<body>
  <h2 style="text-align: center">게시글 수정하기</h2>

  <div class="container">
    <form action="${contextPath}/board/update" method="post">
      <input type="hidden" name="bn_no" value="${board.bn_no}">
      <div class="form-group">
        <label for="bn_title">제목</label>
        <input type="text" class="form-control" id="bn_title" name="bn_title" value="${board.bn_title}" required>
      </div>
      <div class="form-group">
        <label for="bn_bm_nickname">작성자</label>
        <input type="text" class="form-control" id="bn_bm_nickname" name="bn_bm_nickname" value="${board.bn_bm_nickname}" readonly>
      </div>
      <div class="form-group">
        <label for="bn_content">내용</label>
        <textarea class="form-control" id="bn_content" name="bn_content" rows="3" required>${board.bn_content}</textarea>
      </div>
      <input type="submit" class="btn btn-default" value="수정하기" style="margin-top: 50px;">
    </form>
  </div>
</body>
</html>
