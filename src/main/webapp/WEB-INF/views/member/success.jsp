<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 11:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<table id="loginSuccessTbl">
    <tr>

        <td>${sessionScope.loginMember.bm_id }</td>
    </tr>
    <tr>
        <td align="center" colspan="2">${sessionScope.loginMember.bm_name } 님</td>
    </tr>
    <tr>
        <td align="center" colspan="2">어서오세요</td>
    </tr>
    <tr>
        <td align="center" colspan="2">
            <button onclick="memberInfoGo();">정보</button>
            <button onclick="logout();">로그아웃</button>
        </td>
    </tr>
</table>
</body>
</html>
