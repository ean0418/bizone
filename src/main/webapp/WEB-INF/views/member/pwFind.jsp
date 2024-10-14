<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 25.
  Time: 오전 9:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script language="JavaScript">
        window.addEventListener('load', () => {
            const idBox = document.querySelector("#bm_id")
            const idBtn = document.querySelector("#idCheckBtn")
            idBtn.addEventListener("click", () => {
                const xhr = new XMLHttpRequest()
                const idChk = document.querySelector("#idCheck")
                const reqJson = {};
                reqJson.bm_id = idBox.value;
                xhr.onreadystatechange = () => {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            console.log('여기는 status === 200')
                            var result = xhr.response;
                            founded = result.founded;
                            if (founded) {
                                console.log('여기는 founded')
                                idChk.innerHTML = `
                                <div>ID가 존재합니다!</div>
                                <div>회원가입시 입력한 이메일로 비밀번호 변경 링크를 보냈습니다!</div>`
                            } else {
                                idChk.innerHTML = `
                                <div>존재하지 않는 ID입니다!</div>
                                <div>회원가입 하시겠습니까?<a href="${contextPath}/member.step1">회원가입 하기</a></div>`
                            }
                        } else {
                            alert('요청 방식에 뭔가 문제가 있어요.');
                        }
                    }
                }
                xhr.open("POST", '/api/idExist.do', true);
                xhr.responseType = "json";
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.send(JSON.stringify(reqJson));
            })
        })
    </script>
</head>
<body>
<div class="findForm">
    <h3>비밀번호 찾기</h3>
    <input name="bm_id" id="bm_id" placeholder="ID">
    <button type="button" id="idCheckBtn">ID 존재여부 확인</button>
    <div id="idCheck"></div>
</div>
</body>
</html>
