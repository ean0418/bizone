<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 26.
  Time: 오후 4:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Loan Products</title>
</head>
<body>
<h2>대출상품 추천</h2>

<!-- 대출상품 API 호출 -->
<form action="loan-products" method="get">
  <label>금리구분:</label>
  <input type="text" name="IRT_CTG" />

  <label>용도:</label>
  <input type="text" name="USGE" />

  <label>기관구분:</label>
  <input type="text" name="INST_CTG" />

  <label>거주지역:</label>
  <input type="text" name="RSD_AREA_PAMT_EQLT_ISTM" />

  <label>대상 필터:</label>
  <input type="text" name="TGT_FLTR" />

  <button type="submit">조회</button>
</form>

<!-- 데이터 출력 -->
<div>
  <h3>대출상품 리스트</h3>
  <ul>
    <!-- 컨트롤러에서 전달된 데이터를 JSTL을 이용해 출력 -->
    <c:forEach var="product" items="${loanProducts}">
      <li>${product}</li>
    </c:forEach>
  </ul>
</div>
</body>
</html>
