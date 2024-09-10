<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <table id="header">
        <tr>
            <td>
                <jsp:include page="header.jsp" />
            </td>
        </tr>
    </table>
    <table id="content">
        <tr>
            <td>
<%--                <jsp:include page="${pageContext.request.contextPath}" />--%>
            </td>
        </tr>
    </table>
    <table id="footer">
        <tr>
            <td>
                <jsp:include page="footer.jsp" />
            </td>
        </tr>
    </table>
</body>
</html>
