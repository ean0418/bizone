<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 12.
  Time: 오전 11:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>도로명주소 검색</title>
  <%
    String inputYn = request.getParameter("inputYn");
    String zipNo = request.getParameter("zipNo");
    String roadAddrPart1 = request.getParameter("roadAddrPart1");
    String addrDetail = request.getParameter("addrDetail");
  %>
  <script language="javascript">
    function init() {
      var url = location.href;
      var confmKey = "devU01TX0FVVEgyMDI0MDkxMjExMjgxNTExNTA4NDE="; // 승인키
      var resultType = "4"; // 도로명+지번+상세건물명 결과 화면 출력 유형
      var inputYn = "<%=inputYn%>";

      // 부모 창에서 CSRF 토큰 가져오기
      var csrfToken = window.opener.document.querySelector('meta[name="_csrf"]').getAttribute('content');
      var csrfHeader = window.opener.document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

      // CSRF 토큰을 hidden input 필드로 추가
      var csrfInput = document.createElement("input");
      csrfInput.type = "hidden";
      csrfInput.name = "_csrf";
      csrfInput.value = csrfToken;
      document.getElementById("form").appendChild(csrfInput);

      if (inputYn != "Y") {
        document.getElementById("confmKey").value = confmKey;
        document.getElementById("returnUrl").value = url;
        document.getElementById("resultType").value = resultType;
        document.getElementById("form").action = "https://business.juso.go.kr/addrlink/addrLinkUrl.do";
        document.getElementById("form").submit();
      } else {
        // 부모 창으로 결과 전달
        opener.jusoCallBack("<%=zipNo%>", "<%=roadAddrPart1%>", "<%=addrDetail%>");
        window.close();
      }
    }
  </script>
</head>
<body onload="init();">
<form id="form" name="form" method="get">
  <input type="hidden" id="confmKey" name="confmKey" value=""/>
  <input type="hidden" id="returnUrl" name="returnUrl" value=""/>
  <input type="hidden" id="resultType" name="resultType" value=""/>
</form>
</body>
</html>