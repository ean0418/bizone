<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>비밀번호 변경</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Helvetica Neue', Arial, sans-serif;
            color: #2c3e50;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
        }

        .container {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 450px;
            width: 100%;
            text-align: center;
            margin: 0 auto;
        }

        h3 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 25px;
            color: #34495e;
        }

        input[type="password"], button {
            width: 100%;
            padding: 12px;
            margin: 15px 0;
            border-radius: 8px;
            border: 1px solid #dcdcdc;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }

        input[type="password"] {
            background-color: #f9f9f9;
            color: #34495e;
        }

        input[type="password"]:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.4);
        }

        button {
            background-color: #2980b9;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 1.2rem;
            padding: 12px;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #1f639a;
        }

        #pwMessage {
            color: #e74c3c;
            font-size: 0.9rem;
            margin-top: -10px;
            margin-bottom: 10px;
        }

        .alert-message {
            color: #e74c3c;
            background-color: #f8d7da;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #f5c6cb;
            margin-top: 20px;
        }

        .success-message {
            color: #2ecc71;
            background-color: #d4edda;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #c3e6cb;
            margin-top: 20px;
        }
    </style>

    <script language="JavaScript">
        function checkPwBox() {
            let pw = document.querySelector("#bm_pw").value;
            if (pw === null || pw === "" || pw.length <= 4) {
                alert('비밀번호는 최소 4자리 이상 입력해주세요');
                return false;
            }
            return true;
        }

        window.addEventListener('load', () => {
            const pwBox = document.querySelector("#bm_pw");

            const xhr = new XMLHttpRequest();
            let currentPW;
            let reqJson = {};
            reqJson.bm_id = `${sessionScope.biz_mem.bm_id}`;

            pwBox.addEventListener('blur', () => {
                document.querySelector('#changePwForm').disabled = false;
                xhr.onreadystatechange = () => {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            var result = xhr.response;
                            currentPW = result.bm_pw;
                            if (currentPW === pwBox.value) {
                                document.querySelector('#pwMessage').textContent = '현재 사용중인 비밀번호로는 변경 불가합니다';
                                document.querySelector('#changePwForm').disabled = "disabled";
                            }
                        } else {
                            alert('요청 방식이 잘못되었습니다.');
                        }
                    }
                };
                xhr.open('POST', '/api/getCurrentPW.do', true);
                xhr.responseType = "json";
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.send(JSON.stringify(reqJson));
            });
        });
    </script>
</head>
<body>
<div class="container">
    <c:choose>
        <c:when test="${status}">
            <form action="${contextPath}/member/changePW.do" onsubmit="return checkPwBox();" method="post">
                <h3>비밀번호 변경</h3>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <input id="bm_pw" name="bm_pw" type="password" placeholder="비밀번호">
                <div id="pwMessage"></div>
                <button id="changePwForm" type="submit">변경하기</button>
            </form>
        </c:when>
        <c:otherwise>
            <c:if test="${message == '토큰 기한이 만료되었습니다'}">
                <div class="alert-message">${message}</div>
                <h4>비밀번호 변경 페이지에서 다시 요청해주세요</h4>
            </c:if>
            <c:if test="${message == '잘못된 접근입니다'}">
                <div class="alert-message">URL 링크가 잘못된 형식입니다.</div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
