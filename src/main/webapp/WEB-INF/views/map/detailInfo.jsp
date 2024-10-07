<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상세 정보</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
</head>
<body>
<h1>상세 분석</h1>

<!-- 업종 검색 칸 -->
<div>
  <label for="businessSearch">업종 검색:</label>
  <input type="text" id="businessSearch" placeholder="업종명을 입력하세요" style="margin-right: 10px;">
  <input type="button" id="businessSearchButton" value="검색">
</div>
<div id="businessSearchResults"></div>

<!-- 행정동 검색 칸 -->
<div style="margin-top: 20px;">
  <label for="adminSearch">행정동 검색:</label>
  <input type="text" id="adminSearch" placeholder="행정동명을 입력하세요" style="margin-right: 10px;">
  <input type="button" id="adminSearchButton" value="검색">
</div>
<div id="adminSearchResults"></div>

<!-- 체크박스 영역 -->
<h2>데이터 선택</h2>
<form id="dataSelectionForm">
  <label><input type="checkbox" name="dataOption" value="ba_total_resident_population"> 총 거주 인구</label><br>
  <label><input type="checkbox" name="dataOption" value="ba_total_workplace_population"> 총 직장 인구</label><br>
  <label><input type="checkbox" name="dataOption" value="ba_avg_monthly_income"> 평균 월 소득</label><br>
  <label><input type="checkbox" name="dataOption" value="ba_total_expenditure"> 총 지출 금액</label><br>
  <label><input type="checkbox" name="dataOption" value="ba_avg_rent_fee"> 평균 임대료</label><br>
  <label><input type="checkbox" name="dataOption" value="ba_attraction_count"> 집객시설 수</label><br>
  <label><input type="checkbox" name="dataOption" value="bs_avg_monthly_sales"> 평균 월 매출</label><br>
  <!-- 기타 필요한 항목들도 추가 가능 -->
</form>

<!-- 검색 버튼 -->
<div style="margin-top: 20px;">
  <input type="button" id="calculateButton" value="검색">
</div>

<!-- 결과 표시 영역 -->
<h2>결과</h2>
<div id="resultArea">
  <!-- 계산 결과가 여기에 표시됩니다. -->
</div>

<script>
  // 업종 검색 처리
  $('#businessSearchButton').on('click', function () {
    const query = $('#businessSearch').val();
    if (query) {
      // 여기에 업종 검색 로직 추가 (Ajax를 통해 서버에서 검색 결과를 가져옴)
      $('#businessSearchResults').html(`<p>검색 결과: ${query}</p>`);
    } else {
      alert('업종명을 입력하세요.');
    }
  });

  // 행정동 검색 처리
  $('#adminSearchButton').on('click', function () {
    const query = $('#adminSearch').val();
    if (query) {
      // 여기에 행정동 검색 로직 추가 (Ajax를 통해 서버에서 검색 결과를 가져옴)
      $('#adminSearchResults').html(`<p>검색 결과: ${query}</p>`);
    } else {
      alert('행정동명을 입력하세요.');
    }
  });

  // 검색 버튼 클릭 시 선택된 항목에 대한 원본 데이터 조회
  $('#calculateButton').on('click', function () {
    const selectedDataOptions = [];
    $('input[name="dataOption"]:checked').each(function () {
      selectedDataOptions.push($(this).val());
    });

    if (selectedDataOptions.length > 0) {
      // 여기에 서버로 데이터 요청 및 원본 데이터 조회 로직 추가 (Ajax를 통해 서버에서 결과를 가져옴)
      $('#resultArea').html(`<p>선택된 항목에 대한 원본 데이터를 조회합니다...</p>`);
    } else {
      alert('최소 하나의 항목을 선택하세요.');
    }
  });
</script>
</body>
</html>
