<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>댓글 관리</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #f7f7f7;
            color: #333;
        }
        .container {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 40px;
        }
        h1 {
            font-size: 2.5rem;
            font-weight: 700;
            color: #34495e;
            text-align: center;
            margin-bottom: 20px;
        }
        .table {
            width: 100%;
            margin-top: 20px;
            border-radius: 12px;
            overflow: hidden;
        }
        .thead-dark {
            background-color: #2c3e50;
            color: white;
        }
        .table-bordered th,
        .table-bordered td {
            border: 1px solid #ddd;
        }
        .btn-danger {
            background-color: #e74c3c;
            border-color: #e74c3c;
            padding: 5px 10px;
            font-size: 0.9rem;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .btn-danger:hover {
            background-color: #c0392b;
            border-color: #c0392b;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4">댓글 관리</h1>

    <!-- 댓글 목록 테이블 -->
    <table class="table table-bordered">
        <thead class="thead-dark">
        <tr>
            <th>댓글 번호</th>
            <th>게시글 번호</th>
            <th>작성자 ID</th>
            <th>내용</th>
            <th>작성 날짜</th>
            <th>좋아요 수</th>
            <th>삭제</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="comment" items="${comments}">
            <tr>
                <td>${comment.bc_no}</td>
                <td>${comment.bc_bb_no}</td>
                <td>${comment.bc_bm_id}</td>
                <td>${comment.bc_content}</td>
                <td>${comment.bc_createdDate}</td>
                <td>${comment.bc_likeCount}</td>
                <td>
                    <form action="${contextPath}/deleteComment" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <input type="hidden" name="bc_no" value="${comment.bc_no}">
                        <button type="submit" class="btn btn-sm btn-danger">삭제</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <c:if test="${empty comments}">
        <p>조회된 댓글이 없습니다.</p>
    </c:if>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>