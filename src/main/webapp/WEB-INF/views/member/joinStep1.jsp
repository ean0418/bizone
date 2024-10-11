<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 19.
  Time: 오전 9:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 약관 동의</title>

</head>
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: white;
        color: #d3d7da;
        margin: 0;
        padding: 0;
        display: flex;
        height: 100vh;
    }

    .container {
        width: 100%;
        max-width: 600px;
        margin: 20px auto;
        background-color: white;
        border-radius: 10px;
        padding: 30px;
        box-shadow: 0px 10px 20px #101E4E;
    }

    h1 {
        text-align: center;
        margin-bottom: 30px;
        font-size: 24px;
        color: #ffffff;
    }

    .agreement-box {
        padding: 20px;
        border: 1px solid white;
        border-radius: 8px;
        background-color: white;
    }

    .checkbox-wrapper {
        margin-bottom: 20px;
    }

    .checkbox-label {
        font-size: 18px;
        font-weight: 700;
        color: #101E4E;
    }

    .checkbox-wrapper p {
        margin-top: 5px;
        color: #101E4E;
        font-size: 14px;
    }

    .checkbox {
        margin-right: 15px;
        vertical-align: middle;
        width: 20px;
        height: 20px;
        cursor: pointer;
    }

    .terms-group {
        margin-top: 25px;
    }

    .terms-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 15px;
        border-bottom: 1px solid #101E4E;
        position: relative;
    }

    .terms-item:last-child {
        border-bottom: none;
    }

    .terms-content {
        display: none;
        font-size: 14px;
        color: #b0b8bf;
        padding: 10px;
        background-color: #101E4E;
        border-radius: 5px;
        margin-top: 10px;
        line-height: 1.6;
        animation: fadeIn 0.5s ease-in-out;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    .view-details {
        background-color: transparent;
        border: 1px solid #3498db;
        border-radius: 5px;
        padding: 5px 10px;
        color: #3498db;
        font-size: 14px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .view-details:hover {
        background-color: #3498db;
        color: #fff;
    }
    h1 {
        color:#101E4E
    }
    .submit-btn {
        width: 100%;
        padding: 15px;
        background-color: #101E4E;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 18px;
        cursor: pointer;
        margin-top: 30px;
        transition: background-color 0.3s ease;
    }
    .step-indicator {
        display: flex;
        justify-content: center;
        margin-bottom: 20px;
    }

    .step-indicator span {
        display: inline-flex; /* flex를 사용하여 가로 및 세로로 중앙 배치 */
        justify-content: center; /* 가로 중앙 정렬 */
        align-items: center; /* 세로 중앙 정렬 */
        width: 35px; /* 원의 너비 */
        height: 35px; /* 원의 높이 */
        border-radius: 50%; /* 원형으로 만듦 */
        background-color: #101E4E; /* 기본 원 배경색 */
        color: white;
        font-weight: bold;
        margin: 0 10px;
        font-size: 16px; /* 숫자 크기 */
    }

    .step-indicator .active {
        background-color: #101E4E;
    }
    .submit-btn:hover {
        background-color: #101E4E;
    }

    /* 추가 스타일 */
    .checkbox-label,
    .view-details {
        user-select: none;
    }
</style>
<body>
<form action = "${contextPath}/member/signup" method="get">
    <div class="container">
        <h1>회원가입</h1>
        <div class="step-indicator">
            <span class="active">1</span> → <span>2</span> → <span>3</span>
        </div>
        <div class="agreement-box">
            <div class="checkbox-wrapper">
                <input type="checkbox" id="checkAll" class="checkbox" onclick="toggleAll(this)">
                <label for="checkAll" class="checkbox-label">전체 동의하기</label>
                <p>실명 인증된 아이디로 가입, 위치기반서비스 이용약관(선택), 이벤트 • 혜택 정보 수신(선택) 등을 포함합니다.</p>
            </div>

            <div class="terms-group">
                <div class="terms-item">
                    <input type="checkbox" id="terms1" class="checkbox individual" onclick="updateCheckAll()" required>
                    <label for="terms1" class="checkbox-label">[필수] 네이버 이용약관</label>
                    <button class="view-details" onclick="toggleDetails(this)">전체보기</button>
                    <div class="terms-content">여러분을 환영합니다. 네이버 서비스 및 제품을 이용해 주셔서 감사합니다...</div>
                </div>

                <div class="terms-item">
                    <input type="checkbox" id="terms2" class="checkbox individual" onclick="updateCheckAll()" required>
                    <label for="terms2" class="checkbox-label">[필수] 개인정보 수집 및 이용</label>
                    <button class="view-details" onclick="toggleDetails(this)">전체보기</button>
                    <div class="terms-content">개인정보 보호법에 따라 네이버에 회원가입 신청하시는 분께...</div>
                </div>

                <div class="terms-item">
                    <input type="checkbox" id="terms3" class="checkbox individual" onclick="updateCheckAll()" required>
                    <label for="terms3" class="checkbox-label">[선택] 실명 인증된 아이디로 가입</label>
                    <button class="view-details" onclick="toggleDetails(this)">전체보기</button>
                    <div class="terms-content">실명 인증된 아이디로 가입하면 본인인증이 필요한 서비스...</div>
                </div>

                <div class="terms-item">
                    <input type="checkbox" id="terms4" class="checkbox individual" onclick="updateCheckAll()" required>
                    <label for="terms4" class="checkbox-label">[선택] 위치기반서비스 이용약관</label>
                    <button class="view-details" onclick="toggleDetails(this)">전체보기</button>
                    <div class="terms-content">위치기반서비스 이용약관에 동의하시면, 위치를 활용한 광고 정보...</div>
                </div>

                <div class="terms-item">
                    <input type="checkbox" id="terms5" class="checkbox individual" onclick="updateCheckAll()" required>
                    <label for="terms5" class="checkbox-label">[선택] 개인정보 수집 및 이용</label>
                    <button class="view-details" onclick="toggleDetails(this)">전체보기</button>
                    <div class="terms-content">개인정보의 수집 및 이용에 동의하시면 다양한 혜택 정보를...</div>
                </div>
            </div>

            <button class="submit-btn" type="submit">다음</button>
        </div>
    </div>

    <script>
        // 전체 동의 체크박스를 클릭했을 때, 모든 개별 체크박스 상태 변경
        function toggleAll(checkbox) {
            const checkboxes = document.querySelectorAll('.individual');
            checkboxes.forEach(cb => cb.checked = checkbox.checked);
        }

        // 개별 체크박스를 클릭했을 때, 전체 동의 체크박스 상태 업데이트
        function updateCheckAll() {
            const checkAllBox = document.getElementById('checkAll');
            const individualBoxes = document.querySelectorAll('.individual');
            const allChecked = Array.from(individualBoxes).every(cb => cb.checked);
            const someChecked = Array.from(individualBoxes).some(cb => cb.checked);

            checkAllBox.checked = allChecked;
            checkAllBox.indeterminate = !allChecked && someChecked;
        }

        // 약관 상세보기 토글 처리
        function toggleDetails(button) {
            const termsContent = button.nextElementSibling;
            if (termsContent.style.display === "block") {
                termsContent.style.display = "none";
                button.textContent = "전체보기";
            } else {
                termsContent.style.display = "block";
                button.textContent = "닫기";
            }
        }

        // 폼 제출 로직
        function submitForm() {
            // 여기서 약관 동의를 처리하는 로직을 추가하세요.
        }
    </script>
</form>
    </body>
</html>
