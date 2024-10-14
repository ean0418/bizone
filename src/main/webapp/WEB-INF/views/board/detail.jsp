<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 18.
  Time: 오후 10:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../board/style.jsp"%>
<html>
<head>
    <title>Detail Page</title>
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
            margin-right: 5px;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-container {
            text-align: center;
            margin-top: 20px;
        }
        form {
            display: inline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 style="text-align: center">게시글 상세 보기</h2>

        <div class="form-group">
            <label for="bb_title">제목</label>
            <input type="text" class="form-control" id="bb_title" value="${board.bb_title}" readonly>
        </div>
        <div class="form-group">
            <label for="bb_bm_nickname">작성자</label>
            <input type="text" class="form-control" id="bb_bm_nickname" value="${board.bb_bm_nickname}" readonly>
        </div>
        <div class="form-group">
            <label for="bb_content">내용</label>
            <textarea class="form-control" id="bb_content" rows="5" readonly>${board.bb_content}</textarea>
        </div>

        <div class="btn-container" style="text-align: center; margin-top: 20px;">
            <input type="button" class="btn btn-default" value="목록" onclick="location.href='${contextPath}/board/list'">
            <input type="button" class="btn btn-primary" value="수정" onclick="location.href='${contextPath}/board/update.go?bb_no=${board.bb_no}'">
            <form action="${contextPath}/board/delete" method="post" style="display:inline;">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <input type="hidden" name="bb_no" value="${board.bb_no}">
                <input type="submit" class="btn btn-danger" value="삭제">
            </form>
        </div>
    </div>
</body>
</html>
