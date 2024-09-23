<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>회원가입</title>
    <script language="javascript">
        function goPopup() {
            // 팝업 창 열기 (주소 검색 팝업 페이지로 연결)
            var pop = window.open("/pop/jusoPopup.jsp", "pop", "width=570,height=420, scrollbars=yes, resizable=yes");
        }

        // 팝업 창에서 반환된 주소 정보를 메인 폼 필드에 채우는 함수
        function jusoCallBack(zipNo, roadAddrPart1, addrDetail) {
            document.getElementById('bm_addr1').value = zipNo;          // 우편번호
            document.getElementById('bm_addr2').value = roadAddrPart1;   // 도로명 주소
            document.getElementById('bm_addr3').value = addrDetail;     // 상세 주소
            document.getElementById('bm_address').value = zipNo + ' ' + roadAddrPart1 + ' ' + addrDetail; // 전체 주소
        }


    </script>
    <style>
        .step-indicator {
            display: flex;
            margin-bottom: 20px;
            justify-content: center;
        }

        .step-indicator span {
            display: inline-block;
            width: 35px;
            height: 35px;
            line-height: 35px;
            border-radius: 50%;
            background-color: #444;
            color: white;
            font-weight: bold;
            margin: 0 10px;
        }

        .step-indicator .active, .inactive {
            background-color: #2ecc71;
            text-align: center;
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: white;
            color: #d3d7da;
            margin: 0;
            display: flex;
            overflow-y: auto;
            min-height: 100vh;
        }

        /* 회원가입 폼을 감싸는 컨테이너 */
        #signupContainer {
            width: 100%;
            max-width: 450px; /* 폼의 최대 너비 설정 */
            margin: 20px auto;
            background-color: #2b2e33;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        /* 회원가입 폼에 호버 시 애니메이션 */
        #signupContainer:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.7);
        }

        /* 제목 스타일 */
        h1 {
            text-align: center;
            color: #ffffff;
            font-size: 24px; /* 제목 크기 축소 */
            margin-bottom: 20px;
            font-weight: 600;
        }

        /* 테이블 스타일 */
        #signupTbl {
            width: 100%;
            border-collapse: collapse;
        }

        #signupTbl td {
            padding: 8px 0; /* 행 간격을 조금 더 줄임 */
        }

        /* 폼의 레이블 스타일 */
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #ffffff;
            font-size: 14px; /* 폰트 크기 축소 */
            align-items: center;
            justify-content: center;
        }

        /* 입력 필드 스타일 */
        input.i1 {
            width: 100%;
            padding: 12px; /* 입력 필드의 패딩을 줄여줌 */
            margin-top: 5px;
            border: 1px solid #555;
            border-radius: 8px;
            background-color: rgba(46, 51, 56, 0.8);
            color: #d3d7da;
            box-sizing: border-box;
            font-size: 13px; /* 입력 필드의 폰트 크기를 줄여줌 */
            transition: border-color 0.3s ease, background-color 0.3s ease, box-shadow 0.3s ease;
        }

        input.i1:focus {
            border-color: #5dade2;
            background-color: rgba(46, 51, 56, 1);
            box-shadow: 0 0 8px rgba(93, 173, 226, 0.7);
            outline: none;
        }

        /* 메시지 스타일 */
        #msg {
            margin-top: 5px;
            font-size: 12px;
            color: #e74c3c;
        }

        /* 버튼 스타일 */
        button.submit-btn, button.address-btn, button#email-btn {
            width: 100%;
            padding: 12px; /* 버튼의 패딩을 줄여줌 */
            background-color: #2ecc71;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px; /* 버튼 폰트 크기 축소 */
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        button.submit-btn:hover button#email-btn {
            background-color: #27ae60;
            transform: scale(1.02);
        }

        button.address-btn[type="button"] {
            background-color: #3498db;
        }

        button.address-btn[type="button"]:hover {
            background-color: #2980b9;
        }

        /* 주소 검색 버튼 */
        button.address-btn[type="button"] {
            margin-bottom: 15px;
        }

        button.submit-btn[type="submit"] {
            margin-top: 20px;
        }

        input[type="text"], input[type="password"] {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }
    </style>
</head>
<body>
<div id="signupContainer">
    <form action="member.signup" METHOD="post" name="signupForm"
          onsubmit="return signupCheck();">
        <table id="signupTbl">
            <tr>
                <td colspan="2">
                    <label style="text-align: center; font-size: 16pt;">회원가입</label>
                    <div class="step-indicator">
                        <span class="inactive">1</span> → <span  class="active">2</span> → <span class="inactive">3</span>
                    </div>
                    <input id="bm_id" name="bm_id" placeholder="ID" autofocus="autofocus"
                           autocomplete="off" maxlength="10" class="i1">
                    <div id="msg"></div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input name="bm_pw" placeholder="PASSWORD" autocomplete="off"
                           maxlength="10" class="i1" type="password">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input id="bm_pw_confirm" placeholder="PASSWORD CHECK" autocomplete="off"
                           maxlength="10" class="i1" type="password">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input name="bm_name" placeholder="NAME" autocomplete="off" maxlength="10" class="i1">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input name="bm_nickname" placeholder="NICKNAME" autocomplete="off" maxlength="20" class="i1">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <!-- 주소 검색 버튼 -->
                    <button class="address-btn" type="button" onclick="goPopup()">주소 검색</button><br>

                    <!-- 주소 입력 필드 -->

                    <input type="text" id="bm_addr1" name="bm_addr1" placeholder="Zip Code" readonly="readonly" class="i1">
                    <input type="text" id="bm_addr2" name="bm_addr2" placeholder="Address" readonly="readonly" class="i1">
                    <input type="text" id="bm_addr3" name="bm_addr3" placeholder="Detail Address" autocomplete="off" class="i1">
                    <input type="hidden" id="bm_address" name="bm_address">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input name="bm_phoneNum" placeholder="Phone Number" autocomplete="off" maxlength="20" class="i1">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input name="bm_birthday" placeholder="Birthday (YYYY-MM-DD)" pattern="\d{4}-\d{2}-\d{2}"
                           autocomplete="off" maxlength="20" class="i1" required>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input name="bm_mail" id="bm_mail" placeholder="Email" autocomplete="off" maxlength="50" class="i1">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <button id="email-btn" type="button">이메일 인증</button>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input id="checkMailAuth" placeholder="인증번호 입력" disabled="disabled" class="i1"><br>
                    <div id="warnMailAuth"></div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <button class="submit-btn" type="submit">Sign Up</button>
                </td>
            </tr>
        </table>
    </form>
</div>
<script language="JavaScript">
    console.log('js연결 성공')
    let code = 0;
    document.getElementById("email-btn").addEventListener("click", () => {
        console.log('이벤트리스너 들어옴')
        const xhr = new XMLHttpRequest();
        let email = document.querySelector("#bm_mail").value;
        console.log(email)
        const reqJson = {};
        reqJson.email = email
        let checkInput = document.querySelector("#checkMailAuth")

        xhr.onreadystatechange = () => {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var result = xhr.response;
                    code = result.code;
                    checkInput.disabled = false;
                    alert('성공!!');
                } else {
                    alert('request에 뭔가 문제가 있어요.');
                }
            }
        };
        xhr.open("POST", '/email.send', true);
        xhr.responseType = "json";
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.send(JSON.stringify(reqJson));
    })

    document.getElementById("checkMailAuth").addEventListener('change', () => {
        const inputCode = document.querySelector("#checkMailAuth").value;
        const resultMsg = document.getElementById("warnMailAuth");
        console.log(inputCode);
        console.log(code);
        if (inputCode === code + "") {
            resultMsg.textContent = '인증 완료';
            resultMsg.setAttribute("style", "color: green;");
            document.getElementById("bm_mail").setAttribute("readonly", true);
        } else {
            resultMsg.textContent = '인증번호가 불일치합니다. 인증번호를 다시 한 번 확인해주세요!';
            resultMsg.setAttribute("style", "color: red;");
        }
    })
</script>
</body>
</html>
