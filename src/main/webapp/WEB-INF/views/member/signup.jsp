<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 10:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script language="javascript">
        function goPopup() {
            // 팝업 창 열기 (주소 검색 팝업 페이지로 연결)
            var pop = window.open("/pop/jusoPopup.jsp", "pop", "width=570,height=420, scrollbars=yes, resizable=yes");
        }

        // 팝업 창에서 반환된 주소 정보를 메인 폼 필드에 채우는 함수
        function jusoCallBack(zipNo, roadAddrPart1, addrDetail) {
            document.getElementById('bm_addr1').value = zipNo;          // 우편번호
            document.getElementById('bm_addr2').value = roadAddrPart1;   // 도로명 주소
            document.getElementById('bm_addr3').value = addrDetail;     // 상세 주소
            document.getElementById('bm_address').value = zipNo + ' ' + roadFullAddr + ' ' + addrDetail; // 전체 주소
        }


    </script>
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
    <form action="member.signup" METHOD="post" name="signupForm"
          onsubmit="return signupCheck();">
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
                    <!-- 주소 검색 버튼 -->
                    <button type="button" onclick="goPopup()">주소 검색</button><br>

                    <!-- 주소 입력 필드 -->

                    <input type="text" id="bm_addr1" name="bm_addr1" placeholder="Zip Code" readonly="readonly" class="i1">
                    <input type="text" id="bm_addr2" name="bm_addr2" placeholder="Address" readonly="readonly" class="i1">
                    <input type="text" id="bm_addr3" name="bm_addr3" placeholder="Detail Address" autocomplete="off" class="i1">
                    <input type="hidden" id="bm_address" name="bm_address">
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
