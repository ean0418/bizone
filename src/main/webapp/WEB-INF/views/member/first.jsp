<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>상권분석 안내</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
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
            position: relative; /* FAQ를 절대 위치시키기 위해 필요 */
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
            margin-left: 340px;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
        }

        /* 마우스 오버 시 확대 효과 */
        .modal-body:hover {
            transform: scale(1.03);
        }

        /* 부드러운 애니메이션 */
        .modal-body img:hover {
            transform: scale(1.05); /* 이미지 확대 */
        }

        /* 상권분석 시작하기 버튼 스타일 */
        .btn-primary {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            font-size: 1.2rem;
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s ease;
            margin-top: 20px; /* 이미지와 버튼 사이 간격 */
            margin-left: 850px;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }

        /* FAQ 스타일 */
        .faq {
            position: absolute; /* 절대 위치 설정 */
            top: 70%; /* 상단에서 10% 아래 */
            right: 2%; /* 오른쪽에서 5% 떨어짐 */
            width: 250px; /* 고정된 너비 */
            text-align: left; /* 오른쪽 정렬 */
        }

        .faq h2 {
            font-size: 1.5rem;
            color: #34495e;
        }

        .faq ul {
            list-style-type: none;
            padding: 0;
        }

        .faq ul li {
            margin-bottom: 10px;
        }

        .faq ul li a {
            text-decoration: none;
            color: #2980b9;
            font-size: 1.1rem;
        }

        .faq ul li a:hover {
            text-decoration: underline;
        }

        /* 모달 크기 및 배경 스타일 */
        .modal-lg {
            max-width: 1500px;
        }

        .modal-body {
            padding: 20px;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        /* 모달 제목 스타일 */
        .modal-title {
            font-size: 1.75rem;
            font-weight: bold;
            color: #2c3e50;
        }

        /* 리스트 스타일 */
        .modal-body ul {
            list-style-type: none;
            padding: 0;
        }

        .modal-body ul li {
            padding: 10px;
            margin-bottom: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* 항목 제목 */
        .modal-body ul li strong {
            font-weight: bold;
            color: #2c3e50;
        }

        /* 버튼 스타일 */
        .modal-footer .btn-secondary {
            background-color: #34495e;
            border-color: #34495e;
        }

        .modal-footer .btn-secondary:hover {
            background-color: #2c3e50;
            border-color: #2c3e50;
        }
    </style>
</head>
<body>
<table>
    <!-- 이미지 및 상권분석 안내 -->
    <div class="modal-body">
            <img src="${pageContext.request.contextPath}/resources/image/주소검색2.gif" alt="상권분석 안내">
    </div>

    <div>
        <a href="${contextPath}/main" class="btn btn-primary">상권분석 시작하기</a>
    </div>

    <!-- FAQ 및 추가 리소스 -->
    <div class="faq">
        <h2>자주 묻는 질문</h2>
            <div class="container mt-5">
                <button type="button" class="btn btn-primary2" data-toggle="modal" data-target="#faqModal">
                    상권분석이란 무엇인가요?
                </button>
                <button type="button" class="btn btn-primary2">
                    <a href="${contextPath}/board">문의하기</a>
                </button>
            </div>
    </div>
</table>


<!-- 모달 창 -->
<div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="faqModalLabel">상권분석이란 무엇인가요?</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <tr>
                    <td>
                        상권분석 개요
                    </td>
                    <td>
                            상권분석이란 특정 지역의 경제적, 인구적 요소를 분석하여 해당 지역에서 비즈니스가 얼마나 성공할 가능성이 있는지를 평가하는 과정입니다.
                            상권분석은 예비 창업자나 기존 사업자가 새로운 사업 기회를 탐색하거나 기존 비즈니스의 성과를 극대화하기 위해 필수적인 정보를 제공합니다.
                    </td>
                </tr>
                <h5>우리 상권분석 플랫폼의 기능</h5>
                <p>
                    우리 상권분석 플랫폼은 이러한 분석을 데이터 기반으로 제공하여, 예비 창업자들이 더 나은 결정을 내릴 수 있도록 돕습니다.
                    사용자가 선택한 업종과 행정동을 기반으로 상권의 경쟁력과 잠재력을 평가하고, 맞춤형 성공률을 예측합니다.
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
