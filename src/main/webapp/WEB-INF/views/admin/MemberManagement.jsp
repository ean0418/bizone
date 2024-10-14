<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>회원 관리</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f9; /* 부드러운 배경색 */
            color: #2c3e50; /* 딥 네이비 텍스트 색상 */
        }

        h1 {
            font-size: 3rem;
            font-weight: bold;
            color: #34495e; /* 세련된 네이비 */
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

    </style>
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4">회원 관리 페이지</h1>

    <!-- 회원 조회 폼 -->
    <form class="form-inline mb-4" action="${contextPath}/admin/searchMember" method="get">
        <input type="text" name="bm_id" class="form-control mr-2" placeholder="회원 ID 입력">
        <button type="submit" class="btn btn-primary">조회</button>
    </form>

    <!-- 회원 목록 테이블 -->

    <table class="table table-bordered">
        <thead class="thead-dark">
        <tr>
            <th>회원 ID</th>
            <th>회원 PW</th>
            <th>회원 이름</th>
            <th>회원 별명</th>
            <th>회원 주소</th>
            <th>회원 번호</th>
            <th>회원 생일</th>
            <th>이메일</th>
            <th>가입 날짜</th>
            <th>삭제</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="member" items="${members}">
            <tr>
                <td>${member.bm_id}</td>
                <td>${member.bm_pw}</td>
                <td>${member.bm_name}</td>
                <td>${member.bm_nickname}</td>
                <td>${member.bm_address}</td>
                <td>${member.bm_phoneNum}</td>
                <td>${member.bm_birthday}</td>
                <td>${member.bm_mail}</td>
                <td>${member.bm_signupDate}</td>

                <td>
                    <form action="${contextPath}/admin/deleteMember" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <input type="hidden" name="bm_id" value="${member.bm_id}">
                        <button type="submit" class="btn btn-sm btn-danger">삭제</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>


    <c:if test="${empty members}">
        <p>조회된 회원이 없습니다.</p>
    </c:if>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
