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
  <style>
    /* HTML과 BODY에 100% 높이를 설정 */
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      overflow: hidden;
    }

    /* Body를 Flexbox 컨테이너로 설정하여 세로 정렬 */
    body {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
      box-sizing: border-box;
    }

    /* 메인 콘텐츠 섹션이 Flexbox 안에서 확장되도록 설정 */
    .container-fluid {
      flex: 1;
    }

    /* 푸터를 아래로 밀기 위한 설정 */
    footer {
      margin-top: auto;
    }
  </style>
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
    <div class="col-12 p-0">
      <jsp:include page="${contentPage}" />
    </div>
  </div>
</div>

<!-- 푸터 섹션 -->
<footer class="row">
  <div class="col-12 p-0">
    <jsp:include page="../footer.jsp" />
  </div>
</footer>

<!-- Bootstrap JS 및 jQuery 추가 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
