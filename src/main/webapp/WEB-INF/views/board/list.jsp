<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Board List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        .table th, .table td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        .table th {
            background-color: #f4f4f4;
        }

        .btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a {
            padding: 8px 12px;
            margin: 0 5px;
            border: 1px solid #ddd;
            color: #007bff;
            text-decoration: none;
        }

        .pagination a:hover {
            background-color: #007bff;
            color: white;
        }

        .search-box {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }

        .search-box input[type="text"] {
            padding: 8px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .search-box button {
            padding: 8px 16px;
            margin-left: 10px;
            border: none;
            background-color: #007bff;
            color: white;
            border-radius: 4px;
            cursor: pointer;
        }

        .search-box button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<h2>게시물 목록</h2>
<div class="btn-container" style="text-align: right;">
    <button class="btn" onclick="location.href='${contextPath}/board/insert.go'">글쓰기</button>
</div>

<table class="table">
    <thead>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회수</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="pinnedBoard" items="${pinnedBoards}">
        <tr>
            <td>${pinnedBoard.bb_postNum}</td>
            <td><a href="${contextPath}/board/detail?bb_no=${pinnedBoard.bb_no}" style="color: black;">${pinnedBoard.bb_title}</a></td>
            <td>${pinnedBoard.bb_bm_id}</td>
            <td><fmt:formatDate value="${pinnedBoard.bb_date}" pattern="yyyy-MM-dd HH:mm"/></td>
            <td>${pinnedBoard.bb_readCount}</td>
        </tr>
    </c:forEach>
    <c:if test="${empty pinnedBoards}">
        <tr>
            <td colspan="5">공지사항이 없습니다.</td>
        </tr>
    </c:if>
    <c:choose>
        <c:when test="${not empty boardList}">
            <c:forEach var="board" items="${boardList}">
                <tr>
                    <td>${board.bb_postNum}</td>
                    <td><a href="${contextPath}/board/detail?bb_no=${board.bb_no}" style="color: black;">${board.bb_title}</a></td>
                    <td>${board.bb_bm_id}</td>
                    <td><fmt:formatDate value="${board.bb_date}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${board.bb_readCount}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="5">게시글이 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<nav class="pagination">
    <!-- Previous 버튼 -->
    <c:if test="${page > 1}">
        <a href="?page=${page - 1}&bb_bm_id=${bb_bm_id}">&laquo;</a>
    </c:if>

    <!-- 페이지 번호 표시 -->
    <c:forEach var="i" begin="1" end="${totalPages}">
        <a href="?page=${i}&bb_bm_id=${bb_bm_id}" class="${page == i ? 'active' : ''}">${i}</a>
    </c:forEach>

    <!-- Next 버튼 -->
    <c:if test="${page < totalPages}">
        <a href="?page=${page + 1}&bb_bm_id=${bb_bm_id}">&raquo;</a>
    </c:if>
</nav>

<div class="search-box">
    <form action="${contextPath}/board/list" method="get">
        <input type="text" name="bb_bm_id" placeholder="작성자명 입력" value="${bb_bm_id}">
        <button type="submit">검색</button>
    </form>
</div>
</body>
</html>
