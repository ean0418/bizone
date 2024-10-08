<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<html>
<head>
  <title>상세 정보</title>
  <meta charset="UTF-8">
  <style>
    .detail-info {
      margin: 20px;
      font-family: Arial, sans-serif;
    }
    .info-header {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 10px;
    }
    .info-item {
      margin: 10px 0;
    }
    .info-label {
      font-weight: bold;
      display: inline-block;
      width: 150px;
    }
    .checkbox-group {
      margin-top: 20px;
    }
  </style>
</head>
<body>
<div class="detail-info">
  <div class="info-header">상세 정보</div>
  <div class="content">
    <div id="selectedServiceCode">선택한 업종:</div>
    <div id="selectedAdminCode">선택한 지역:</div>
  </div>

  <%
    // URL 파라미터에서 service_code와 admin_code를 받아옴
    String serviceCode = request.getParameter("service_code");
    String adminCode = request.getParameter("admin_code");

    // 데이터베이스 연결 및 데이터 조회
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      Context initContext = new InitialContext();
      DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/YourDB");
      conn = ds.getConnection();

      String query = "SELECT ba.ba_name, bb.bb_code, ba.ba_total_resident_pop, ba.ba_total_floating_pop, ba.ba_total_workplace_pop, " +
              "ba.ba_total_expenditure, ba.ba_total_attractions, ba.ba_avg_rent_fee, ba.ba_avg_operating_months, ba.ba_avg_monthly_income " +
              "FROM bizone_admin ba " +
              "JOIN bizone_business bb ON bb.bb_code = ? " +
              "WHERE ba.ba_code = ?";

      pstmt = conn.prepareStatement(query);
      pstmt.setString(1, serviceCode);
      pstmt.setString(2, adminCode);

      rs = pstmt.executeQuery();

      if (rs.next()) {
        String areaName = rs.getString("ba_name");
        String businessName = rs.getString("bb_code");
  %>

  <div class="info-header">선택한 업종: <%= businessName %> (<%= serviceCode %>)</div>
  <div class="info-header">선택한 지역: <%= areaName %> (<%= adminCode %>)</div>

  <div class="checkbox-group">
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_total_resident_pop"> 총 거주 인구: <%= rs.getInt("ba_total_resident_pop") %></label>
    </div>
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_total_floating_pop"> 총 유동 인구: <%= rs.getInt("ba_total_floating_pop") %></label>
    </div>
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_total_workplace_pop"> 총 직장 인구: <%= rs.getInt("ba_total_workplace_pop") %></label>
    </div>
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_total_expenditure"> 총 지출 금액: <%= rs.getFloat("ba_total_expenditure") %></label>
    </div>
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_total_attractions"> 집객시설 수: <%= rs.getInt("ba_total_attractions") %></label>
    </div>
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_avg_rent_fee"> 평균 임대료: <%= rs.getFloat("ba_avg_rent_fee") %></label>
    </div>
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_avg_operating_months"> 운영 영업 개월 평균: <%= rs.getFloat("ba_avg_operating_months") %></label>
    </div>
    <div class="info-item">
      <label><input type="checkbox" name="dataOption" value="ba_avg_monthly_income"> 월 평균 소득 금액: <%= rs.getFloat("ba_avg_monthly_income") %></label>
    </div>
  </div>

  <div style="margin-top: 20px;">
    <button id="searchButton" onclick="searchSelectedData()">검색</button>
  </div>

  <%
  } else {
  %>
  <div class="info-header">해당 지역과 업종에 대한 정보를 찾을 수 없습니다.</div>
  <%
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
      if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
      if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
  %>
</div>

<script>
  // URL 파라미터를 읽는 함수
  function getParameterByName(name) {
    const url = window.location.search;
    const params = new URLSearchParams(url);
    return params.get(name);
  }

  // 선택한 업종과 지역 정보 표시
  const serviceCode = getParameterByName('service_code');
  const adminCode = getParameterByName('admin_code');
  document.getElementById('selectedServiceCode').innerText = `선택한 업종: ${serviceCode}`;
  document.getElementById('selectedAdminCode').innerText = `선택한 지역: ${adminCode}`;

  // 선택한 데이터를 검색하는 함수
  function searchSelectedData() {
    const selectedOptions = [];
    document.querySelectorAll('input[name="dataOption"]:checked').forEach(option => {
      selectedOptions.push(option.value);
    });

    if (selectedOptions.length > 0) {
      alert(`선택한 데이터: ${selectedOptions.join(', ')}`);
      // 여기서 AJAX를 통해 선택된 데이터에 대한 정보를 서버로 요청할 수 있습니다.
    } else {
      alert('최소한 하나의 항목을 선택해야 합니다.');
    }
  }
</script>
</body>
</html>

<%--<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="ko">--%>
<%--<head>--%>
<%--  <meta charset="UTF-8">--%>
<%--  <title>상세 정보</title>--%>
<%--  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>--%>
<%--</head>--%>
<%--<body>--%>
<%--<h1>상세 분석</h1>--%>

<%--<!-- 업종 검색 칸 -->--%>
<%--<div>--%>
<%--  <label for="businessSearch">업종 검색:</label>--%>
<%--  <input type="text" id="businessSearch" placeholder="업종명을 입력하세요" style="margin-right: 10px;">--%>
<%--  <input type="button" id="businessSearchButton" value="검색">--%>
<%--</div>--%>
<%--<div id="businessSearchResults"></div>--%>

<%--<!-- 행정동 검색 칸 -->--%>
<%--<div style="margin-top: 20px;">--%>
<%--  <label for="adminSearch">행정동 검색:</label>--%>
<%--  <input type="text" id="adminSearch" placeholder="행정동명을 입력하세요" style="margin-right: 10px;">--%>
<%--  <input type="button" id="adminSearchButton" value="검색">--%>
<%--</div>--%>
<%--<div id="adminSearchResults"></div>--%>

<%--<!-- 체크박스 영역 -->--%>
<%--<h2>데이터 선택</h2>--%>
<%--<form id="dataSelectionForm">--%>
<%--  <label><input type="checkbox" name="dataOption" value="ba_total_resident_population"> 총 거주 인구</label><br>--%>
<%--  <label><input type="checkbox" name="dataOption" value="ba_total_workplace_population"> 총 직장 인구</label><br>--%>
<%--  <label><input type="checkbox" name="dataOption" value="ba_avg_monthly_income"> 평균 월 소득</label><br>--%>
<%--  <label><input type="checkbox" name="dataOption" value="ba_total_expenditure"> 총 지출 금액</label><br>--%>
<%--  <label><input type="checkbox" name="dataOption" value="ba_avg_rent_fee"> 평균 임대료</label><br>--%>
<%--  <label><input type="checkbox" name="dataOption" value="ba_attraction_count"> 집객시설 수</label><br>--%>
<%--  <label><input type="checkbox" name="dataOption" value="bs_avg_monthly_sales"> 평균 월 매출</label><br>--%>
<%--  <!-- 기타 필요한 항목들도 추가 가능 -->--%>
<%--</form>--%>

<%--<!-- 검색 버튼 -->--%>
<%--<div style="margin-top: 20px;">--%>
<%--  <input type="button" id="calculateButton" value="검색">--%>
<%--</div>--%>

<%--<!-- 결과 표시 영역 -->--%>
<%--<h2>결과</h2>--%>
<%--<div id="resultArea">--%>
<%--  <!-- 계산 결과가 여기에 표시됩니다. -->--%>
<%--</div>--%>

<%--<script>--%>
<%--  // 업종 검색 처리--%>
<%--  $('#businessSearchButton').on('click', function () {--%>
<%--    const query = $('#businessSearch').val();--%>
<%--    if (query) {--%>
<%--      // 여기에 업종 검색 로직 추가 (Ajax를 통해 서버에서 검색 결과를 가져옴)--%>
<%--      $('#businessSearchResults').html(`<p>검색 결과: ${query}</p>`);--%>
<%--    } else {--%>
<%--      alert('업종명을 입력하세요.');--%>
<%--    }--%>
<%--  });--%>

<%--  // 행정동 검색 처리--%>
<%--  $('#adminSearchButton').on('click', function () {--%>
<%--    const query = $('#adminSearch').val();--%>
<%--    if (query) {--%>
<%--      // 여기에 행정동 검색 로직 추가 (Ajax를 통해 서버에서 검색 결과를 가져옴)--%>
<%--      $('#adminSearchResults').html(`<p>검색 결과: ${query}</p>`);--%>
<%--    } else {--%>
<%--      alert('행정동명을 입력하세요.');--%>
<%--    }--%>
<%--  });--%>

<%--  // 검색 버튼 클릭 시 선택된 항목에 대한 원본 데이터 조회--%>
<%--  $('#calculateButton').on('click', function () {--%>
<%--    const selectedDataOptions = [];--%>
<%--    $('input[name="dataOption"]:checked').each(function () {--%>
<%--      selectedDataOptions.push($(this).val());--%>
<%--    });--%>

<%--    if (selectedDataOptions.length > 0) {--%>
<%--      // 여기에 서버로 데이터 요청 및 원본 데이터 조회 로직 추가 (Ajax를 통해 서버에서 결과를 가져옴)--%>
<%--      $('#resultArea').html(`<p>선택된 항목에 대한 원본 데이터를 조회합니다...</p>`);--%>
<%--    } else {--%>
<%--      alert('최소 하나의 항목을 선택하세요.');--%>
<%--    }--%>
<%--  });--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>
