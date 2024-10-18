<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>대출상품 조회</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f5f7fa; /* 부드러운 회색 배경 */
      font-family: 'Helvetica Neue', Arial, sans-serif; /* 고급스러운 기본 폰트 */
      color: #333; /* 본문 텍스트 색상 */
    }

    .container {
      background-color: white;
      border-radius: 12px; /* 둥근 모서리 */
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* 카드처럼 가벼운 그림자 */
      padding: 30px;
      margin-top: 20px;
    }

    h1 {
      font-size: 2.5rem;
      color: #2c3e50; /* 고급스러운 어두운 네이비 색상 */
      margin-bottom: 20px;
      font-weight: 700;
      text-align: center; /* 중앙 정렬 */
    }

    label {
      font-weight: 600;
      color: #34495e;
      font-size: 1.1rem;
    }

    .form-check-label {
      font-weight: 500;
      color: #7f8c8d;
    }

    .form-check-input:checked {
      background-color: #3498db;
      border-color: #3498db;
    }

    .btn-primary {
      background-color: #2980b9; /* 깊이 있는 블루 */
      border-color: #2980b9;
      padding: 10px 20px;
      font-size: 1.1rem;
      border-radius: 6px; /* 버튼의 부드러운 곡선 */
      transition: background-color 0.3s ease;
    }

    .btn-primary:hover {
      background-color: #1f639a; /* 더 진한 블루로 호버 효과 */
      border-color: #1f639a;
    }

    .card {
      border: none;
      border-radius: 12px;
      box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05); /* 카드에 더 깊은 그림자 */
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .card:hover {
      transform: translateY(-10px); /* 마우스 오버 시 살짝 떠오르는 느낌 */
      box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1); /* 그림자 강화 */
    }

    .card-title {
      font-weight: 700;
      font-size: 1.25rem;
      color: #34495e;
    }

    .card-text {
      font-size: 1rem;
      color: #7f8c8d;
      line-height: 1.6;
    }

    .pagination {
      justify-content: center;
    }

    .pagination .page-item.active .page-link {
      background-color: #2980b9;
      border-color: #2980b9;
    }

    .pagination .page-link {
      color: #2980b9;
      border-radius: 6px;
      padding: 10px 15px;
      margin: 0 5px;
      border: 1px solid #d1d1d1;
      transition: background-color 0.3s ease, color 0.3s ease;
    }

    .pagination .page-link:hover {
      background-color: #3498db;
      color: white;
      border-color: #3498db;
    }

    .pagination .page-item.disabled .page-link {
      color: #bdc3c7;
      background-color: #ecf0f1;
      border-color: #d1d1d1;
    }

  </style>
</head>
<body>
<div class="container mt-5">
  <h1>대출상품 조회</h1>
  <div class="text-right mb-3">
    <a href="${contextPath}/favorite" class="btn btn-secondary">찜한 상품 보기</a>
  </div>
  <!-- 조회 조건 입력 폼 -->
  <form action="${contextPath}/loan-products" method="get" class="mb-4">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    <!-- 금리구분 -->
    <div class="form-group">
      <label>금리구분:</label><br/>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="IRT_CTG" value="고정금리" ${irtCtg.contains('고정금리') ? 'checked' : ''}>
        <label class="form-check-label">고정금리</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="IRT_CTG" value="변동금리" ${irtCtg.contains('변동금리') ? 'checked' : ''}>
        <label class="form-check-label">변동금리</label>
      </div>
    </div>

    <!-- 용도 -->
    <div class="form-group">
      <label>용도:</label><br/>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="생계" ${usge.contains('생계') ? 'checked' : ''}>
        <label class="form-check-label">생계</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="운영" ${usge.contains('운영') ? 'checked' : ''}>
        <label class="form-check-label">운영</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="운전자금" ${usge.contains('운전자금') ? 'checked' : ''}>
        <label class="form-check-label">운전자금</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="학자금" ${usge.contains('학자금') ? 'checked' : ''}>
        <label class="form-check-label">학자금</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="주택" ${usge.contains('주택') ? 'checked' : ''}>
        <label class="form-check-label">주택</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="저금리전환" ${usge.contains('저금리전환') ? 'checked' : ''}>
        <label class="form-check-label">저금리전환</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="주거" ${usge.contains('주거') ? 'checked' : ''}>
        <label class="form-check-label">주거</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="창업" ${usge.contains('창업') ? 'checked' : ''}>
        <label class="form-check-label">창업</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="USGE" value="기타" ${usge.contains('기타') ? 'checked' : ''}>
        <label class="form-check-label">기타</label>
      </div>
    </div>

    <!-- 기관구분 -->
    <div class="form-group">
      <label>기관구분:</label><br/>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="INST_CTG" value="일반기관" ${instCtg.contains('일반기관') ? 'checked' : ''}>
        <label class="form-check-label">일반기관</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="INST_CTG" value="공공·정부기관" ${instCtg.contains('공공·정부기관') ? 'checked' : ''}>
        <label class="form-check-label">공공·정부기관</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="INST_CTG" value="지자체" ${instCtg.contains('지자체') ? 'checked' : ''}>
        <label class="form-check-label">지자체</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="INST_CTG" value="은행" ${instCtg.contains('은행') ? 'checked' : ''}>
        <label class="form-check-label">은행</label>
      </div>
    </div>

    <!-- 거주지역 -->
    <div class="form-group">
      <label>거주지역:</label><br/>
      <select class="form-control" name="RSD_AREA_PAMT_EQLT_ISTM">
        <option value="전국" ${rsdAreaPamtEqltIstm == '전국' ? 'selected' : ''}>전국</option>
        <option value="서울" ${rsdAreaPamtEqltIstm == '서울' ? 'selected' : ''}>서울</option>
        <option value="경기" ${rsdAreaPamtEqltIstm == '경기' ? 'selected' : ''}>경기</option>
        <option value="강원" ${rsdAreaPamtEqltIstm == '강원' ? 'selected' : ''}>강원</option>
        <option value="충북" ${rsdAreaPamtEqltIstm == '충북' ? 'selected' : ''}>충북</option>
        <option value="충남" ${rsdAreaPamtEqltIstm == '충남' ? 'selected' : ''}>충남</option>
        <option value="전북" ${rsdAreaPamtEqltIstm == '전북' ? 'selected' : ''}>전북</option>
        <option value="전남" ${rsdAreaPamtEqltIstm == '전남' ? 'selected' : ''}>전남</option>
        <option value="경북" ${rsdAreaPamtEqltIstm == '경북' ? 'selected' : ''}>경북</option>
        <option value="경남" ${rsdAreaPamtEqltIstm == '경남' ? 'selected' : ''}>경남</option>
        <option value="제주" ${rsdAreaPamtEqltIstm == '제주' ? 'selected' : ''}>제주</option>
        <option value="인천" ${rsdAreaPamtEqltIstm == '인천' ? 'selected' : ''}>인천</option>
        <option value="대전" ${rsdAreaPamtEqltIstm == '대전' ? 'selected' : ''}>대전</option>
        <option value="대구" ${rsdAreaPamtEqltIstm == '대구' ? 'selected' : ''}>대구</option>
        <option value="울산" ${rsdAreaPamtEqltIstm == '울산' ? 'selected' : ''}>울산</option>
        <option value="부산" ${rsdAreaPamtEqltIstm == '부산' ? 'selected' : ''}>부산</option>
        <option value="광주" ${rsdAreaPamtEqltIstm == '광주' ? 'selected' : ''}>광주</option>
        <option value="세종" ${rsdAreaPamtEqltIstm == '세종' ? 'selected' : ''}>세종</option>
      </select>
    </div>

    <!-- 대상 필터 -->
    <div class="form-group">
      <label>대상 필터:</label><br/>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="근로자" ${tgtFltr.contains('근로자') ? 'checked' : ''}>
        <label class="form-check-label">근로자</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="사업자" ${tgtFltr.contains('사업자') ? 'checked' : ''}>
        <label class="form-check-label">사업자</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="소기업" ${tgtFltr.contains('소기업') ? 'checked' : ''}>
        <label class="form-check-label">소기업</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="대학생·청년" ${tgtFltr.contains('대학생·청년') ? 'checked' : ''}>
        <label class="form-check-label">대학생·청년</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="소상공인" ${tgtFltr.contains('소상공인') ? 'checked' : ''}>
        <label class="form-check-label">소상공인</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="중소기업" ${tgtFltr.contains('중소기업') ? 'checked' : ''}>
        <label class="form-check-label">중소기업</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="금융취약계층" ${tgtFltr.contains('금융취약계층') ? 'checked' : ''}>
        <label class="form-check-label">금융취약계층</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="기타" ${tgtFltr.contains('기타') ? 'checked' : ''}>
        <label class="form-check-label">기타</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="채무조정자" ${tgtFltr.contains('채무조정자') ? 'checked' : ''}>
        <label class="form-check-label">채무조정자</label>
      </div>
      <div class="form-check form-check-inline">
        <input class="form-check-input" type="checkbox" name="TGT_FLTR" value="농림어업인" ${tgtFltr.contains('농림어업인') ? 'checked' : ''}>
        <label class="form-check-label">농림어업인</label>
      </div>
    </div>

    <button type="submit" class="btn btn-primary">조회</button>
  </form>

  <!-- 조회 결과 출력 -->
  <h2>조회 결과</h2>
  <c:if test="${not empty loanProducts}">
    <div class="row">
      <c:forEach var="product" items="${loanProducts}">
        <div class="col-md-4 mb-4">
          <div class="card h-100">
            <div class="card-body">
              <h5 class="card-title">${product.productName}</h5>
              <p class="card-text">
                <strong>대출 한도:</strong> ${product.loanLimit}만원<br/>
                <strong>금리:</strong>
                <c:choose>
                  <c:when test="${empty product.interestRate || product.interestRate == '-'}"><br/>
                    데이터 없음
                  </c:when>
                  <c:otherwise>
                    ${product.interestRate}%<br/>
                  </c:otherwise>
                </c:choose>
                <strong>자격 조건:</strong> ${product.qualification}
              </p>

              <!-- 찜하기 하트 아이콘 -->
              <form action="${contextPath}/addFavorite" method="post" class="favorite-form">
                <input type="hidden" name="productName" value="${product.productName}">
                <input type="hidden" name="loanLimit" value="${product.loanLimit}">
                <input type="hidden" name="interestRate" value="${product.interestRate}">
                <input type="hidden" name="qualification" value="${product.qualification}">

                <button type="submit" class="btn btn-link">
                  <c:choose>
                    <c:when test="${product.isFavorite}">
                      <!-- 찜한 상태 (채워진 하트) -->
                      <i class="fas fa-heart" style="color: red;"></i>
                    </c:when>
                    <c:otherwise>
                      <!-- 찜하지 않은 상태 (빈 하트) -->
                      <i class="far fa-heart" style="color: grey;"></i>
                    </c:otherwise>
                  </c:choose>
                </button>
              </form>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>
  <c:if test="${empty loanProducts}">
    <p>조건에 해당하는 대출상품이 없습니다.</p>
  </c:if>
</div>


<!-- 페이지네이션 -->
<nav aria-label="Page navigation">
  <ul class="pagination justify-content-center">
    <!-- 이전 페이지 -->
    <c:if test="${currentPage > 1}">
      <li class="page-item">
        <a class="page-link" href="?pageNo=${currentPage - 1}&numOfRows=${numOfRows}&IRT_CTG=${irtCtg}&USGE=${usge}&INST_CTG=${instCtg}&RSD_AREA_PAMT_EQLT_ISTM=${rsdAreaPamtEqltIstm}&TGT_FLTR=${tgtFltr}" aria-label="Previous">
          <span aria-hidden="true">&laquo;</span>
        </a>
      </li>
    </c:if>

    <!-- 페이지 번호 범위 설정 -->
    <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
    <c:set var="endPage" value="${startPage + 4 <= totalPages ? startPage + 4 : totalPages}" />
    <c:forEach begin="${startPage}" end="${endPage}" var="page">
      <li class="page-item ${currentPage == page ? 'active' : ''}">
        <a class="page-link" href="?pageNo=${page}&numOfRows=${numOfRows}&IRT_CTG=${irtCtg}&USGE=${usge}&INST_CTG=${instCtg}&RSD_AREA_PAMT_EQLT_ISTM=${rsdAreaPamtEqltIstm}&TGT_FLTR=${tgtFltr}">${page}</a>
      </li>
    </c:forEach>

    <!-- 다음 페이지 -->
    <c:if test="${currentPage < totalPages}">
      <li class="page-item">
        <a class="page-link" href="?pageNo=${currentPage + 1}&numOfRows=${numOfRows}&IRT_CTG=${irtCtg}&USGE=${usge}&INST_CTG=${instCtg}&RSD_AREA_PAMT_EQLT_ISTM=${rsdAreaPamtEqltIstm}&TGT_FLTR=${tgtFltr}" aria-label="Next">
          <span aria-hidden="true">&raquo;</span>
        </a>
      </li>
    </c:if>
  </ul>
</nav>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>