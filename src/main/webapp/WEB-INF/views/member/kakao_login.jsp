<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 19.
  Time: 오후 4:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<a href="javascript:kakaoLogin();">"></a>
  <script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
  <script>
    window.Kakao.init("412e7727ffd0b8900060854044814879");

    function kakaoLogin() {
      window.Kakao.Auth.login({
        scope: 'profile_nickname, profile_image',
        success: function (authObj) {
          console.log(authObj);
          Window.Kakao.API.request({
              url:'/v2/user/me',
              success: res => {
                  const kakao_account = res.kakao_account;
              }
          })
        }
      });
    }

  </script>
</body>
</html>
