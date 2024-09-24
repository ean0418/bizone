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
    <script type="text/javascript" src="../resources/js/memberCheck.js"></script>
    <script type="text/javascript" src="../resources/js/validChecker.js"></script>
    <script type="text/javascript" src="../resources/js/function.js"></script>
    <style>
        @font-face {
            font-family: 'a5'; /* 사용자가 정의할 폰트 이름 */
            src: url('resources/ttf/A말머리5.TTF') format('truetype'); /* 폰트 경로와 형식 지정 */
            font-weight: normal;
            font-style: normal;
        }
        img {
            margin: 0;
            height: 70vh;
            display: flex;
            justify-content: flex-start; /* 이미지 시작 위치 */
            background-color: white;
        }

        /* HTML과 BODY에 100% 높이를 설정 */
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        /* 메인 콘텐츠 섹션이 Flexbox 안에서 확장되도록 설정 */
        .container-fluid {
            flex: 1;
        }

        /* 푸터를 아래로 밀기 위한 설정 */
        footer {
            margin-top: auto;
        }

        body {
            font-family: 'Noto Sans', sans-serif;
            color: white;
            text-align: center;
            animation: fadeIn 2s ease-in-out;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            box-sizing: border-box; /* padding과 margin을 높이에 포함시킴 */
        }

        h1 {
            font-size: 4rem;
            margin-top: 20vh;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes blink {
            0% {
                opacity: 1;
            }
            50% {
                opacity: 0;
            }
            100% {
                opacity: 1;
            }
        }

        .button {
            padding: 20px 40px; /* 버튼 크기 키움 (패딩 확장) */
            border: none;
            color: white;
            font-size: 2rem; /* 폰트 크기 키움 */
            border-radius: 8px; /* 둥근 버튼 모서리 */
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 20px; /* 버튼과 텍스트 사이에 공간 추가 */
        }
        .description .highlight {
            color: #101E4E;
        }
        .description {
            margin-top: 30px;
            font-size: 7rem; /* 폰트 크기 키움 */
            color: #333; /* 글씨 색상 */
            text-align: center;
            font-family: 'a5', serif;
            animation: slideInLeft 1.5s ease-in-out; /* 애니메이션 추가 */
        }

    </style>
</head>
<body>

<!-- 전체 페이지를 감싸는 컨테이너 -->
<div class="container-fluid">
    <!-- 헤더 섹션 -->
    <div class="row">
        <div class="col-12 p-0">
            <jsp:include page="WEB-INF/views/header.jsp" />
        </div>
    </div>

    <!-- 메인 콘텐츠 섹션 -->
    <div class="row">
        <div class="col-md-6 p-0">
            <img src="resources/image/2.jpg" alt="" >
        </div>
        <div class="col-md-6 p-0 d-flex flex-column align-items-center justify-content-center">
            <div class="description">
              <p>창업을 원하는 <br>모든 이들을 위한<br><span class="highlight">상권분석</span> 사이트</p>
                <a href="main"><button type="button" class="btn btn-outline-primary w-50 p-3" style="color: #101E4E; border-color: #101E4E;">분석하기</button></a>
            </div>
        </div>
    </div>
</div>

<!-- 푸터 섹션 -->
<footer class="row" style="padding: 0;">
    <div class="col-12 p-0">
        <div class="container-fluid">
            <nav class="navbar navbar-expand bg-body-tertiary">
                <a class="navbar-brand ms-3" href="/">
                    Contact us
                </a>
                <div class="collapse navbar-collapse" id="navbarText">
                    <ul class="navbar-nav me-auto lg-3">
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="#">
                                Github
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                Notion
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
</footer>

<!-- Bootstrap JS 및 jQuery 추가 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>