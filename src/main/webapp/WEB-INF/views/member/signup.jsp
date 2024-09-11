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
<form action="member.signup" method="post" enctype="multipart/form-data">
    <table id="signupTbl">
        <tr>
            <td align="center" colspan="2">
                <input id="bm_id" name="bm_id" placeholder="ID" autofocus="autofocus"
                       autocomplete="off" maxlength="10" class="i1" >
                <div id="msg"></div>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input name="bm_pw" placeholder="PASSWORD" autocomplete="off"
                       maxlength="10" class="i1" type="password">
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input name="bm_pw" placeholder="PASSWORD CHECK" autocomplete="off"
                       maxlength="10" class="i1" type="password">
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input name="bm_name" placeholder="NAME" autofocus="autofocus"
                       autocomplete="off" maxlength="10" class="i1" >
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input name="bm_nickname" placeholder="NICKNAME" autofocus="autofocus"
                       autocomplete="off" maxlength="20" class="i1" >
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input id="bm_addr1" name="bm_addr1" placeholder="Zip Code" readonly="readonly"
                       class="i1" >
                <input id="bm_addr2" name="bm_addr2" placeholder="Address" readonly="readonly"
                       class="i1" >
                <input name="bm_addr3" placeholder="Detail Address" autocomplete="off"
                       class="i1" >
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input name="bm_phoneNum" placeholder="phoneNum" autofocus="autofocus"
                       autocomplete="off" maxlength="20" class="i1" >
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input name="bm_birthday" placeholder="birthday" autofocus="autofocus"
                       autocomplete="off" maxlength="20" class="i1" >
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <input name="bm_mail" placeholder="mail" autofocus="autofocus"
                       autocomplete="off" maxlength="20" class="i1" >
            </td>
        </tr>
        <tr>
            <td align="center" colspan="2">
                <button>Sign Up</button>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
