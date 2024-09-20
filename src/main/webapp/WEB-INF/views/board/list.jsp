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
            width: 10%;  /* 번호 열 크기 줄이기 */
        }
        table th:nth-child(2), table td:nth-child(2) {
            width: 40%; /* 제목 열 크기 늘리기 */
        }
        table th:nth-child(3), table td:nth-child(3) {
            width: 15%; /* 작성자 열 크기 줄이기 */
        }
        table th:nth-child(4), table td:nth-child(4) {
            width: 15%; /* 조회수 열 크기 줄이기 */
        }
        table th:nth-child(5), table td:nth-child(5) {
            width: 20%; /* 작성일 열 크기 늘리기 */
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
    </style>
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
                <th>조회수</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="board" items="${boardList}">
            <tr class="${board.bb_no == 123 ? 'selected' : ''}">
                <td>${board.bb_no}</td>
                <td><a href="${contextPath}/board/detail?bb_no=${board.bb_no}">${board.bb_title}</a></td>
                <td>${board.bb_bm_nickname}</td>
                <td>${board.bb_readcount}</td>
                <td><fmt:formatDate value="${board.bb_date}" pattern="yyyy-MM-dd HH:mm"/></td>
            </tr>
        </c:forEach>
        </tbody>
        </table>
    </div>
</body>
</html>
