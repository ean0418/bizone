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
            width: 80%;
            height: auto;
            object-fit: cover; /* 이미지 비율 유지하면서 채움 */
            transition: transform 0.3s ease-in-out;
            margin-left: 250px;
            justify-content: center;
            align-items: center;
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
            margin-top: 10px; /* 이미지와 버튼 사이 간격 */
            margin-left: 850px;
        }

        .btn-primary:hover {
            background-color: #2980b9;
        }


        .faq h2 {
            font-size: 2rem;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .btn-primary2 {
            background-color: #3498db;
            border-color: #2980b9;
            color: white;
            font-size: 1.1rem;
            margin: 10px;
            border-radius: 6px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn-primary2:hover {
            background-color: #2980b9;
            transform: scale(1.05);
        }

        .btn-link {
            color: white;
            text-decoration: none;
        }

        .btn-link:hover {
            color: #f1c40f;
            text-decoration: none;
        }

        .container.mt-5 {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* 오른쪽 아래 고정된 FAQ 및 문의하기 버튼 */
        .faq {
            position: fixed;
            bottom: 80px; /* 화면 하단에서 20px 위에 배치 */
            right: 20px; /* 화면 오른쪽에서 20px 안쪽에 배치 */
            z-index: 9999; /* 항상 위에 보이도록 z-index 설정 */
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        h2 {

        }

        .btn-primary2 {
            background-color: #3498db;
            border-color: #2980b9;
            color: white;
            font-size: 1.1rem;
            margin: 10px 0;
            border-radius: 6px;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .btn-primary2:hover {
            background-color: #2980b9;
            transform: scale(1.05);
        }

        .btn-link {
            color: white;
            text-decoration: none;
        }

        .btn-link:hover {
            color: #f1c40f;
        }

        .modal-header .close:hover {
            color: #d3d3d3;
        }

        .modal-body {
            padding: 20px;
            font-family: 'Arial', sans-serif;
        }

        .modal-body h2 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .modal-body p {
            font-size: 1rem;
            line-height: 1.6;
            color: #34495e;
            margin-bottom: 20px;
        }

        .content-section {
            margin-bottom: 20px;
        }

        .modal-footer {
            border-top: none;
            padding: 15px;
            justify-content: flex-end;
        }

        .btn-secondary {
            background-color: #7f8c8d;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: #6c7b8b;
        }

        /* 모달 푸터 */
        .modal-footer {
            border-top: none;
            padding: 15px;
            justify-content: flex-end;
        }

        /* 버튼 스타일 */
        .btn-primary {
            background-color: #2980b9;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #1f639a;
        }

        .btn-secondary {
            background-color: #7f8c8d;
            border: none;
            padding: 10px 20px;
            border-radius: 30px;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }

        .btn-secondary:hover {
            background-color: #6c7b8b;
        }
    </style>
</head>
<body>

    <!-- 이미지 및 상권분석 안내 -->
    <div class="modal-body">
            <img src="${pageContext.request.contextPath}/resources/image/주소검색2.gif" alt="상권분석 안내">
    </div>

    <div>
        <a href="${contextPath}/main" class="btn btn-primary">상권분석 시작하기</a>
    </div>

    <!-- FAQ 및 추가 리소스 -->
    <div class="faq text-center">
        <h2>자주 묻는 질문</h2>
        <div class="container mt-5">
            <button type="button" class="btn btn-primary2" data-toggle="modal" data-target="#faqModal">
                상권분석이란 무엇인가요?
            </button>
            <br>
            <button type="button" class="btn btn-primary2">
                <a href="${contextPath}/board" class="btn-link">문의하기</a>
            </button>
        </div>
    </div>


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
                <div class="content-section">
                    <h2>상권분석 개요</h2>
                    <p>
                        상권분석이란 특정 지역의 경제적, 인구적 요소를 분석하여 해당 지역에서 비즈니스가 얼마나 성공할 가능성이 있는지를 평가하는 과정입니다.
                        상권분석은 예비 창업자나 기존 사업자가 새로운 사업 기회를 탐색하거나 기존 비즈니스의 성과를 극대화하기 위해 필수적인 정보를 제공합니다.
                    </p>
                </div>

                <div class="content-section">
                    <h2>상권분석 기능</h2>
                    <p>
                        우리 상권분석 플랫폼은 이러한 분석을 데이터 기반으로 제공하여, 예비 창업자들이 더 나은 결정을 내릴 수 있도록 돕습니다.
                        사용자가 선택한 업종과 행정동을 기반으로 상권의 경쟁력과 잠재력을 평가하고, 맞춤형 성공률을 예측합니다.
                    </p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
