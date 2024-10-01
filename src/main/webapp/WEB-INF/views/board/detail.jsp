<%--
  Created by IntelliJ IDEA.
  User: yunjeong
  Date: 24. 9. 18.
  Time: 오후 10:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../board/style.jsp"%>
<html>
<head>
    <title>게시글 상세조회</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
            background-color: #ffffff; /* 배경색 흰색 */
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px 20px;
            background-color: #ffffff; /* 컨테이너 배경 흰색 */
            border: 1px solid #e3e3e3;
            border-radius: 5px;
        }

        .page-title {
            font-size: 1.5em;
            font-weight: 600;
            color: #444;
            border-bottom: 2px solid #e3e3e3;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .breadcrumb {
            font-size: 1em;
            color: #666;
            background-color: #ffffff; /* 네비게이션 바 배경 화이트 */
            padding-bottom: 5px;
            /*border-bottom: 1px solid #e3e3e3;*/
            position: fixed; /* 위치를 절대값으로 설정 */
            top: 10px; /* 상단 여백 조정 */
            left: 5px; /* 왼쪽 여백 조정 */
            width: auto; /* 기본 넓이 설정 */
        }

        .breadcrumb span {
            display: inline-block;
            margin-right: 10px;
            font-weight: bold;
        }

        .breadcrumb span.separator {
            margin-right: 5px;
            color: #999;
            font-weight: bold;
        }

        .board-info {
            display: flex;
            justify-content: space-between;
            align-items: center; /* 수직 가운데 정렬 */
            font-size: 0.9em;
            margin-bottom: 15px;
            padding-bottom: 10px;
            /*padding: 10px 0;*/
            padding-left: 15px;
            padding-right: 15px;
            border-bottom: 1px solid #e9ecef;
            color: #666;
        }

        .board-info div {
            display: flex;
            align-items: center; /* 각 요소의 텍스트를 가운데 정렬 */
            height: 100%;
        }

        .board-title {
            font-size: 1.8em;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 10px;
            padding-left: 15px;
            border-bottom: 1px solid #e3e3e3;
        }

        .board-content {
            min-height: 150px; /* 본문 내용 고정 높이 */
            max-height: 500px; /* 본문 내용 최대 높이 */
            margin: 20px 0;
            padding: 15px;
            border: none;
            border-radius: 5px;
            overflow-y: auto;
        }

        .btn-container {
            display: flex;
            justify-content: flex-start;
            gap: 10px;
            margin-top: 20px; /* 본문과 버튼 간격 */
        }

        .btn {
            padding: 8px 15px; /* 버튼 크기 줄이기 */
            border: 1px solid #ced4da;
            background-color: #ffffff;
            color: #495057;
            cursor: pointer;
            border-radius: 4px;
            transition: border 0.3s;
            font-weight: bold;
        }

        .btn:hover {
            border: 1px solid #495057; /* hover 시 테두리만 굵게 */
            background-color: #ffffff; /* 배경색 변화 없음 */
            color: #495057;
        }

        .btn-primary {
            border: 1px solid #ced4da;
            color: #495057;
        }

        .comment-section {
            margin-top: 30px;
            padding: 20px;
            background-color: #ffffff;
            border: 1px solid #e3e3e3;
            border-radius: 5px;
        }

        .comment-form {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 20px;
        }

        .comment-form textarea {
            width: 80%; /* 댓글 입력창 너비 */
            height: 40px;
            resize: none;
            border: 1px solid #e3e3e3;
            border-radius: 5px;
            padding: 10px;
        }

        .comment-form button {
            padding: 10px 15px;
            border: 1px solid #ced4da;
            background-color: #ffffff;
            color: #495057;
            cursor: pointer;
            border-radius: 4px;
            font-weight: bold;
        }

        .comment-form button:hover {
            border: 1px solid #495057;
        }

        .comment-item {
            margin-bottom: 15px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #e3e3e3;
            position: relative;
        }

        .comment-item p {
            margin: 0;
            color: #495057;
            display: inline-block;
            width: 80%;
        }

        .comment-item .comment-text {
            flex: 1;
        }

        .comment-item .btn-container {
            position: absolute; /* 버튼 컨테이너를 comment-item 내부의 절대 위치로 설정 */
            right: 10px; /* 오른쪽 끝에 배치 */
            top: 50%; /* 수직 가운데 정렬 */
            transform: translateY(-50%);
        }

        .comment-item .btn {
            padding: 5px 10px;
            font-size: 0.85em;
            border: 1px solid #ced4da;
        }

        .comment-item .btn:hover {
            border: 1px solid #495057; /* hover 시 테두리만 굵게 */
        }
    </style>
    <script type="text/javascript">
        // 댓글 수정 모드로 전환하는 함수
        function editComment(bc_no) {
            const bb_no = ${board.bb_no}; // 게시글 번호 가져오기
            location.href = '${contextPath}/comment/edit?bc_no=' + bc_no + '&bb_no=' + bb_no;
        }

        // 수정 모드 취소 함수
        function cancelEdit() {
            location.href = '${contextPath}/board/detail?bb_no=' + ${board.bb_no};
        }
    </script>
</head>
<body>
<div class="container">
    <!-- 상단 네비게이션 영역 추가 -->
    <div class="breadcrumb" style="position: relative; top: 10px; left: 30px; font-size: 16px; color: #6c757d; margin-bottom: 20px;">
        <span>게시판</span>
        <span class="separator">></span>
        <span>게시글 상세조회</span>
    </div>

    <div class="board-title">${board.bb_title}</div> <!-- 제목을 굵게 표시 -->
    <div class="board-info">
        <div><strong>작성자: </strong> ${board.bb_bm_nickname}</div>
        <div>
            <strong>조회수: </strong> ${board.bb_readCount} &nbsp;|&nbsp;
            <strong>작성일: </strong> <fmt:formatDate value="${board.bb_date}" pattern="yyyy-MM-dd HH:mm"/>
        </div>
    </div>
    <div class="board-content">
        ${board.bb_content}
    </div>
    <div class="btn-container">
        <a href="${contextPath}/board/list" class="btn">목록보기</a>
        <c:if test="${sessionScope.loginMember.bm_nickname == board.bb_bm_nickname}">
            <a href="${contextPath}/board/update.go?bb_no=${board.bb_no}" class="btn">수정</a>
            <form action="${contextPath}/board/delete.go" method="post" style="display:inline;">
                <input type="hidden" name="bb_no" value="${board.bb_no}">
                <button type="submit" class="btn" onclick="return confirm('게시글을 삭제하시겠습니까?')">삭제</button>
            </form>
        </c:if>
    </div>

    <!-- 댓글 목록 섹션 -->
    <div class="comment-section">
        <h4>댓글</h4>

        <!-- 댓글 작성 폼 -->
        <form class="comment-form" action="${contextPath}/comment/insert" method="post">
            <input type="hidden" name="bc_bb_no" value="${board.bb_no}">
            <c:choose>
                <c:when test="${sessionScope.loginMember != null}">
                    <textarea name="bc_content" placeholder="댓글을 입력하세요." required></textarea>
                    <button type="submit" class="btn">댓글 작성</button>
                </c:when>
                <c:otherwise>
                    <textarea name="bc_content" placeholder="로그인 후 이용 가능합니다." disabled></textarea>
                    <button type="button" class="btn" onclick="alert('로그인 후 이용 가능합니다.');">댓글 작성</button>
                </c:otherwise>
            </c:choose>
        </form>

        <!-- 댓글 목록 출력 -->
        <c:choose>
            <c:when test="${not empty commentList}">
                <c:forEach var="comment" items="${commentList}">
                    <div class="comment-item">
                        <div class="comment-text">
                            <p><strong>${comment.bc_bm_nickname}</strong>
                                <fmt:formatDate value="${comment.bc_createdDate}" pattern="yyyy-MM-dd HH:mm"/>
                            </p>

                            <!-- 댓글 수정 모드인지 아닌지 구분 -->
                            <c:choose>
                                <c:when test="${sessionScope.editCommentId != null && sessionScope.editCommentId == comment.bc_no}">
                                    <!-- 수정 모드일 때 -->
                                    <form action="${contextPath}/comment/update" method="post" class="comment-form">
                                        <input type="hidden" name="bc_no" value="${comment.bc_no}"> <!-- 댓글 번호 -->
                                        <input type="hidden" name="bc_bb_no" value="${board.bb_no}"> <!-- 게시글 번호 -->
                                        <textarea name="bc_content" required>${comment.bc_content}</textarea>
                                        <button type="submit" class="btn">저장</button>
                                        <button type="button" class="btn btn-secondary" onclick="cancelEdit()">취소</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <!-- 기본 모드 -->
                                    <p>${comment.bc_content}</p>
                                    <c:if test="${sessionScope.loginMember.bm_nickname == comment.bc_bm_nickname}">
                                        <div class="btn-container">
                                            <button class="btn" onclick="editComment(${comment.bc_no})">수정</button>
                                            <form action="${contextPath}/comment/delete" method="post" style="display:inline;">
                                                <input type="hidden" name="bc_no" value="${comment.bc_no}">
                                                <input type="hidden" name="bc_bb_no" value="${board.bb_no}">
                                                <button type="submit" class="btn" onclick="return confirm('댓글을 삭제하시겠습니까?')">삭제</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>댓글이 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
