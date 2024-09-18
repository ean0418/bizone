<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 18.
  Time: 오후 4:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../board/style.jsp"%>
<html>
<head>
    <title>Board List Page</title>
</head>
<body>
    <h2 style="text-align: center">게시글 목록</h2>

    <table class="listTbl">
        <thead>
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>조회수</th>
            <th>작성일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="board" items="${boardList}">
            <tr>
                <td>${board.bn_no}</td>
                <td><a href="${contextPath}/board/detail?bn_no=${board.bn_no}">${board.bn_title}</a></td>
                <td>${board.bn_bm_nickname}</td>
                <td>${board.bn_readcount}</td>
                <td><fmt:formatDate value="${board.bn_date}" pattern="yyyy-MM-dd HH:mm"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <input type="button" class="btn btn-default" value="글쓰기"
           onClick="location.href='${contextPath}/board/insert.go'" style="margin-top: 20px;">
</body>
</html>
