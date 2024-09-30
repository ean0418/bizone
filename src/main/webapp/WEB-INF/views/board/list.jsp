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
    <style>
        .container {
            margin-top: 50px;
        }
        h2 {
            text-align: center;
            margin-bottom: 5px; /* 글쓰기 목록과 글쓰기 버튼 사이 간격 줄이기 */
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table th, table td {
            padding: 5px;
            text-align: center;
        }
        table th {
            background-color: #f4f4f4;
            font-weight: bold;
            padding: 5px;  /* 테이블 헤더의 패딩을 더 줄여 높이 줄이기 */
        }
        /* 테두리 없애기 (세로선 삭제) */
        table td, table th {
            border-bottom: 1px solid #ddd; /* 가로선만 남기기 */
        }
        /* 열 크기 조정 */
        table th:nth-child(1), table td:nth-child(1) {
            width: 10%;
        }
        table th:nth-child(2), table td:nth-child(2) {
            width: 45%;
        }
        table th:nth-child(3), table td:nth-child(3) {
            width: 15%;
        }
        table th:nth-child(4), table td:nth-child(4) {
            width: 20%;
        }
        table th:nth-child(5), table td:nth-child(5) {
            width: 10%;
        }
        .btn {
            margin-top: 5px; /* 글쓰기 버튼과 글쓰기 목록 간격 줄이기 */
            margin-bottom: 10px; /* 글쓰기 버튼과 테이블 사이 간격 늘리기 */
            padding: 8px 15px; /* 버튼 크기를 줄이기 위해 padding 조정 */
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px; /* 버튼의 글씨 크기 조정 */
        }
        .btn:hover {
            background-color: #0056b3;
        }

        .pagination-container {
            display: flex;
            justify-content: center; /* 중앙 정렬 */
            align-items: center;
            gap: 5px; /* 페이지 번호와 Previous, Next 버튼 간의 간격 */
        }

        .page-item {
            margin: 0 5px; /* 간격 유지 */
        }

        .page-item a:hover {
            text-decoration: none;
            padding: 8px 12px;
            color: #007bff;
        }

        .page-item.disabled a {
            color: grey;
            pointer-events: none;
        }

        .page-item.active a {
            font-weight: bold;
            color: black;
        }

        .page-item {
            display: inline-flex;
            justify-content: center;
            align-items: center;
        }

        .search-box {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .search-box input[type="text"] {
            padding: 5px;
            width: 200px;
        }
        .search-box button:hover {
            padding: 5px 10px;
        }
    </style>
    <script>
        // 성공 메시지가 있을 경우 alert로 표시
        <c:if test="${not empty successMsg}">
            alert("${successMsg}");
        </c:if>

        // 에러 메시지가 있을 경우 alert로 표시
        <c:if test="${not empty errorMsg}">
            alert("${errorMsg}");
        </c:if>
    </script>
</head>
<body>
    <div class="container">
        <h2 style="text-align: center">게시물 목록</h2>
        <!-- 글쓰기 버튼 -->
        <div class="text-right">
            <button class="btn btn-primary" onClick="location.href='${contextPath}/board/insert.go'">글쓰기</button>
        </div>

        <table class="table table-hover table-bordered text-center">
            <thead class="thead-white">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty boardList}">
                    <c:forEach var="board" items="${boardList}">
                        <tr>
                            <td>${board.bb_postNum}</td>
                            <td><a href="${contextPath}/board/detail?bb_no=${board.bb_no}" style="color: black;">${board.bb_title}</a></td>
                            <td>${board.bb_bm_nickname}</td>
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

        <nav aria-label="Page navigation">
            <ul class="pagination pagination-container">
                <!-- Previous 버튼 -->
                <c:if test="${page > 1}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${page - 1}&bb_nickname=${bb_nickname}"><</a>
                    </li>
                </c:if>

                <!-- 페이지 번호 표시 (1 ~ 5) -->
                <c:choose>
                    <c:when test="${totalPages <= 5}">
                        <!-- 총 페이지가 5 이하일 경우 모든 페이지 번호 표시 -->
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${page == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&bb_nickname=${bb_nickname}">${i}</a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- 현재 페이지가 1~3 사이일 경우 -->
                        <c:if test="${page <= 3}">
                            <c:forEach var="i" begin="1" end="5">
                                <li class="page-item ${page == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&bb_nickname=${bb_nickname}">${i}</a>
                                </li>
                            </c:forEach>
                        </c:if>
                        <!-- 현재 페이지가 4 이상일 경우 -->
                        <c:if test="${page > 3}">
                            <c:forEach var="i" begin="${page - 2}" end="${page + 2 > totalPages ? totalPages : page + 2}">
                                <li class="page-item ${page == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&bb_nickname=${bb_nickname}">${i}</a>
                                </li>
                            </c:forEach>
                        </c:if>
                    </c:otherwise>
                </c:choose>

                <!-- Next 버튼 -->
                <c:if test="${page < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${page + 1}&bb_nickname=${bb_nickname}">></a>
                    </li>
                </c:if>
            </ul>
        </nav>

        <!-- 작성자명으로 게시글 조회 -->
        <form action="${contextPath}/board/list" method="get" class="search-box">
            <input type="text" name="bb_nickname" placeholder="작성자명 입력" value="${bb_nickname}">
            <button type="submit">검색</button>
        </form>
    </div>
</body>
</html>
