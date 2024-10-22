<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>ID 찾기</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script language="JavaScript">
        let id = "";
        window.addEventListener('load', () => {
            const idFind = document.querySelector("#idFindBtn");
            const codeInput = document.querySelector("#codeInput");
            const xhr = new XMLHttpRequest();
            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content");

            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content");
            let code = 0;
            idFind.addEventListener("click", () => {
                const email = document.querySelector("#bm_mail").value;
                if (email === null || email === "") {
                    alert('이메일을 입력해주세요');
                    return;
                }

                const reqJson = {};
                reqJson.email = email;

                xhr.onreadystatechange = () => {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            var result = xhr.response;
                            code = result.idCode;
                            id = result.id;
                            codeInput.disabled = false;
                            alert('이메일을 전송했습니다');
                        } else {
                            alert('요청 처리 중 오류가 발생했습니다.');
                        }
                    }
                };
                xhr.open("POST", '/idFind.send', true);
                xhr.responseType = "json";
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.setRequestHeader(csrfHeader, csrfToken);
                xhr.send(JSON.stringify(reqJson));
            });

            codeInput.addEventListener('change', (e) => {
                const foundId = document.querySelector('#foundId');
                if (code == codeInput.value) {
                    foundId.textContent = `ID: ` + id;
                    foundId.classList.remove('text-danger');
                    foundId.classList.add('text-success');
                } else {
                    foundId.textContent = "잘못된 코드번호입니다.";
                    foundId.classList.remove('text-success');
                    foundId.classList.add('text-danger');
                }
            });
        });
    </script>
    <style>
        body {
            background-color: #f4f7f9;
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .findForm {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
            margin-left: 750px;
            margin-top: 200px;
        }

        h3 {
            font-size: 1.75rem;
            color: #343a40;
            margin-bottom: 20px;
        }

        input[type="email"], input[type="text"], button {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
            border: 1px solid #ced4da;
            font-size: 1rem;
        }

        input[type="email"], input[type="text"] {
            background-color: #f8f9fa;
        }

        input:disabled {
            background-color: #e9ecef;
        }

        button {
            background-color: #28a745;
            color: white;
            border: none;
            font-size: 1rem;
            transition: background-color 0.3s ease;
            cursor: pointer;
        }

        button:hover {
            background-color: #218838;
        }

        #foundId {
            margin-top: 20px;
            font-size: 1rem;
        }

        .text-success {
            color: #28a745;
        }

        .text-danger {
            color: #dc3545;
        }
    </style>
</head>
<body>
<div class="findForm">
    <h3>ID 찾기</h3>
    <input type="email" name="bm_mail" id="bm_mail" placeholder="E-Mail" class="form-control">
    <button id="idFindBtn" class="btn btn-success">ID 찾기</button>
    <input type="text" id="codeInput" class="form-control" placeholder="인증 코드" disabled="disabled">
    <div id="foundId"></div>
</div>
</body>
</html>
