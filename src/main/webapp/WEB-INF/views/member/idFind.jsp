<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 24.
  Time: 오후 2:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>Title</title>
    <script language="JavaScript">
        window.addEventListener('load', () => {
            const idFind = document.querySelector("#idFindBtn")
            const codeInput = document.querySelector("#codeInput")
            const xhr = new XMLHttpRequest()
            const csrfToken = document.querySelector("meta[name='_csrf']").getAttribute("content")
            const csrfHeader = document.querySelector("meta[name='_csrf_header']").getAttribute("content")

            let code = 0
            let id;
            idFind.addEventListener("click", () => {
                const email = document.querySelector("#bm_mail").value
                if (email === null || email === "") {
                    alert('이메일을 입력해주세요')
                    return;
                }

                const reqJson = {};
                reqJson.email = email


                xhr.onreadystatechange = () => {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            var result = xhr.response;
                            code = result.idCode;
                            id = result.id;
                            codeInput.disabled = false;
                            alert('이메일을 전송했습니다');
                        } else {
                            alert('요청 방식에 뭔가 문제가 있어요.');
                        }
                    }
                };
                xhr.open("POST", '/idFind.send', true);
                xhr.responseType = "json";
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.setRequestHeader(csrfHeader, csrfToken);
                xhr.send(JSON.stringify(reqJson));
            })

            codeInput.addEventListener('blur', (e) => {
                const foundId = document.querySelector('#foundId')
                console.log(id)
                console.log(code)
                if (code == codeInput.value) {
                    foundId.textContent = id
                } else {
                    foundId.textContent = "잘못된 코드번호입니다"
                }
            })

        })
    </script>
    <style>
        .findForm {
            width: 400px;
            margin: 50px auto 0;
            padding: 30px;
            border-radius: 20px;
            border: #101e4e solid medium;
            font-family: inherit;
            font-size: inherit;
            text-align: center;
        }
        #idFindBtn {
            display: block;
            width: 75%;
            height: 40px;
            outline: none;
            border: lawngreen solid 1px;
            background-color: forestgreen;
        }
        #idFindBtn:hover {
            border: forestgreen solid 1px;
            background-color: darkgreen;
        }
    </style>
</head>
<body>
<div class="findForm">
    <h3>ID 찾기</h3>
    <input name="bm_mail" id="bm_mail" placeholder="E-Mail">
    <button id="idFindBtn">ID 찾기</button>
    <input id="codeInput" disabled="disabled">
    <div id="foundId"></div>
</div>
</body>
</html>
