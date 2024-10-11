<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 25.
  Time: 오전 11:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script language="JavaScript">
        function checkPwBox() {
            let pw = document.querySelector("#bm_pw").value
            if (pw === null || pw === "" || pw.length <= 4) {
                alert('비밀번호는 최소 4자리 이상 입력해주세요')
                return false;
            }
            return true;
        }
        window.addEventListener('load', () => {
            const pwBox = document.querySelector("#bm_pw")


            const xhr = new XMLHttpRequest();
            let currentPW;
            let reqJson = {}
            reqJson.bm_id = `${sessionScope.biz_mem.bm_id}`;

            pwBox.addEventListener('blur', () => {
                document.querySelector('#changePwForm').disabled = false
                console.log(document.querySelector('#changePwForm').getAttribute("disabled"))
                xhr.onreadystatechange = () => {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            var result = xhr.response
                            currentPW = result.bm_pw;
                            console.log(currentPW)
                            console.log(pwBox.value)
                            if (currentPW === pwBox.value) {
                                document.querySelector('#pwMessage').textContent = '현재 사용중인 비밀번호로는 변경 불가합니다'
                                document.querySelector('#changePwForm').disabled = "disabled"
                            }
                        } else {
                            alert('요청 방식이 잘못되었어요')
                        }
                    }
                }
                xhr.open('POST', '/getCurrentPW.do', true)
                xhr.responseType = "json"
                xhr.setRequestHeader('Content-Type', 'application/json')
                xhr.send(JSON.stringify(reqJson))
            })
        })

    </script>
</head>
<body>
<div>
    <c:choose>
        <c:when test="${status}">
            <form action="${contextPath}/member/member/changePW.do" onsubmit="return checkPwBox();" method="post">
                <h3>비밀번호 변경</h3>
                <input id="bm_pw" name="bm_pw" placeholder="비밀번호">
                <div id="pwMessage"></div>
                <button id="changePwForm">변경하기</button>
            </form>
        </c:when>
        <c:otherwise>
            <c:if test="${message == '토큰 기한이 만료되었습니다'}">
                <h3>${message}</h3>
                <h4>비밀번호 변경 페이지에서 다시 요청해주세요</h4>
            </c:if>
            <c:if test="${message == '잘못된 접근입니다'}">
                <h4>URL 링크가 잘못된 형식입니다.</h4>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
