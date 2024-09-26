<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>대출상품 추천</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f4f4f9;
      color: #333;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }

    h2 {
      font-size: 2.2rem;
      color: #2c3e50;
      text-align: center;
      margin-bottom: 1.5rem;
    }

    form {
      background-color: #fff;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
      max-width: 600px;
      width: 100%;
    }

    label {
      font-size: 1rem;
      font-weight: 600;
      color: #2c3e50;
      display: block;
      margin-bottom: 0.5rem;
    }

    input[type="text"] {
      width: 100%;
      padding: 0.75rem;
      margin-bottom: 1.5rem;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }

    input[type="text"]:focus {
      border-color: #2980b9;
      outline: none;
    }

    button {
      background-color: #2980b9;
      color: #fff;
      padding: 0.75rem 1.5rem;
      font-size: 1rem;
      font-weight: 600;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s ease;
      display: block;
      width: 100%;
    }

    button:hover {
      background-color: #3498db;
    }

    h3 {
      color: #2980b9;
      margin-top: 2rem;
      font-size: 1.75rem;
      text-align: center;
    }

    ul {
      list-style-type: none;
      padding: 0;
    }

    li {
      background-color: #fff;
      padding: 1.5rem;
      margin-bottom: 1rem;
      border-radius: 10px;
      box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.05);
    }

    li h3 {
      font-size: 1.5rem;
      margin-bottom: 0.75rem;
    }

    li p {
      margin: 0.5rem 0;
      font-size: 1rem;
      color: #555;
    }
  </style>
</head>
<body>
<h2>대출상품 추천</h2>

<form action="/loan-products" method="get">
  <label>금리구분:</label>
  <input type="text" name="IRT_CTG" value="${irtCtg}" />

  <label>용도:</label>
  <input type="text" name="USGE" value="${usge}" />

  <label>기관구분:</label>
  <input type="text" name="INST_CTG" value="${instCtg}" />

  <label>거주지역:</label>
  <input type="text" name="RSD_AREA_PAMT_EQLT_ISTM" value="${rsdAreaPamtEqltIstm}" />

  <label>대상 필터:</label>
  <input type="text" name="TGT_FLTR" value="${tgtFltr}" />

  <button type="submit">조회</button>
</form>

<h3>대출상품 결과</h3>
<c:if test="${not empty productName}">
  <ul>
    <li>
      <h3>${productName}</h3>
      <p>대출한도: ${loanLimit}만원</p>
      <p>금리: ${interestRate}%</p>
      <p>자격조건: ${qualification}</p>
    </li>
  </ul>
</c:if>

<c:if test="${empty productName}">
  <p>조회된 대출상품이 없습니다.</p>
</c:if>

</body>
</html>
