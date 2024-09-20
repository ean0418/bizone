
<%--수정 전 코드2 695af2d9d27326c791e215b580236791--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport"
        content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Main Layout</title>
  <!-- Bootstrap CSS 추가 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

<!-- 전체 페이지를 감싸는 컨테이너 -->
<div class="container-fluid">
  <!-- 헤더 섹션 -->
  <div class="row">
    <div class="col-12 p-0">
      <jsp:include page="../header.jsp" />
    </div>
  </div>

  <!-- 메인 콘텐츠 섹션 -->
  <div class="row">
    <div class="col-12 p-0" style="background-color: transparent">
      <jsp:include page="${contentPage}" />
    </div>
  </div>

  <!-- 푸터 섹션 -->
  <div class="row">
    <div class="col-12 p-0">
      <jsp:include page="../footer.jsp" />
    </div>
  </div>
</div>

<!-- Bootstrap JS 및 jQuery 추가 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>



<%--수정전코드--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>--%>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>--%>
<%--<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>--%>
<%--<!doctype html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--  <meta charset="UTF-8">--%>
<%--  <meta name="viewport"--%>
<%--        content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">--%>
<%--  <meta http-equiv="X-UA-Compatible" content="ie=edge">--%>
<%--  <title>Document</title>--%>
<%--</head>--%>
<%--<body>--%>
<%--<table id="header">--%>
<%--  <tr>--%>
<%--    <td>--%>
<%--      <jsp:include page="../header.jsp" />--%>
<%--    </td>--%>
<%--  </tr>--%>
<%--</table>--%>
<%--<table id="content">--%>
<%--  <tr>--%>
<%--    <td>--%>
<%--      <div><jsp:include page="${contentPage}" /></div>--%>
<%--    </td>--%>
<%--  </tr>--%>
<%--</table>--%>
<%--<table id="footer">--%>
<%--  <tr>--%>
<%--    <td>--%>
<%--      <jsp:include page="../footer.jsp" />--%>
<%--    </td>--%>
<%--  </tr>--%>
<%--</table>--%>
<%--</body>--%>
<%--</html>--%>