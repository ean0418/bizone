<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>상권분석 안내</title>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .modal-body {
            width: 90%;
            height: 90%;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        /* 이미지 스타일 */
        .modal-body img {
            width: 70%;
            height: auto;
            object-fit: cover; /* 이미지 비율 유지하면서 채움 */
            transition: transform 0.3s ease-in-out;
            margin-top: 120px; /* 이미지가 아래로 위치하도록 */
            margin-left: 90px;
        }

        /* 마우스 오버 시 확대 효과 */
        .modal-body:hover {
            transform: scale(1.03);
        }

        /* 부드러운 애니메이션 */
        .modal-body img:hover {
            transform: scale(1.05); /* 이미지 확대 */
        }

    </style>
</head>
<body>
<table>
<div class="modal-body">
    <img src="${pageContext.request.contextPath}/resources/image/주소검색.gif" alt="상권분석 안내">
</div>
</table>
</body>
</html>
