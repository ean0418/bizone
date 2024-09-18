<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 17.
  Time: 오후 11:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../board/style.jsp"%>
<html>
<head>
    <title>Board Insert Page</title>
</head>
<body>
  <h2 style="text-align: center">게시글 작성하기</h2>

  <div class="container">
    <form action="${contextPath}/board/insert" name="insertForm" method="post" style="gap: 1rem" onsubmit="">
      <div class="form-group">
        <label for="title">제목</label>
        <input type="text" class="form-control" id="title" name="bn_title"
               placeholder="제목을 입력하세요." required>
      </div>
      <div class="form-group">
        <label for="writer">작성자</label>
        <input type="text" class="form-control" id="writer" name="bn_bm_nickname" value="${sessionScope.loginMember.bm_nickname}" readonly>
      </div>
      <div class="form-group">
        <label for="content">내용</label>
        <textarea class="form-control" id="content" name="bn_content" rows="3"
                  style="resize: none;" required></textarea>
      </div>

      <input type="submit" class="btn btn-default" value="작성" style="margin-top: 50px;">
      <input type="button" class="btn btn-default" value="목록"
             onClick="location.href='${contextPath}/board/list'" style="margin-top: 50px;">
    </form>
  </div>
</body>
</html>
