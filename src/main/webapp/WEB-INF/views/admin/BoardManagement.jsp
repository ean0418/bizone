<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>게시판 관리</title>
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background-color: #f4f4f9;
      color: #2c3e50;
    }

    h1 {
      font-size: 3rem;
      font-weight: bold;
      color: #34495e;
      text-align: center;
      margin-bottom: 1.5rem;
    }

    .container {
      background-color: white;
      border-radius: 15px;
      box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
      padding: 40px;
      max-width: 1200px;
      margin: 40px auto;
    }

    .btn-primary {
      background-color: #3498db;
      border: none;
      padding: 12px 24px;
      font-size: 1.1rem;
      border-radius: 30px;
      transition: all 0.3s ease;
    }

    .btn-primary:hover {
      background-color: #2980b9;
      box-shadow: 0 6px 15px rgba(41, 128, 185, 0.4);
    }

    .table {
      width: 100%;
      margin-top: 20px;
      border-spacing: 0;
      border-collapse: collapse;
    }

    .table th, .table td {
      padding: 15px;
      border-bottom: 1px solid #ddd;
    }

    .table th {
      background-color: #2c3e50;
      color: white;
    }

    .table td {
      color: #34495e;
    }

    @media (max-width: 768px) {
      .table thead {
        display: none;
      }
      .table, .table tbody, .table tr, .table td {
        display: block;
        width: 100%;
      }
      .table td {
        text-align: right;
        padding-left: 50%;
        position: relative;
      }
      .table td::before {
        content: attr(data-label);
        position: absolute;
        left: 0;
        width: 50%;
        padding-left: 15px;
        font-weight: bold;
        text-align: left;
      }
    }
    /* 페이지네이션 스타일 */
    .pagination {
      justify-content: center;
      margin: 20px 0;
    }

    .pagination a {
      display: block;
      padding: 10px 15px;
      margin: 0 5px;
      background-color: #f4f4f9;
      color: #2c3e50;
      text-decoration: none;
      border-radius: 5px;
      border: 1px solid #ddd;
      transition: background-color 0.3s, box-shadow 0.3s;
    }

    .pagination a:hover {
      background-color: #3498db;
      color: #fff;
      box-shadow: 0 6px 15px rgba(52, 152, 219, 0.3);
    }

    .pagination a.active {
      background-color: #2980b9;
      color: white;
      border-color: #2980b9;
    }

    .pagination a.disabled {
      cursor: not-allowed;
      color: #ccc;
      background-color: #f4f4f9;
    }

    .pagination a:hover.disabled {
      background-color: #f4f4f9;
      color: #ccc;
      box-shadow: none;
    }

    .pagination .active {
      font-weight: bold;
    }
    .pagination .page-link {
      justify-content: center;
      align-items: center;
    }
  </style>
</head>
<body>
<div class="container mt-5">
  <h1 class="mb-4">게시판 관리</h1>

  <!-- 게시글 조회 폼 -->
  <form class="form-inline mb-4" action="${contextPath}/admin/boardManagement" method="get">
    <input type="text" name="bb_bm_id" class="form-control mr-2" placeholder="게시글 ID 검색" value="${bb_bm_id}">
    <button type="submit" class="btn btn-primary">검색</button>
  </form>

  <!-- 게시글 목록 테이블 -->
  <table class="table table-bordered">
    <thead class="thead-dark">
    <tr>
      <th>게시글 번호</th>
      <th>작성자 ID</th>
      <th>제목</th>
      <th>내용</th>
      <th>작성일</th>
      <th>조회수</th>
      <th>삭제</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="board" items="${boardList}">
      <tr>
        <td>${board.bb_no}</td>
        <td>${board.bb_bm_id}</td>
        <td>${board.bb_title}</td>
        <td>${board.bb_content}</td>
        <td>${board.bb_date}</td>
        <td>${board.bb_readCount}</td>


        <td>
          <form action="${contextPath}/admin/deleteBoard" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
            <input type="hidden" name="bb_no" value="${board.bb_no}">
            <button type="submit" class="btn btn-sm btn-danger">삭제</button>
          </form>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

  <c:if test="${empty boardList}">
    <p>조회된 게시글이 없습니다.</p>
  </c:if>

  <!-- 페이지네이션 -->
  <nav>
    <ul class="pagination justify-content-center">
      <!-- 이전 페이지로 이동 -->
      <c:if test="${page > 1}">
        <li class="page-item">
          <a class="page-link" href="?page=${page - 1}&bb_bm_id=${bb_bm_id}">&lt;</a>
        </li>
      </c:if>

      <!-- 페이지 번호 출력 -->
      <c:set var="startPage" value="${page <= 3 ? 1 : page - 2}"/>
      <c:set var="endPage" value="${startPage + 4 <= totalPages ? startPage + 4 : totalPages}"/>

      <c:forEach var="i" begin="${startPage}" end="${endPage}">
        <li class="page-item ${i == page ? 'active' : ''}">
          <a class="page-link" href="?page=${i}&bb_bm_id=${bb_bm_id}">${i}</a>
        </li>
      </c:forEach>

      <!-- 다음 페이지로 이동 -->
      <c:if test="${page < totalPages}">
        <li class="page-item">
          <a class="page-link" href="?page=${page + 1}&bb_bm_id=${bb_bm_id}">&gt;</a>
        </li>
      </c:if>
    </ul>
  </nav>


<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
