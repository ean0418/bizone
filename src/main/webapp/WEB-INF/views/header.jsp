<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 10.
  Time: 오전 10:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<style>
    .logo-image {
        height: 50px; /* Adjust height as needed */
        margin-right: 10px; /* Space between logo and text */
        background-color: #101E4E;
    }

    .navbar-brand {
        display: flex;
        align-items: center;
    }
</style>
<body>
<nav class="navbar navbar-dark" style="background-color: #101E4E;">
    <div class="container-fluid">
        <a class="navbar-brand fs-3 ms-3" href="/" style="font-size: 40px">
            <img src="${contextPath}/resources/image/icon.png" alt="Bizone Icon" class="logo-image me-2" style="height: 50px;">
            Bizone <h3 style="display: inline">${r} ${errorMsg}</h3>
        </a>
        <!-- Right-aligned menu items, always visible -->
        <div class="d-flex ms-auto align-items-center">
            <!-- Login and Signup links -->
            <c:choose>
                <c:when test="${sessionScope.loginMember == null}">
                    <a class="nav-link text-light ms-3" href="${contextPath}/member.login.go" style="white-space: nowrap;">로그인</a>
                    <a class="nav-link text-light ms-3" href="${contextPath}/member.step1" style="white-space: nowrap;">회원가입</a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link text-light ms-3" href="${contextPath}/member.info.go" style="white-space: nowrap;">${sessionScope.loginMember['bm_nickname']} 님</a>
                    <a class="nav-link text-light ms-3" href="${contextPath}/member.logout" style="white-space: nowrap;">로그아웃</a>
                </c:otherwise>
            </c:choose>
            <!-- Toggle button for "지도" and "공지사항" items -->
            <button class="navbar-toggler ms-3 my-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavItems" aria-controls="mainNavItems" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </div>
        <!-- Collapsible menu for "지도" and "공지사항" items -->
        <div class="collapse navbar-collapse" id="mainNavItems">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ms-4" href="${contextPath}/main" style="text-align: left">지도</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ms-4" href="${contextPath}/board" style="text-align: left">공지사항</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ms-4" href="${contextPath}/info" style="text-align: left">마이페이지</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

</body>
</html>