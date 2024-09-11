<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form action="member.login" method="post">
    <table id="loginTbl">
        <tr>
            <td align="center">
                LOGIN
            </td>
        </tr>
        <tr>
            <td align="center">
                <input name="bm_id" placeholder="ID" autocomplete="off" maxlength="10"
                       autofocus="autofocus" class="i1">
            </td>
        </tr>
        <tr>
            <td align="center">
                <input name="bm_pw" placeholder="PASSWORD" autocomplete="off" maxlength="10" type="password" class="i1">
            </td>
        </tr>
        <tr>
            <td align="center">
                <button>로그인</button>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
