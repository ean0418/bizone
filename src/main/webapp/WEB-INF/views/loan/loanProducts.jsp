<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>대출상품 추천 시스템</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <style>
    /* 네비게이션 바 스타일 */
    .navbar { background-color: #007bff; color: white; padding: 1rem; display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
    .navbar-brand { font-size: 1.5rem; font-weight: bold; color: white; }
    .nav-link { color: white; margin-right: 15px; text-decoration: none; font-size: 1.1rem; }
    .nav-link:hover { text-decoration: underline; }

    /* 조건 선택 버튼 스타일 */
    .condition-button { display: block; margin: 0 auto; background-color: #007bff; color: white; border: none; padding: 15px 30px; border-radius: 30px; font-size: 1.2rem; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); cursor: pointer; transition: all 0.3s ease; }
    .condition-button:hover { background-color: #0056b3; transform: translateY(-3px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); }

    /* 대출상품 결과 카드 스타일 */
    .loan-card { border: 1px solid #ddd; border-radius: 12px; padding: 1.5rem; box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1); margin: 1rem; transition: transform 0.3s, box-shadow 0.3s; background-color: white; }
    .loan-card:hover { transform: translateY(-5px); box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); }
    .loan-card h3 { font-size: 1.2rem; margin-bottom: 1rem; color: #007bff; font-weight: bold; }
    .loan-card p { margin: 0.5rem 0; font-size: 1rem; color: #333; line-height: 1.5; }
    .loan-card .btn-favorite { background-color: transparent; border: none; color: #f44336; font-size: 1.5rem; cursor: pointer; transition: color 0.3s; }
    .loan-card .btn-favorite:hover { color: #d32f2f; }
  </style>
</head>
<body>
<nav class="navbar">
  <div class="navbar-brand">대출상품 추천 시스템</div>
  <div>
    <a class="nav-link" href="/home">홈</a>
    <a class="nav-link" href="/about">소개</a>
    <a class="nav-link" href="/contact">문의</a>
  </div>
</nav>

<!-- 대출상품 조건 선택 모달창 버튼 -->
<div class="container text-center">
  <button class="condition-button" data-toggle="modal" data-target="#conditionModal">대출상품 조건 선택</button>
</div>

<!-- 대출상품 조건 선택 모달창 -->
<div class="modal fade" id="conditionModal" tabindex="-1" role="dialog" aria-labelledby="conditionModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="conditionModalLabel">대출상품 조건 선택</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form id="conditionForm">
          <div class="form-group">
            <label for="irtCtg">금리구분:</label>
            <select id="irtCtg" name="IRT_CTG" class="form-control">
              <option value="">선택</option>
              <option value="fixed">고정금리</option>
              <option value="variable">변동금리</option>
            </select>
          </div>
          <div class="form-group">
            <label for="usge">용도:</label>
            <select id="usge" name="USGE" class="form-control">
              <option value="">선택</option>
              <option value="personal">개인 용도</option>
              <option value="business">사업 용도</option>
            </select>
          </div>
          <div class="form-group">
            <label for="instCtg">기관구분:</label>
            <select id="instCtg" name="INST_CTG" class="form-control">
              <option value="">선택</option>
              <option value="bank">은행</option>
              <option value="nonbank">비은행</option>
            </select>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="applyConditions">조건 적용</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- 대출상품 결과 -->
<h3 class="text-center my-4">대출상품 결과</h3>
<div class="container" id="loanProductResults">
  <!-- 결과가 여기에 표시됨 -->
</div>

<!-- Bootstrap 및 jQuery 스크립트 추가 -->
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
  // 모달창에서 조건 적용 버튼 클릭 시 조건 값 폼에 반영
  $('#applyConditions').click(function () {
    var irtCtg = $('#irtCtg').val();
    var usge = $('#usge').val();
    var instCtg = $('#instCtg').val();

    // 모달창에서 선택한 조건을 hidden input에 저장
    $('form#loanProductForm').find('input[name="IRT_CTG"]').val(irtCtg);
    $('form#loanProductForm').find('input[name="USGE"]').val(usge);
    $('form#loanProductForm').find('input[name="INST_CTG"]').val(instCtg);

    // 모달창 닫기
    $('#conditionModal').modal('hide');

    // 폼 제출
    $('form#loanProductForm').submit();
  });
</script>
</body>
</html>
