<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 11.
  Time: 오전 10:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        background-color: #F5F6FA;
        margin: 0;
        padding: 0;
    }

    .mypage-container {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding: 20px;
        max-width: 1200px;
        margin: 0 auto;
    }

    /* 프로필 섹션 */
    .profile-section {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        text-align: center;
        width: 300px;
        margin-right: 20px;
    }


    .edit-profile-btn {
        padding: 10px 20px;
        background-color: #2ECC71;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 1rem;
        cursor: pointer;
    }

    .edit-profile-btn:hover {
        background-color: #27AE60;
    }

    /* 정보 섹션 */
    .info-section {
        flex: 1;
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    .section-title {
        font-size: 1.5rem;
        color: #101E4E;
        border-bottom: 2px solid #E9F0FA;
        padding-bottom: 10px;
        margin-bottom: 20px;
    }

    .info-table {
        width: 100%;
        border-collapse: collapse;
    }

    .info-table th, .info-table td {
        padding: 15px;
        text-align: left;
        border-bottom: 1px solid #E9F0FA;
    }

    .info-table th {
        color: #737373;
        font-weight: normal;
    }

    .info-table td {
        color: #101E4E;
    }

    .info-table input {
        width: 100%;
        padding: 10px;
        border: 1px solid #D1D5DB;
        border-radius: 5px;
        font-size: 1rem;
        box-sizing: border-box;
    }

    .delete-btn {
        padding: 10px 20px;
        background-color: red;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 1rem;
        cursor: pointer;
    }

    .delete-btn:hover {
        background-color: #C0392B;
    }
</style>
<body>
<div class="mypage-container">
    <!-- 프로필 섹션 -->
    <form action="${contextPath}/member/delete" name="deleteForm" method="get"
          enctype="multipart/form-data" onsubmit="return deleteCheck();">
    <div class="profile-section">
        <button class="delete-btn">계정 삭제</button>
    </div>
    </form>
<script>
    function deleteCheck() {
        // 삭제 확인 메시지 표시
        const userInput = prompt("계정을 삭제하시겠습니까? 삭제하려면 'y' 또는 'Y'를 입력하세요.");

        // 사용자가 'y' 또는 'Y'를 입력하면 폼 제출
        if (userInput === 'y' || userInput === 'Y') {
            alert("계정이 삭제됩니다.");
            return true; // 폼 제출 허용
        } else {
            alert("계정 삭제가 취소되었습니다.");
            return false; // 폼 제출 차단
        }
    }
</script>
    <!-- 회원 정보 섹션 -->
    <div class="info-section">
        <h2 class="section-title">회원 정보</h2>
        <form action="${contextPath}/member/update" name="updateForm" method="post"
              enctype="multipart/form-data" onsubmit="return updateCheck();">
            <table class="info-table">
                <tr>
                    <th>아이디</th>
                    <td>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <input value="${sessionScope.loginMember.bm_id}" name="bm_id" placeholder="ID" autocomplete="off" maxlength="10" readonly>
                    </td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td>
                        <input value="${sessionScope.loginMember.bm_pw}" name="bm_pw" placeholder="PASSWORD" autocomplete="off" maxlength="10" type="password">
                    </td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td>
                        <input value="${sessionScope.loginMember.bm_nickname}" name="bm_nickname" placeholder="닉네임" autocomplete="off" maxlength="10">
                    </td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td>
                        <input value="${sessionScope.loginMember.bm_phoneNum}" name="bm_phoneNum" placeholder="전화번호" autocomplete="off" maxlength="11">
                    </td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td>
                        <input value="${sessionScope.loginMember.bm_address}" name="bm_address" placeholder="주소" autocomplete="off" maxlength="100">
                    </td>
                </tr>
                <tr>
                    <th>생년월일</th>
                    <td>
                        <input value="${sessionScope.loginMember.bm_birthday}" name="bm_birthday" placeholder="생년월일" autocomplete="off" maxlength="10">
                    </td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td>
                        <input value="${sessionScope.loginMember.bm_mail}" name="bm_mail" placeholder="이메일" autocomplete="off" maxlength="50">
                    </td>
                </tr>
            </table>
            <button class="edit-profile-btn">프로필 수정</button>
        </form>
    </div>
</div>
</body>
</html>
