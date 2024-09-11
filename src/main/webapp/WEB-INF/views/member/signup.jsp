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
    <meta charset="UTF-8">
    <title>회원 가입</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        #signupContainer {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 300px;
        }

        #signupTbl {
            width: 100%;
            border-collapse: collapse;
        }

        #signupTbl td {
            padding: 10px;
        }

        #signupTbl input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-top: 5px;
        }

        #signupTbl button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        #signupTbl button:hover {
            background-color: #45a049;
        }

        #msg {
            color: red;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<div id="signupContainer">
    <form action="member.signup">
        <table id="signupTbl">
            <tr>
                <td colspan="2">
                    <label for="bm_id">ID</label>
                    <input id="bm_id" name="bm_id" placeholder="ID" autofocus="autofocus"
                           autocomplete="off" maxlength="10" class="i1">
                    <div id="msg"></div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
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
            <tr>
                <td colspan="2">
                    <input id="bm_addr1" name="bm_addr1" placeholder="Zip Code" readonly="readonly" class="i1">
                    <input id="bm_addr2" name="bm_addr2" placeholder="Address" readonly="readonly" class="i1">
                    <input name="bm_addr3" placeholder="Detail Address" autocomplete="off" class="i1">
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
                    <input name="bm_mail" placeholder="Email" autocomplete="off" maxlength="20" class="i1">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <button type="submit">Sign Up</button>
                </td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>
