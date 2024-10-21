<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 10. 18.
  Time: 오전 10:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>찜한 대출상품 목록</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<form action="${contextPath}/favorite"  method="get"
      enctype="multipart/form-data">
<div class="container mt-5">
    <h1>찜한 대출상품 목록</h1>

    <c:if test="${not empty favorites}">
        <div class="row">
            <c:forEach var="favorite" items="${favorites}">
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <div class="card-body">
                            <h5 class="card-title">${favorite.bf_product_name}</h5>
                            <p class="card-text">
                                <strong>대출 한도:</strong> ${favorite.bf_loan_limit}만원<br/>
                                <strong>금리:</strong> ${favorite.bf_interest_rate}%<br/>
                                <strong>자격 조건:</strong> ${favorite.bf_qualification}
                            </p>
                            <!-- 찜한 대출상품 삭제 버튼 -->
                            <form action="${contextPath}/deleteFavorite" method="post">
                                <input type="hidden" name="bf_id" value="${favorite.bf_id}">
                                <button type="submit" class="btn btn-danger">삭제</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <c:if test="${empty favorites}">
        <p>찜한 대출상품이 없습니다.</p>
    </c:if>
</div>
</form>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
