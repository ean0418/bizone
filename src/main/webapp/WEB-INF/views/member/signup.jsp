<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>회원가입</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <script>
        function searchAddress() {
            const keyword = document.getElementById('searchKeyword').value;

            fetch('/searchAddress?keyword=' + encodeURIComponent(keyword))
                .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok ' + response.statusText);
                }
                return response.json();
            })
                .then(data => {
                    const jusoList = data.results.juso;
                    if (jusoList && jusoList.length > 0) {
                        const firstJuso = jusoList[0];
                        document.getElementById('bm_addr1').value = firstJuso.zipNo; // 우편번호
                        document.getElementById('bm_addr2').value = firstJuso.roadAddrPart1; // 도로명 주소
                        document.getElementById('bm_addr3').value = firstJuso.addrDetail || ''; // 상세 주소
                        document.getElementById('bm_address').value = firstJuso.zipNo + ' ' + firstJuso.roadAddrPart1 + ' ' + (firstJuso.addrDetail || ''); // 전체 주소
                    } else {
                        alert('검색 결과가 없습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('주소 검색 중 오류가 발생했습니다.');
                });
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
            background-color: #101E4E;
            color: white;
            font-weight: bold;
            margin: 0 10px;
        }

        .step-indicator .active, .inactive {
            background-color: #101E4E;
            text-align: center;
        }
        .step-indicator .active {
            background-color: #2ECC71;
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
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px #101E4E;
            backdrop-filter: blur(10px);
            border: 1px solid #101E4E;
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
            border: 1px solid #101E4E;
            border-radius: 8px;
            background-color: white;
            color: #d3d7da;
            box-sizing: border-box;
            font-size: 13px; /* 입력 필드의 폰트 크기를 줄여줌 */
            transition: border-color 0.3s ease, background-color 0.3s ease, box-shadow 0.3s ease;
        }

        input.i1:focus {
            border-color: #5dade2;
            background-color: #101E4E;
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
        button.submit-btn, button.address-btn, button#email-btn, input.address-btn {
            width: 100%;
            padding: 12px; /* 버튼의 패딩을 줄여줌 */
            background-color: #101E4E;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px; /* 버튼 폰트 크기 축소 */
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        label {
            color:#101E4E;
        }
        button.submit-btn:hover button#email-btn {
            background-color: #101E4E;
            transform: scale(1.02);
        }

        button.address-btn[type="button"] {
            background-color: #3498db;
        }

        button.address-btn[type="button"]:hover {
            background-color: #2980b9;
        }
        input.address-btn[type="button"] {
            background-color: #3498db;
        }
        input.address-btn[type="button"]:hover {
            background-color: #2980b9;
        }
        input#bm_id {
            width: 100%;
            padding: 12px;
            margin-top: 5px;
            margin-bottom: 10px; /* Add space below the ID input */
            border: 1px solid #101E4E;
            border-radius: 8px;
            background-color: white;
            color:  #101E4E;
            box-sizing: border-box;
            font-size: 13px;
            transition: border-color 0.3s ease, background-color 0.3s ease, box-shadow 0.3s ease;
        }

        input.address-btn[type="button"] {
            margin-top: 5px;
            background-color: #3498db;
        }

        input.address-btn[type="button"]:hover {
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
    <form action="${contextPath}/member/signup.do" METHOD="post" name="signupForm" onsubmit="return signupCheck();">
        <table id="signupTbl">
            <tr>
                <td colspan="2">
                    <label style="text-align: center; font-size: 16pt;">회원가입</label>
                    <input id="bm_id" name="bm_id" placeholder="ID" autofocus="autofocus"
                           autocomplete="off" maxlength="10" class="i1">
                    <input type="button" id="confirmId" name="confirmId" class="address-btn" value="ID중복체크">
                    <div id="msg"></div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
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

            <!-- 주소 검색 -->
            <tr>
                <td colspan="2">
                    <input type="text" id="searchKeyword" placeholder="주소를 입력하세요" class="i1">
                    <button class="address-btn" type="button" onclick="searchAddress()">주소 검색</button><br>

                    <!-- 주소 입력 필드 -->
                    <input type="text" id="bm_addr1" name="bm_addr1" placeholder="우편번호" readonly="readonly" class="i1">
                    <input type="text" id="bm_addr2" name="bm_addr2" placeholder="도로명 주소" readonly="readonly" class="i1">
                    <input type="text" id="bm_addr3" name="bm_addr3" placeholder="상세 주소" autocomplete="off" class="i1">
                    <input type="hidden" id="bm_address" name="bm_address"> <!-- 전체 주소 저장 -->
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
<script>
    $(document).ready(function(){
        $('#confirmId').click(function () {
            var bm_id = $('#bm_id').val(); // 입력된 ID 가져오기

            if (bm_id === "") {
                alert("ID를 입력해주세요."); // ID 입력 유무 체크
                return;
            }

            $.ajax({
                url: "${contextPath}/member/verifyId.check", // 서버의 ID 중복 체크 URL
                type: "GET",
                data: {bm_id: bm_id}, // 입력된 ID를 서버로 전달
                dataType: "json", // 서버 응답을 JSON 형태로 받음
                success: function(result) {
                    console.log("Result from server:", result);
                    console.log(result.bm_id); // 서버에서 반환된 값 확인
                    if (result.status) {
                        alert("이미 사용중인 ID입니다.");
                    } else {
                        alert("사용 가능한 ID입니다.");
                    }
                },
                error: function () {
                    alert("서버 요청에 실패했습니다."); // 서버 요청 실패 시
                }
            });
        });
    });
</script>



<script language="JavaScript">
    console.log('js연결 성공')
    let code = 0;
    document.getElementById("email-btn").addEventListener("click", () => {
        console.log('이벤트리스너 들어옴')
        const xhr = new XMLHttpRequest();
        let email = document.querySelector("#bm_mail").value;
        if (email === "" || email === null) {
            alert("이메일을 입력한 후 눌러주세요")
            return;
        }

        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

        function validateEmail(m) {
            return emailRegex.test(m);
        }

        if (validateEmail(email) === false) {
            alert("이메일을 형식에 맞추어 입력해주세요")
            return;
        }

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
                    alert('이메일을 전송했습니다');
                } else {
                    alert('요청 방식에 뭔가 문제가 있어요.');
                }
            }
        };
        xhr.open("POST", '/api/email.send', true);
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
