<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 18.
  Time: 오후 10:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../board/style.jsp"%>
<html>
<head>
    <title>Delete Page</title>
    <title>Delete Page</title>
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
    </style>
</head>
<body>
    <div class="container">
        <h2 style="text-align: center">게시글 삭제</h2>

        <p>정말로 이 게시글을 삭제하시겠습니까?</p>

        <!-- 게시글 정보 표시 -->
        <div class="form-group">
            <label for="bn_title">제목</label>
            <input type="text" class="form-control" id="bn_title" name="bn_title" value="${board.bn_title}" readonly>
        </div>
        <div class="form-group">
            <label for="bn_bm_nickname">작성자</label>
            <input type="text" class="form-control" id="bn_bm_nickname" name="bn_bm_nickname" value="${board.bn_bm_nickname}" readonly>
        </div>
        <div class="form-group">
            <label for="bn_content">내용</label>
            <textarea class="form-control" id="bn_content" name="bn_content" rows="3" readonly>${board.bn_content}</textarea>
        </div>

        <!-- 삭제 확인 폼 -->
        <div class="btn-container">
            <form action="${contextPath}/board/delete" method="post">
                <input type="hidden" name="bn_no" value="${board.bn_no}">
                <input type="submit" class="btn btn-danger" value="삭제">
                <input type="button" class="btn btn-default" value="취소" onclick="location.href='${contextPath}/board/list'">
            </form>
        </div>
    </div>
</body>
</html>
