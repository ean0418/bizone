<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 23.
  Time: 오전 11:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="${contextPath}/resources/css/main.css">
</head>
<body>
<div class="row">
    <div class="col-md-6 p-0">
        <img src="${contextPath}/resources/image/2.jpg" alt="" >
    </div>
    <div class="col-md-6 p-0 d-flex flex-column align-items-center justify-content-center">
        <div class="description">
            <p>창업을 원하는 <br>모든 이들을 위한<br><span class="highlight">상권분석</span> 사이트</p>
            <a href="${contextPath}/main"><button type="button" class="btn btn-outline-primary w-50 p-3" style="color: #101E4E; border-color: #101E4E;">분석하기</button></a>
        </div>
    </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
</body>
</html>
