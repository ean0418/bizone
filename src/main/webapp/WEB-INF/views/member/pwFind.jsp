<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>비밀번호 찾기</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f7f9fc;
            font-family: 'Helvetica Neue', Arial, sans-serif;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .findForm {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
            justify-content: center;
            margin-left: 750px;
            margin-top: 200px;
        }

        h3 {
            font-size: 1.8rem;
            color: #34495e;
            margin-bottom: 20px;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 6px;
            border: 1px solid #dcdcdc;
            background-color: #f9f9f9;
            font-size: 1rem;
        }

        button {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            font-size: 1rem;
            transition: background-color 0.3s ease;
            width: 100%;
        }

        button:hover {
            background-color: #2980b9;
        }

        #idCheck {
            margin-top: 20px;
            font-size: 1rem;
        }

        .alert {
            font-size: 0.9rem;
            padding: 10px;
            margin-top: 20px;
            border-radius: 6px;
        }

        .alert-success {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
        }

        .alert-danger {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
    </style>
    <script language="JavaScript">
        window.addEventListener('load', () => {
            const idBox = document.querySelector("#bm_id");
            const idBtn = document.querySelector("#idCheckBtn");
            idBtn.addEventListener("click", () => {
                const xhr = new XMLHttpRequest();
                const idChk = document.querySelector("#idCheck");
                const reqJson = {};
                reqJson.bm_id = idBox.value;
                xhr.onreadystatechange = () => {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            var result = xhr.response;
                            const founded = result.founded;
                            if (founded) {
                                idChk.innerHTML = `
                                <div class="alert alert-success">ID가 존재합니다!<br/>
                                회원가입시 입력한 이메일로 비밀번호 변경 링크를 보냈습니다!</div>`;
                            } else {
                                idChk.innerHTML = `
                                <div class="alert alert-danger">존재하지 않는 ID입니다!<br/>
                                회원가입 하시겠습니까? <a href="${contextPath}/member/step1">회원가입 하기</a></div>`;
                            }
                        } else {
                            alert('요청 처리 중 오류가 발생했습니다.');
                        }
                    }
                };
                xhr.open("POST", '/api/idExist.do', true);
                xhr.responseType = "json";
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.send(JSON.stringify(reqJson));
            });
        });
    </script>
</head>
<body>
<div class="findForm">
    <h3>비밀번호 찾기</h3>
    <input name="bm_id" id="bm_id" placeholder="ID를 입력하세요">
    <button type="button" id="idCheckBtn">ID 확인</button>
    <div id="idCheck"></div>
</div>
</body>
</html>
