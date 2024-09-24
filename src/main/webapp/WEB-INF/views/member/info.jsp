git <%--
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
<body>
        <div class="mypage-container">
            <!-- 프로필 섹션 -->
            <div class="profile-section">
                <button class="delete-btn">계정 삭제</button>
            </div>

            <!-- 회원 정보 섹션 -->
            <div class="info-section">
                <h2 class="section-title">회원 정보</h2>
                <form action="${contextPath}/member.update" name="updateForm" method="post"
                      enctype="multipart/form-data" onsubmit="return updateCheck();">
                    <table class="info-table">
                        <tr>
                            <th>아이디</th>
                            <td>
                                <input value="${sessionScope.loginMember.bm_id}" name="bm_id" placeholder="ID" autocomplete="off" maxlength="10">
                            </td>
                        </tr>
                        <tr>
                            <th>비밀번호</th>
                            <td>
                                <input name="bm_pw" placeholder="PASSWORD" autocomplete="off" maxlength="10" type="password">
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
