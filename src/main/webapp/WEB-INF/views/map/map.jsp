<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>상권분석</title>
    <meta charset="UTF-8">

    <!-- jQuery 로드 (필수) -->
    <script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>

    <!-- Popper.js 로드 (Bootstrap 4에서 필수) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>

    <!-- Bootstrap JavaScript 로드 (jQuery 이후에 로드) -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- Font Awesome 아이콘 CSS (옵션) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <!-- Chart.js 로드 -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- 카카오 맵 및 우편번호 서비스 -->
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <style>
        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: transparent; /* 전체 배경을 투명하게 설정 */
            font-family: 'Noto Sans KR', sans-serif;
        }

        .content {
            display: flex;
            height: 100vh; /* 전체 화면 높이를 유지 */
            background-color: transparent; /* content의 배경을 투명하게 설정 */
            position: relative; /* content를 상대 위치로 설정 */
        }

        #regionModal {
            overflow-y: scroll;
        }

        #sidebar {
            width: 350px; /* 사이드바 너비 설정 */
            background-color: rgba(255, 255, 255, 0); /* 사이드바를 완전히 투명하게 설정 */
            border: none; /* 경계선 제거 */
            padding: 20px 15px;
            border-radius: 12px;
            margin: 20px;
            position: absolute; /* 절대 위치로 설정 */
            z-index: 10; /* z-index를 높여 지도의 위에 배치 */
        }

        #sidebar-content {
            width: 380px; /* 사이드바 너비 설정 */
            background-color: #ffffff; /* 흰색 배경 */
            border-radius: 20px; /* 둥근 모서리 설정 */
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* 그림자 효과 */
            padding: 30px 25px; /* 내부 여백 설정 */
            margin: 20px;
            position: relative;; /* 사이드바 내용의 배경을 투명하게 설정 */
        }

        #sidebar h1 {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }

        .input-container {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .input-container input[type="text"] {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선을 투명하게 설정 */
            border-radius: 6px;
            font-size: 14px;
            margin-right: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
            background-color: rgba(255, 255, 255, 0.2); /* 입력 필드 배경 투명하게 설정 */
            color: #333; /* 텍스트 색상 설정 */
            transition: all 0.3s ease;
        }

        .input-container input[type="text"]:focus {
            border-color: rgba(65, 105, 225, 0.5); /* 포커스 시 테두리 색 변경 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            background-color: rgba(255, 255, 255, 0.4); /* 포커스 시 배경 덜 투명하게 */
        }

        .input-container input[type="button"] {
            padding: 12px 15px;
            border: none;
            border-radius: 6px;
            background-color: rgba(65, 105, 225, 0.8); /* 버튼 배경 설정 */
            color: #fff;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .input-container input[type="button"]:hover {
            background-color: rgba(39, 72, 179, 0.9); /* 마우스 오버 시 배경 덜 투명하게 */
        }

        .select-container select {
            width: 100%;
            padding: 12px;
            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선 투명도 설정 */
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 14px;
            background-color: rgba(255, 255, 255, 0.2); /* 드롭다운 배경 투명하게 설정 */
            color: #333;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        #mapContainer {
            flex: 1;
            height: 100vh; /* 전체 화면 높이를 사용 */
            background-color: transparent; /* 지도 컨테이너 배경 투명하게 설정 */
            position: relative;
        }

        #map {
            width: 100%;
            height: 100%;
        }
        .footer {
            display: none; /* 하단 푸터 숨김 처리 */
        }
        #welcomeModal .modal-content {
            border-radius: 12px; /* 모달의 테두리를 둥글게 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 모달에 그림자 효과 추가 */
        }

        #welcomeModal .modal-header {
            border-bottom: 2px solid #17a2b8; /* 모달 헤더 하단 테두리 */
        }

        #welcomeModal .modal-body h6 {
            color: #0056b3; /* 안내 텍스트 색상 */
        }
    </style>
</head>
<body>
<div class="content">
    <div id="sidebar">
        <div id="sidebar-content">
            <h1>상권분석</h1>
            <div class="input-container">
                <input type="text" id="sample5_address" placeholder="주소 찾기" readonly>
                <input type="button" id="search_button" onclick="sample5_execDaumPostcode()" value="주소 찾기">
            </div>
            <div class="input-container">
                <input type="text" id="eupMyeonDongSearch" placeholder="지역 검색">
                <input type="button" id="eupMyeonDongSearchButton" value="지역 검색">
            </div>
            <div class="input-container">
                <input type="text" id="businessCategorySearch" placeholder="업종 검색">
                <input type="button" id="businessCategorySearchButton" value="업종 검색">
            </div>

            <ul id="searchResults"></ul>
            <div id="pagination" style="text-align: center; margin-top: 20px;"></div>
            <div id="selectedBusiness" style="margin-top: 20px;">
                <!-- 선택된 업종이 여기에 표시됩니다. -->
            </div>
            <div class="select-container">
                <select id="locationSelect">
                    <option selected disabled>서울시 구 바로가기</option>
                    <option value="37.5172363,127.0473248">강남구</option>
                    <option value="37.5511,127.1465">강동구</option>
                    <option value="37.6397743,127.0259653">강북구</option>
                    <option value="37.5509787,126.8495384">강서구</option>
                    <option value="37.4784064,126.9516133">관악구</option>
                    <option value="37.5384841,127.0822934">광진구</option>
                    <option value="37.4954856,126.8877243">구로구</option>
                    <option value="37.4568502,126.8958117">금천구</option>
                    <option value="37.6541916,127.0567936">노원구</option>
                    <option value="37.6686912,127.0472104">도봉구</option>
                    <option value="37.5742915,127.0395685">동대문구</option>
                    <option value="37.5124095,126.9395078">동작구</option>
                    <option value="37.5663244,126.9014017">마포구</option>
                    <option value="37.5791433,126.9369178">서대문구</option>
                    <option value="37.4836042,127.0327595">서초구</option>
                    <option value="37.5632561,127.0364285">성동구</option>
                    <option value="37.5893624,127.0167415">성북구</option>
                    <option value="37.5145436,127.1059163">송파구</option>
                    <option value="37.5270616,126.8561536">양천구</option>
                    <option value="37.5263614,126.8966016">영등포구</option>
                    <option value="37.5322958,126.9904348">용산구</option>
                    <option value="37.6026956,126.9291993">은평구</option>
                    <option value="37.573293,126.979672">종로구</option>
                    <option value="37.5636152,126.9979403">중구</option>
                    <option value="37.6063241,127.092728">중랑구</option>
                </select>
            </div>
        </div>
    </div>
    <div id="mapContainer">
        <div id="map"></div>
    </div>
</div>

<!-- 모달 창 (regionModal) -->
<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <!-- 모달 헤더 (닫기 버튼 없음) -->
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="regionModalLabel"><i class="fas fa-chart-area"></i> 지역 상권 분석</h5>
            </div>

            <!-- 모달 바디 시작 -->
            <div class="modal-body" id="modal-body">
                <div class="container-fluid">
                    <div class="row">
                        <!-- 지역명 및 차트 -->
                        <div class="col-md-12 mb-4">
                            <h5 class="text-center font-weight-bold" id="regionName">지역명</h5>
                            <canvas id="regionChart" style="max-width: 100%;"></canvas>
                        </div>

                        <!-- 선택된 업종 정보 -->
                        <div class="col-md-12">
                            <div class="card mb-4">
                                <div class="card-body bg-light">
                                    <h6 class="font-weight-bold"><i class="fas fa-store"></i> 선택된 업종: <span id="selectedBusinessModal" class="text-primary">정보 없음</span></h6>
                                </div>
                            </div>
                        </div>

                        <!-- 성공 확률 정보 -->
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-body">
                                    <h6 class="font-weight-bold"><i class="fas fa-percentage"></i> 성공 확률:</h6>
                                    <span id="successProbability" class="display-4 text-success font-weight-bold">정보 없음</span>
                                </div>
                            </div>
                        </div>

                        <!-- 파워랭킹 -->
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-body">
                                    <h6 class="font-weight-bold"><i class="fas fa-check-circle"></i> 파워랭킹:</h6>
                                    <span id="rank" class="display-4 text-info font-weight-bold">정보 없음</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 모달 바디 끝 -->

            <!-- 모달 푸터 (닫기 버튼 없음) -->
            <div class="modal-footer">
                <button id="detailbtn" class="btn btn-primary btn-lg w-100"><i class="fas fa-info-circle"></i> 데이터 자세히 보기</button>
            </div>

            <!-- 첫 번째 모달의 확인 버튼 -->
            <button id="closeRegionModal" class="btn btn-primary"><i class="fas fa-check-circle"></i> 확인</button>
        </div>
    </div>
</div>

<!-- 두 번째 모달 창 (detailedModal) -->
<div class="modal fade" id="detailedModal" tabindex="-1" role="dialog" aria-labelledby="detailedModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <!-- 모달 헤더 (닫기 버튼 없음) -->
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="detailedModalLabel"><i class="fas fa-info-circle"></i> 상세 정보 보기</h5>
            </div>

            <!-- 모달 바디 -->
            <div class="modal-body" id="detailed-modal-body">
                <div class="container-fluid">
                    <!-- 업종 및 지역 정보 -->
                    <div class="card mb-4">
                        <div class="card-body bg-light">
                            <h6 class="font-weight-bold"><i class="fas fa-briefcase"></i> 업종: <span id="detailedBusinessName" class="text-primary">정보 없음</span></h6>
                            <h6 class="font-weight-bold"><i class="fas fa-map-marker-alt"></i> 지역: <span id="detailedRegionName" class="text-primary">정보 없음</span></h6>
                        </div>
                    </div>

                    <!-- 상세 데이터 리스트 -->
                    <ul class="list-group">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <i class="fas fa-users"> 총 거주 인구: <span id="totalResidentPopulation"></span></i>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <i class="fas fa-building"> 총 직장 인구: <span id="totalWorkplacePopulation"></span></i>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <i class="fas fa-chart-line"> 총 유동 인구: <span id="totalFloatingPopulation"></span></i>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <i class="fas fa-hotel"> 집객시설 수: <span id="attractionCount"></span></i>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <i class="fas fa-dollar-sign"> 평균 월 소득: <span id="avgMonthlyIncome"></span></i>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <i class="fas fa-coins"> 총 지출 금액: <span id="totalExpenditure"></span></i>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <i class="fas fa-home"> 평균 임대료: <span id="avgRentFee"></span></i>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- 모달 푸터 (닫기 버튼 없음) -->
            <div class="modal-footer">
                <button id="closeDetailedModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->
            </div>
        </div>
    </div>
</div>

<!-- JavaScript -->
<script>
    $(document).ready(function () {
        // 첫 번째 모달의 확인 버튼 클릭 시 모달 닫기
        $('#closeRegionModal').on('click', function () {
            $('#regionModal').modal('hide'); // regionModal 닫기
        });

    });

    $(document).ready(function () {
        // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기
        $('#closeDetailedModal').on('click', function () {
            $('#detailedModal').modal('hide'); // detailedModal 닫기
        });

    });

</script>

<!-- 페이지 첫 접속 시 보여줄 안내 팝업 -->
<div class="modal fade" id="popupModal" tabindex="-1" role="dialog" aria-labelledby="welcomeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <!-- 팝업 헤더 -->
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="welcomeModalLabel"><i class="fas fa-info-circle"></i> 상권 분석 시스템 안내</h5>
            </div>

            <!-- 팝업 바디 -->
            <div class="modal-body">
                <div class="container-fluid">
                    <!-- 안내 내용 구성 -->
                    <div class="card mb-4">
                        <div class="card-body bg-light">
                            <h6 class="font-weight-bold"><i class="fas fa-lightbulb"></i> 상권 분석 시스템에 오신 것을 환영합니다!</h6>
                            <p>
                                이 시스템을 통해 지역별 상권 분석, 업종 선택 및 분석, 상세 데이터를 확인할 수 있습니다.
                                <br><br>
                                <strong>간단 분석 방법 안내:</strong>
                            <ol>
                                <li>분석할 지역 및 업종을 선택합니다.</li>
                                <li>분석하기 버튼을 클릭하여 결과를 확인합니다.</li>
                                <li>결과를 확인 후, 상세 데이터 보기 버튼을 통해 더 많은 정보를 얻을 수 있습니다.</li>
                            </ol>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 팝업 푸터 (닫기 버튼) -->
            <div class="modal-footer">
                <button id="closePopupModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->
            </div>
        </div>
    </div>
</div>

<!-- 메인홈페이지에서 설명 팝업창 -->
<script>
    $(document).ready(function () {
        // 페이지가 로드되면 자동으로 팝업을 띄우는 함수
        $('#popupModal').modal('show');  // Bootstrap 모달 표시

    });

    $(document).ready(function () {
        // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기
        $('#closePopupModal').on('click', function () {
            $('#popupModal').modal('hide'); // detailedModal 닫기
        });

    });
</script>

<script>
    var map, customOverlay, polygons = [];
    var isBoundaryLoaded = false;
    var marker = null;
    var infowindow = null;

    // 경계 데이터 로드 상태를 추적하는 변수
    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부
    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부
    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부

    let globalRegionName = '';  // 전역 변수 선언
    let globalSearchedRegion = "";

    function initKakaoMap() {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울중심좌표
            level: 7,
        };
        map = new kakao.maps.Map(container, options);
        customOverlay = new kakao.maps.CustomOverlay({});

        var previousZoomLevel = map.getLevel();

        // 범위 설정
        var bounds = new kakao.maps.LatLngBounds(
            new kakao.maps.LatLng(37.4300, 126.8000), // 남서쪽 좌표
            new kakao.maps.LatLng(37.6800, 127.1000)  // 북동쪽 좌표
        );

        // 지도의 이동을 서울시 범위로 제한
        kakao.maps.event.addListener(map, 'center_changed', function () {
            if (!bounds.contain(map.getCenter())) {
                // 현재 지도 중심이 서울시 범위를 벗어난 경우
                var currentCenter = map.getCenter();

                // 지도 중심이 서울시 범위 바깥으로 나갔을 때의 제한 처리
                var newCenter = new kakao.maps.LatLng(
                    Math.min(Math.max(currentCenter.getLat(), bounds.getSouthWest().getLat()), bounds.getNorthEast().getLat()),
                    Math.min(Math.max(currentCenter.getLng(), bounds.getSouthWest().getLng()), bounds.getNorthEast().getLng())
                );

                map.setCenter(newCenter); // 지도 중심을 서울시 범위 내로 고정
            }
        });

        // 확대/축소 레벨 제한
        map.setMinLevel(3);
        map.setMaxLevel(10);

        // 서울시 구 선택 시 해당 구로 지도 이동
        $("#locationSelect").on("change", function () {
            if (map) {
                var coords = $(this).val().split(',');
                var latLng = new kakao.maps.LatLng(coords[0], coords[1]);
                map.setCenter(latLng);
                map.setLevel(8);
            }
        });

        // 지도 레벨 변경에 따른 경계 데이터 처리
        kakao.maps.event.addListener(map, 'zoom_changed', function () {
            var level = map.getLevel();
            console.log('Current zoom level:', level);

            // 확대/축소에 따른 경계 데이터 전환
            if (level <= 7) {
                if (!isEupMyeonDongLoaded) {
                    removePolygons();
                    loadEupMyeonDongData();
                }
            } else if (level > 7 && level <= 9) {
                if (!isSiGunGuLoaded) {
                    removePolygons();
                    loadSiGunGuData();
                }
            } else if (level > 9) {
                if (!isSiDoLoaded) {
                    removePolygons();
                    loadSiDoData();
                }
            }
        });
    }

    let chartInstance = null;

    // 지역 및 업종을 클릭했을 때 호출되는 함수
    function showRegionInfo(regionName, adminCode, serviceCode) {
        updateSelectedData({ bb_code: serviceCode }, adminCode); // 추가
        $.ajax({
            url: `/api/bizone/getChartDataForDetail`,
            method: 'GET',
            data: {
                admin_code: adminCode,  // 행정동 코드
                service_code: serviceCode  // 서비스 코드
            },
            success: function (data) {
                console.log('Received Data for Chart:', data);

                // 모달 창 업데이트 코드
                $('#regionName').text(regionName + " 상권분석");
                $('#selectedBusinessModal').text(selectedBusiness ? selectedBusiness.bb_name : '정보 없음');

                // 두 번째 모달 창 업데이트 코드 추가
                $('#detailedRegionName').text(globalRegionName || adminCode);  // 전역 변수 사용

                const chartData = {
                    labels: ['평균 임대료', '총 직장인구수', '총 지출 금액', '집객시설 수', '평균 월 매출', '기타'],
                    datasets: [{
                        label: '상권분석 데이터',
                        data: [
                            data.avgRentFeeScore.toFixed(2),
                            data.totalWorkplacePopulationScore.toFixed(2),
                            data.totalExpenditureScore.toFixed(2),
                            data.attractionCountScore.toFixed(2),
                            data.avgMonthlySalesScore.toFixed(2),
                            data.otherScoresTotal.toFixed(2)
                        ],
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }]
                };

                if (chartInstance) {
                    chartInstance.destroy();
                }

                const ctx = document.getElementById('regionChart').getContext('2d');
                chartInstance = new Chart(ctx, {
                    type: 'bar',
                    data: chartData,
                    options: {
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 8  // y값 최대치 정하기
                            }
                        }
                    }
                });

                const successProbability = parseFloat(data.successProbability).toFixed(2);
                $('#successProbability').text(successProbability + "%");
                $('#regionModal').modal('show');
            },
            error: function () {
                alert("정보가 없는 지역입니다. 다시 선택해주세요.");
            }
        });
    }

    let selectedServiceCode = null;
    let selectedAdminCode = null;

    // 업종과 지역 선택 시 데이터를 설정하는 함수
    function updateSelectedData(business, areaCode, areaName) {
        selectedServiceCode = business ? business.bb_code : null;
        selectedServiceName = business ? business.bb_name : '정보 없음'; // 업종명 저장
        selectedAdminCode = areaCode;
        selectedAdminName = areaName || '정보 없음'; // 지역명 저장
        console.log('Selected data updated:', selectedServiceCode, selectedAdminCode, selectedServiceName, selectedAdminName);
    }

    // 자세히 보기 버튼 클릭 이벤트 핸들러
    $('#detailbtn').on('click', function () {
        console.log('Before sending request, selectedServiceCode:', selectedServiceCode, 'selectedAdminCode:', selectedAdminCode);

        if (selectedServiceCode && selectedAdminCode) {
            // 지역명을 가져오는 AJAX 요청 추가
            $.ajax({
                url: `/api/bizone/getRegionName`,
                method: 'GET',
                data: { admin_code: selectedAdminCode },
                success: function (regionName) {
                    console.log("in getRegionName")
                    console.log(regionName)
                    $('#detailedRegionName').text(globalRegionName); // 지역명 업데이트
                },
                error: function () {
                    $('#detailedRegionName').text(selectedAdminCode); // 오류 발생 시 코드 표시
                }
            });

            $.ajax({
                url: `/api/bizone/getDetailData`,
                method: 'GET',
                data: {
                    admin_code: selectedAdminCode,
                    service_code: selectedServiceCode
                },
                success: function (data) {
                    console.log('Detailed data received:', data);

                    // 모달 창에 데이터를 표시하는 로직
                    $('#detailedBusinessName').text(selectedBusiness.bb_name || selectedServiceCode);
                    $('#totalResidentPopulation').text(data.totalResidentPopulation.toLocaleString() + "명");
                    $('#totalWorkplacePopulation').text(data.totalWorkplacePopulation.toLocaleString() + "명");
                    $('#totalFloatingPopulation').text(data.totalFloatingPopulation.toLocaleString() + "명");
                    $('#attractionCount').text(data.attractionCount.toLocaleString() + "개");
                    $('#avgMonthlyIncome').text(data.avgMonthlyIncome.toLocaleString() + "원");
                    $('#totalExpenditure').text(data.totalExpenditure.toLocaleString() + "원");
                    $('#avgRentFee').text(data.avgRentFee.toLocaleString() + "원");
                    $('#detailedModal').modal('show');
                },
                error: function (xhr, status, error) {
                    console.error('Error fetching detailed data:', error);
                    alert('자세한 데이터를 불러오는 중 오류가 발생했습니다.');
                }
            });
        } else {
            console.warn("업종과 지역 정보가 누락되었습니다.");
            alert("업종과 지역을 선택해주세요.");
        }
    });

    // GeoJSON 데이터를 불러와 경계선을 그리는 함수
    function loadGeoJson(url, type) {
        $.getJSON(url, function (data) {
            data.features.forEach(function (feature) {
                var path = feature.geometry.coordinates[0].map(function (coord) {
                    return new kakao.maps.LatLng(coord[1], coord[0]);
                });

                var polygon = new kakao.maps.Polygon({
                    map: map,
                    path: path,
                    fillColor: "rgba(30, 144, 255, 0.1)",
                    strokeColor: "#104486",
                    strokeWeight: 2,
                });

                kakao.maps.event.addListener(polygon, 'click', function () {
                    if (isBoundaryLoaded) {  // 경계 데이터가 켜져 있을 때만 실행
                        var regionName = feature.properties.adm_nm ?? feature.properties.sggnm;
                        showRegionInfo(regionName);  // 지역 이름 전달
                    }
                });

                polygons.push(polygon);
            });
        });
    }

    function loadSiDoData() {
        $.ajax({
            url: "/resources/data/SeoulSi.geojson",  // 시도 경계 데이터
            dataType: "json",
            success: function (data) {
                kkoMap.loadGeoJson(data, "시도");
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error("Error loading SeoulSi GeoJSON data:", textStatus, errorThrown);
            }
        });
    }

    function loadSiGunGuData() {
        $.ajax({
            url: "/resources/data/SeoulGu.geojson",  // 서울 구 경계 데이터
            dataType: "json",
            success: function (data) {
                kkoMap.loadGeoJson(data, "시군구");
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error("Error loading SeoulGu GeoJSON data:", textStatus, errorThrown);
            }
        });
    }

    function loadEupMyeonDongData() {
        $.ajax({
            url: "/resources/data/SeoulDong.geojson",  // 서울 동 경계 데이터
            dataType: "json",
            success: function (data) {
                kkoMap.loadGeoJson(data, "읍면동");
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error("Error loading SeoulDong GeoJSON data:", textStatus, errorThrown);
            }
        });
    }

    function removePolygons() {
        polygons.forEach(function (polygon) {
            polygon.setMap(null);
        });
        polygons = [];

        // 남아있는 overlaybox 제거
        if (customOverlay) {
            customOverlay.setMap(null);
        }
    }

    var kkoMap = {
        loadGeoJson: function (geoJsonData, type) {
            var fillColor, strokeColor;
            if (type === "읍면동") {
                fillColor = "rgba(30, 144, 255, 0.1)";
                strokeColor = "#104486";
            } else if (type === "시군구") {
                fillColor = "rgba(30, 144, 255, 0.1)";
                strokeColor = "#163599";
            } else if (type === "시도") {
                fillColor = "rgba(30, 144, 255, 0.1)"
                strokeColor = "#101e4e";
            }

            geoJsonData.features.forEach(function (feature) {
                if (type !== "시도") {

                    if (feature.properties.adm_nm?.split(" ").includes(globalSearchedRegion)) {
                        kkoMap.setPolygon(kkoMap.getPolygonData(feature), "pink", strokeColor, type);
                    } else {
                        if (feature.properties.sggnm.split(" ").includes(globalSearchedRegion)) {
                            kkoMap.setPolygon(kkoMap.getPolygonData(feature), "hotpink", strokeColor, type)
                        } else {
                            kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);
                        }
                    }
                } else {
                    kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);
                }
            });


        },

        getPolygonData: function (feature) {
            var path = [];
            feature.geometry.coordinates.forEach(function (coords) {
                coords.forEach(function (innerCoords) {  // 다차원 좌표 처리
                    path.push(innerCoords.map(function (coord) {
                        return new kakao.maps.LatLng(coord[1], coord[0]);
                    }));
                });
            });
            return {
                code: feature.properties.adm_cd2,
                name: feature.properties.adm_nm ?? feature.properties.sggnm ?? feature.properties.sidonm,
                path: path
            };
        },

        setPolygon: function (area, fillColor, strokeColor, type) {
            var polygon = new kakao.maps.Polygon({
                path: area.path,
                strokeWeight: 2,
                strokeColor: strokeColor,
                strokeOpacity: 0.8,
                fillColor: fillColor,
                fillOpacity: fillColor === "hotpink" ? 0.7 : 0.3,
            });

            let isMouseOver = false;

            kakao.maps.event.addListener(polygon, "mouseover", function () {
                if (!isMouseOver) {
                    isMouseOver = true;
                    polygon.setOptions({fillColor: type === "읍면동" ? "#0D94E8" : "#0031FD"});
                    customOverlay.setContent("<div class='overlaybox'>" + area.name + "</div>");
                    customOverlay.setMap(map);
                }
            });

            kakao.maps.event.addListener(polygon, "mousemove", function (mouseEvent) {
                if (isMouseOver) {
                    const offsetX = 35;
                    const offsetY = 35;
                    const projection = map.getProjection();
                    const point = projection.pointFromCoords(mouseEvent.latLng);
                    point.x += offsetX;
                    point.y += offsetY;
                    const newPosition = projection.coordsFromPoint(point);
                    customOverlay.setPosition(newPosition);
                }
            });

            kakao.maps.event.addListener(polygon, "mouseout", function () {
                if (isMouseOver) {
                    isMouseOver = false;
                    polygon.setOptions({fillColor: fillColor});
                    customOverlay.setMap(null);
                }
            });

            // 지역(폴리곤)을 클릭할 때 updateSelectedData 호출
            kakao.maps.event.addListener(polygon, "click", function () {
                if (map.getLevel() >= 8) {
                    // 구나 도 단위에서는 클릭 이벤트 발생하지 않도록 무시
                    return;
                }

                console.log('Polygon Clicked:', area.name); // 클릭된 폴리곤 정보 확인

                if (!selectedBusiness || !selectedBusiness.bb_code) {
                    console.log('alert확인용 코드'); // 로그 추가
                    alert("업종을 선택해주세요.");
                    return; // 업종이 선택되지 않았으면 함수 종료
                }

                previousZoomLevel = map.getLevel(); // 클릭 시 현재 지도 레벨 저장
                selectedAdminCode = area.code; // 클릭한 지역의 행정동 코드 업데이트
                globalRegionName = area.name;

                console.log('Clicked Area Code:', selectedAdminCode);  // 행정동 코드 확인
                console.log('Selected Business Code:', selectedBusiness ? selectedBusiness.bb_code : null);  // 선택된 업종 코드 확인

                // 선택된 업종과 행정동 코드를 updateSelectedData 함수로 업데이트
                updateSelectedData(selectedBusiness, selectedAdminCode, area.name);

                // showRegionInfo 함수에 행정동 이름과 행정동 코드, 그리고 선택된 업종 코드를 함께 전달
                showRegionInfo(area.name, selectedAdminCode, selectedBusiness ? selectedBusiness.bb_code : null);

                if (type === "읍면동") {
                    $("#eupMyeonDongSelectedArea").text("선택된 읍면동: " + area.name);
                } else if (type === "시군구") {
                    $("#siGunGuSelectedArea").text("선택된 시군구: " + area.name);
                } else if (type === "시도") {
                    $("#siDoSelectedArea").text("선택된 시도: " + area.name);
                }
                // 클릭 후 이전 확대 레벨을 유지하면서 중심 이동
                map.setCenter(kkoMap.centroid(area.path[0]));
                map.setLevel(previousZoomLevel);  // 이전 확대 레벨로 설정
            });

            polygon.setMap(map);
            polygons.push(polygon);
        },

        centroid: function (path) {
            let sumX = 0, sumY = 0, length = path.length;
            path.forEach(function (coord) {
                sumX += coord.getLng();
                sumY += coord.getLat();
            });
            return new kakao.maps.LatLng(sumY / length, sumX / length);
        },
    };

    $(document).ready(function () {
        initKakaoMap();  // Kakao 지도 초기화
        loadEupMyeonDongData();  // 페이지 로드 시 자동으로 읍면동 경계 데이터 로드
    });

    // 기존 검색된 마커 및 인포윈도우 제거 함수
    function removeSearchMarkers() {
        if (marker) {
            marker.setMap(null);
            marker = null;
        }
        if (infowindow) {
            infowindow.close();
            infowindow = null;
        }
    }

    // 지역 검색 기능 (마커와 인포윈도우 사용)
    $("#eupMyeonDongSearchButton").on("click", function () {
        var searchQuery = $("#eupMyeonDongSearch").val();

        if (!searchQuery) {
            alert("지역명을 입력하세요.");
            return;
        }

        globalSearchedRegion = searchQuery;
        removePolygons();
        loadEupMyeonDongData();

        // Kakao Geocoder를 사용하여 지역 검색
        var geocoder = new kakao.maps.services.Geocoder();
        geocoder.addressSearch(searchQuery, function (results, status) {
            if (status === kakao.maps.services.Status.OK) {
                var result = results[0];
                var coords = new kakao.maps.LatLng(result.y, result.x);

                // 기존 마커 및 인포윈도우 제거
                removeSearchMarkers();

                // 중심 좌표로 이동
                map.setCenter(coords);
                map.setLevel(5);

                // 마커 생성
                marker = new kakao.maps.Marker({
                    position: coords,
                    map: map
                });

                // 인포윈도우 생성
                var infowindowContent = '<div style="padding:5px;">' + result.address_name + '<br><a href="https://map.kakao.com/link/map/' + result.address_name + ',' + result.y + ',' + result.x + '" target="_blank">큰지도보기</a></div>';

                infowindow = new kakao.maps.InfoWindow({
                    content: infowindowContent,
                    removable: true
                });

                // 인포윈도우를 마커에 연결
                infowindow.open(map, marker);
            } else {
                alert("검색된 지역이 없습니다. 다시 시도하세요.");
            }
        });
    });

    var businessData = [];
    var currentPage = 1;
    var resultsPerPage = 10;

    // 초성 변환 함수
    function getChosung(str) {
        const chosungList = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];
        let result = '';
        for (let i = 0; i < str.length; i++) {
            const code = str.charCodeAt(i) - 44032;
            if (code >= 0 && code <= 11171) {
                result += chosungList[Math.floor(code / 588)];
            } else {
                // 한글 자음이 아닌 경우 그대로 반환 (알파벳 등은 그대로 유지)
                result += str[i];
            }
        }
        return result;
    }

    // 검색어가 초성인지 여부를 판별하는 함수
    function isChosungInput(str) {
        return /^[ㄱ-ㅎ]+$/.test(str); // 입력 문자열이 초성만으로 구성된 경우 true 반환
    }

    // 검색 필터 함수
    function filterFunc(item) {
        const searchQuery = $('#businessCategorySearch').val().toLowerCase();

        if (isChosungInput(searchQuery)) {
            // 초성 검색 처리
            const searchQueryChosung = getChosung(searchQuery);
            const businessNameChosung = getChosung(item.bb_name.toLowerCase());

            // 입력된 초성이 포함되고, 정확한 초성 순서로 일치하는 항목만 반환
            return businessNameChosung.includes(searchQueryChosung) && checkExactChosungMatch(searchQuery, item.bb_name);
        } else {
            // 일반 텍스트 검색 처리
            return item.bb_name.toLowerCase().includes(searchQuery);
        }
    }

    // 초성과 실제 단어가 결합된 경우를 정확히 검사하는 함수
    function checkExactChosungMatch(searchQuery, businessName) {
        const searchChosung = getChosung(searchQuery);
        const businessNameChosung = getChosung(businessName);

        // 초성 비교를 위해 한 글자씩 확인
        for (let i = 0, j = 0; i < searchChosung.length && j < businessNameChosung.length; i++, j++) {
            // 만약 현재 비교 위치에서 자음이 동일하지만 모음까지 결합된 경우가 있다면 false 반환
            while (j < businessNameChosung.length && searchChosung[i] !== businessNameChosung[j]) {
                j++;
            }
            if (j >= businessNameChosung.length || searchChosung[i] !== businessNameChosung[j]) {
                return false; // 초성 순서가 다르거나 결합된 자음이 있음
            }
        }
        return true;
    }

    // 검색 결과를 화면에 표시
    function displayResults(filteredResults) {
        $('#searchResults').empty();
        if (filteredResults.length === 0) {
            $('#searchResults').append('<li>검색 결과가 없습니다.</li>');
            return;
        }

        // 모든 결과를 표시하고, 스크롤을 통해 넘길 수 있도록 함
        filteredResults.forEach(function (item) {
            const listItem = $('<li>' + item.bb_name + ' (' + item.bb_code + ')</li>');

            // 마우스 커서 올리면 강조 효과 추가
            listItem.css({
                'padding': '8px',
                'cursor': 'pointer'
            });

            listItem.hover(
                function () { // 마우스가 들어왔을 때
                    $(this).css('background-color', '#FF2C9760');
                },
                function () { // 마우스가 나갔을 때
                    $(this).css('background-color', '');
                }
            );

            // 클릭 이벤트 추가
            listItem.on('click', function () {
                selectedBusiness = item;
                updateSelectedData(selectedBusiness, selectedAdminCode);  // 선택한 업종과 현재 선택된 지역 코드로 함수 호출(추가10.10)
                displaySelectedBusiness();  // 선택된 업종 표시
            });

            $('#searchResults').append(listItem);
        });

        // 스크롤 처리
        $('#searchResults').css({
            'max-height': '200px', // 사이드바 높이에 맞춤
            'overflow-y': 'scroll' // 스크롤 가능하게 설정
        });
    }

    // 선택된 업종을 표시하는 함수
    function displaySelectedBusiness() {
        if (selectedBusiness) {
            $('#selectedBusiness').html('<p>선택된 업종: ' + selectedBusiness.bb_name + ' (' + selectedBusiness.bb_code + ')</p>');
        }
    }

    // 검색 버튼 클릭 시 검색 결과 필터링 및 표시
    $('#businessCategorySearchButton').on('click', function () {
        const searchQuery = $('#businessCategorySearch').val().toLowerCase();

        // 빈 검색어 입력 시 선택된 업종을 비우고 결과 초기화
        if (!searchQuery) {
            $('#searchResults').empty();
            $('#selectedBusiness').empty();
            selectedBusiness = null;  // 선택한 업종 초기화
            return;
        }

        // 필터링된 결과를 화면에 표시
        const filteredResults = businessData.filter(filterFunc);
        displayResults(filteredResults);
    });

    // 키보드 입력 시 자동완성 + 빈 입력란 처리
    $('#businessCategorySearch').on('input', function () {
        const searchQuery = $(this).val().toLowerCase();

        if (!searchQuery) {
            $('#searchResults').empty();
            $('#selectedBusiness').empty();
            selectedBusiness = null;  // 선택한 업종 초기화
            return;
        }

        const filteredResults = businessData.filter(filterFunc);
        displayResults(filteredResults);
    });

    // 데이터 로드
    $.ajax({
        url: '/api/bizone/services/all',  // API 엔드포인트
        method: 'GET',
        success: function (data) {
            console.log("AJAX 데이터 로드 성공:", data);  // 콘솔에 로드된 데이터 출력
            businessData = data;  // 가져온 데이터를 businessData에 저장
            // 첫 페이지에서는 검색창에 입력될 때만 결과를 표시하므로 초기 표시하지 않음

        },
        error: function (xhr, status, error) {
            console.error("Error fetching business data:", error);
        }
    });

    function sample5_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                var addr = data.address;

                document.getElementById("sample5_address").value = addr;

                var geocoder = new kakao.maps.services.Geocoder();
                geocoder.addressSearch(addr, function (results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var result = results[0];
                        var coords = new kakao.maps.LatLng(result.y, result.x);

                        document.getElementById('mapContainer').style.display = "block";
                        map.relayout();
                        map.setCenter(coords);
                        map.setLevel(3);

                        if (marker) {
                            marker.setMap(null);
                        }
                        if (infowindow) {
                            infowindow.close();
                        }

                        marker = new kakao.maps.Marker({
                            position: coords,
                            map: map
                        });

                        var iwContent = '<div style="padding:5px;">' + addr + '<br><a href="https://map.kakao.com/link/map/' + addr + ',' + result.y + ',' + result.x + '" target="_blank"><img src="/resources/image/kakaomap.png" alt="카카오맵" style="width:44px; height:18px; margin-top:5px;"></a></div>';

                        infowindow = new kakao.maps.InfoWindow({
                            content: iwContent,
                            removable: true
                        });

                        infowindow.open(map, marker);
                    }
                });
            }
        }).open();
    }
</script>
</body>
</html>

<%-- 파워랭킹 체크포인트 --%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>상권분석</title>--%>
<%--    <meta charset="UTF-8">--%>

<%--    <!-- jQuery 로드 (필수) -->--%>
<%--    <script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>--%>

<%--    <!-- Popper.js 로드 (Bootstrap 4에서 필수) -->--%>
<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>--%>

<%--    <!-- Bootstrap JavaScript 로드 (jQuery 이후에 로드) -->--%>
<%--    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>--%>

<%--    <!-- Bootstrap CSS -->--%>
<%--    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">--%>

<%--    <!-- Font Awesome 아이콘 CSS (옵션) -->--%>
<%--    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">--%>

<%--    <!-- Chart.js 로드 -->--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>--%>

<%--    <!-- 카카오 맵 및 우편번호 서비스 -->--%>
<%--    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>--%>
<%--    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>--%>

<%--    <style>--%>
<%--        body, html {--%>
<%--            margin: 0;--%>
<%--            padding: 0;--%>
<%--            width: 100%;--%>
<%--            height: 100%;--%>
<%--            background-color: transparent; /* 전체 배경을 투명하게 설정 */--%>
<%--            font-family: 'Noto Sans KR', sans-serif;--%>
<%--        }--%>

<%--        .content {--%>
<%--            display: flex;--%>
<%--            height: 100vh; /* 전체 화면 높이를 유지 */--%>
<%--            background-color: transparent; /* content의 배경을 투명하게 설정 */--%>
<%--            position: relative; /* content를 상대 위치로 설정 */--%>
<%--        }--%>

<%--        #regionModal {--%>
<%--            overflow-y: scroll;--%>
<%--        }--%>

<%--        #sidebar {--%>
<%--            width: 350px; /* 사이드바 너비 설정 */--%>
<%--            background-color: rgba(255, 255, 255, 0); /* 사이드바를 완전히 투명하게 설정 */--%>
<%--            border: none; /* 경계선 제거 */--%>
<%--            padding: 20px 15px;--%>
<%--            border-radius: 12px;--%>
<%--            margin: 20px;--%>
<%--            position: absolute; /* 절대 위치로 설정 */--%>
<%--            z-index: 10; /* z-index를 높여 지도의 위에 배치 */--%>
<%--        }--%>

<%--        #sidebar-content {--%>
<%--            width: 380px; /* 사이드바 너비 설정 */--%>
<%--            background-color: #ffffff; /* 흰색 배경 */--%>
<%--            border-radius: 20px; /* 둥근 모서리 설정 */--%>
<%--            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* 그림자 효과 */--%>
<%--            padding: 30px 25px; /* 내부 여백 설정 */--%>
<%--            margin: 20px;--%>
<%--            position: relative;; /* 사이드바 내용의 배경을 투명하게 설정 */--%>
<%--        }--%>

<%--        #sidebar h1 {--%>
<%--            font-size: 22px;--%>
<%--            font-weight: bold;--%>
<%--            margin-bottom: 20px;--%>
<%--            color: #333;--%>
<%--        }--%>

<%--        .input-container {--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            margin-bottom: 15px;--%>
<%--        }--%>

<%--        .input-container input[type="text"] {--%>
<%--            flex: 1;--%>
<%--            padding: 12px 15px;--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선을 투명하게 설정 */--%>
<%--            border-radius: 6px;--%>
<%--            font-size: 14px;--%>
<%--            margin-right: 10px;--%>
<%--            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 그림자 효과 */--%>
<%--            background-color: rgba(255, 255, 255, 0.2); /* 입력 필드 배경 투명하게 설정 */--%>
<%--            color: #333; /* 텍스트 색상 설정 */--%>
<%--            transition: all 0.3s ease;--%>
<%--        }--%>

<%--        .input-container input[type="text"]:focus {--%>
<%--            border-color: rgba(65, 105, 225, 0.5); /* 포커스 시 테두리 색 변경 */--%>
<%--            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);--%>
<%--            background-color: rgba(255, 255, 255, 0.4); /* 포커스 시 배경 덜 투명하게 */--%>
<%--        }--%>

<%--        .input-container input[type="button"] {--%>
<%--            padding: 12px 15px;--%>
<%--            border: none;--%>
<%--            border-radius: 6px;--%>
<%--            background-color: rgba(65, 105, 225, 0.8); /* 버튼 배경 설정 */--%>
<%--            color: #fff;--%>
<%--            font-size: 14px;--%>
<%--            cursor: pointer;--%>
<%--            transition: background-color 0.3s ease;--%>
<%--        }--%>

<%--        .input-container input[type="button"]:hover {--%>
<%--            background-color: rgba(39, 72, 179, 0.9); /* 마우스 오버 시 배경 덜 투명하게 */--%>
<%--        }--%>

<%--        .select-container select {--%>
<%--            width: 100%;--%>
<%--            padding: 12px;--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선 투명도 설정 */--%>
<%--            border-radius: 6px;--%>
<%--            margin-bottom: 15px;--%>
<%--            font-size: 14px;--%>
<%--            background-color: rgba(255, 255, 255, 0.2); /* 드롭다운 배경 투명하게 설정 */--%>
<%--            color: #333;--%>
<%--            transition: border-color 0.3s ease, box-shadow 0.3s ease;--%>
<%--        }--%>

<%--        #mapContainer {--%>
<%--            flex: 1;--%>
<%--            height: 100vh; /* 전체 화면 높이를 사용 */--%>
<%--            background-color: transparent; /* 지도 컨테이너 배경 투명하게 설정 */--%>
<%--            position: relative;--%>
<%--        }--%>

<%--        #map {--%>
<%--            width: 100%;--%>
<%--            height: 100%;--%>
<%--        }--%>
<%--        .footer {--%>
<%--            display: none; /* 하단 푸터 숨김 처리 */--%>
<%--        }--%>
<%--        #welcomeModal .modal-content {--%>
<%--            border-radius: 12px; /* 모달의 테두리를 둥글게 */--%>
<%--            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 모달에 그림자 효과 추가 */--%>
<%--        }--%>

<%--        #welcomeModal .modal-header {--%>
<%--            border-bottom: 2px solid #17a2b8; /* 모달 헤더 하단 테두리 */--%>
<%--        }--%>

<%--        #welcomeModal .modal-body h6 {--%>
<%--            color: #0056b3; /* 안내 텍스트 색상 */--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="content">--%>
<%--    <div id="sidebar">--%>
<%--        <div id="sidebar-content">--%>
<%--            <h1>상권분석</h1>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="sample5_address" placeholder="주소 찾기" readonly>--%>
<%--                <input type="button" id="search_button" onclick="sample5_execDaumPostcode()" value="주소 찾기">--%>
<%--            </div>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="eupMyeonDongSearch" placeholder="지역 검색">--%>
<%--                <input type="button" id="eupMyeonDongSearchButton" value="지역 검색">--%>
<%--            </div>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="businessCategorySearch" placeholder="업종 검색">--%>
<%--                <input type="button" id="businessCategorySearchButton" value="업종 검색">--%>
<%--            </div>--%>

<%--            <ul id="searchResults"></ul>--%>
<%--            <div id="pagination" style="text-align: center; margin-top: 20px;"></div>--%>
<%--            <div id="selectedBusiness" style="margin-top: 20px;">--%>
<%--                <!-- 선택된 업종이 여기에 표시됩니다. -->--%>
<%--            </div>--%>
<%--            <div class="select-container">--%>
<%--                <select id="locationSelect">--%>
<%--                    <option selected disabled>서울시 구 바로가기</option>--%>
<%--                    <option value="37.5172363,127.0473248">강남구</option>--%>
<%--                    <option value="37.5511,127.1465">강동구</option>--%>
<%--                    <option value="37.6397743,127.0259653">강북구</option>--%>
<%--                    <option value="37.5509787,126.8495384">강서구</option>--%>
<%--                    <option value="37.4784064,126.9516133">관악구</option>--%>
<%--                    <option value="37.5384841,127.0822934">광진구</option>--%>
<%--                    <option value="37.4954856,126.8877243">구로구</option>--%>
<%--                    <option value="37.4568502,126.8958117">금천구</option>--%>
<%--                    <option value="37.6541916,127.0567936">노원구</option>--%>
<%--                    <option value="37.6686912,127.0472104">도봉구</option>--%>
<%--                    <option value="37.5742915,127.0395685">동대문구</option>--%>
<%--                    <option value="37.5124095,126.9395078">동작구</option>--%>
<%--                    <option value="37.5663244,126.9014017">마포구</option>--%>
<%--                    <option value="37.5791433,126.9369178">서대문구</option>--%>
<%--                    <option value="37.4836042,127.0327595">서초구</option>--%>
<%--                    <option value="37.5632561,127.0364285">성동구</option>--%>
<%--                    <option value="37.5893624,127.0167415">성북구</option>--%>
<%--                    <option value="37.5145436,127.1059163">송파구</option>--%>
<%--                    <option value="37.5270616,126.8561536">양천구</option>--%>
<%--                    <option value="37.5263614,126.8966016">영등포구</option>--%>
<%--                    <option value="37.5322958,126.9904348">용산구</option>--%>
<%--                    <option value="37.6026956,126.9291993">은평구</option>--%>
<%--                    <option value="37.573293,126.979672">종로구</option>--%>
<%--                    <option value="37.5636152,126.9979403">중구</option>--%>
<%--                    <option value="37.6063241,127.092728">중랑구</option>--%>
<%--                </select>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div id="mapContainer">--%>
<%--        <div id="map"></div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 모달 창 (regionModal) -->--%>
<%--<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 모달 헤더 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-header bg-primary text-white">--%>
<%--                <h5 class="modal-title" id="regionModalLabel"><i class="fas fa-chart-area"></i> 지역 상권 분석</h5>--%>
<%--            </div>--%>

<%--            <!-- 모달 바디 시작 -->--%>
<%--            <div class="modal-body" id="modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <div class="row">--%>
<%--                        <!-- 지역명 및 차트 -->--%>
<%--                        <div class="col-md-12 mb-4">--%>
<%--                            <h5 class="text-center font-weight-bold" id="regionName">지역명</h5>--%>
<%--                            <canvas id="regionChart" style="max-width: 100%;"></canvas>--%>
<%--                        </div>--%>

<%--                        <!-- 선택된 업종 정보 -->--%>
<%--                        <div class="col-md-12">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body bg-light">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-store"></i> 선택된 업종: <span id="selectedBusinessModal" class="text-primary">정보 없음</span></h6>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <!-- 성공 확률 정보 -->--%>
<%--                        <div class="col-md-6">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-percentage"></i> 성공 확률:</h6>--%>
<%--                                    <span id="successProbability" class="display-4 text-success font-weight-bold">정보 없음</span>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <!-- 파워랭킹 -->--%>
<%--                        <div class="col-md-6">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-check-circle"></i> 파워랭킹:</h6>--%>
<%--                                    <span id="rank" class="display-4 text-info font-weight-bold">정보 없음</span>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!-- 모달 바디 끝 -->--%>

<%--            <!-- 모달 푸터 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="detailbtn" class="btn btn-primary btn-lg w-100"><i class="fas fa-info-circle"></i> 데이터 자세히 보기</button>--%>
<%--            </div>--%>

<%--            <!-- 첫 번째 모달의 확인 버튼 -->--%>
<%--            <button id="closeRegionModal" class="btn btn-primary"><i class="fas fa-check-circle"></i> 확인</button>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 두 번째 모달 창 (detailedModal) -->--%>
<%--<div class="modal fade" id="detailedModal" tabindex="-1" role="dialog" aria-labelledby="detailedModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 모달 헤더 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-header bg-info text-white">--%>
<%--                <h5 class="modal-title" id="detailedModalLabel"><i class="fas fa-info-circle"></i> 상세 정보 보기</h5>--%>
<%--            </div>--%>

<%--            <!-- 모달 바디 -->--%>
<%--            <div class="modal-body" id="detailed-modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <!-- 업종 및 지역 정보 -->--%>
<%--                    <div class="card mb-4">--%>
<%--                        <div class="card-body bg-light">--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-briefcase"></i> 업종: <span id="detailedBusinessName" class="text-primary">정보 없음</span></h6>--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-map-marker-alt"></i> 지역: <span id="detailedRegionName" class="text-primary">정보 없음</span></h6>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <!-- 상세 데이터 리스트 -->--%>
<%--                    <ul class="list-group">--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-users"> 총 거주 인구: <span id="totalResidentPopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-building"> 총 직장 인구: <span id="totalWorkplacePopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-chart-line"> 총 유동 인구: <span id="totalFloatingPopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-hotel"> 집객시설 수: <span id="attractionCount"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-dollar-sign"> 평균 월 소득: <span id="avgMonthlyIncome"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-coins"> 총 지출 금액: <span id="totalExpenditure"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-home"> 평균 임대료: <span id="avgRentFee"></span></i>--%>
<%--                        </li>--%>
<%--                    </ul>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- 모달 푸터 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="closeDetailedModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- JavaScript -->--%>
<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        // 첫 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--        $('#closeRegionModal').on('click', function () {--%>
<%--            $('#regionModal').modal('hide'); // regionModal 닫기--%>
<%--        });--%>

<%--    });--%>

<%--    $(document).ready(function () {--%>
<%--        // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--        $('#closeDetailedModal').on('click', function () {--%>
<%--            $('#detailedModal').modal('hide'); // detailedModal 닫기--%>
<%--        });--%>

<%--    });--%>

<%--</script>--%>

<%--<!-- 페이지 첫 접속 시 보여줄 안내 팝업 -->--%>
<%--<div class="modal fade" id="popupModal" tabindex="-1" role="dialog" aria-labelledby="welcomeModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 팝업 헤더 -->--%>
<%--            <div class="modal-header bg-info text-white">--%>
<%--                <h5 class="modal-title" id="welcomeModalLabel"><i class="fas fa-info-circle"></i> 상권 분석 시스템 안내</h5>--%>
<%--            </div>--%>

<%--            <!-- 팝업 바디 -->--%>
<%--            <div class="modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <!-- 안내 내용 구성 -->--%>
<%--                    <div class="card mb-4">--%>
<%--                        <div class="card-body bg-light">--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-lightbulb"></i> 상권 분석 시스템에 오신 것을 환영합니다!</h6>--%>
<%--                            <p>--%>
<%--                                이 시스템을 통해 지역별 상권 분석, 업종 선택 및 분석, 상세 데이터를 확인할 수 있습니다.--%>
<%--                                <br><br>--%>
<%--                                <strong>간단 분석 방법 안내:</strong>--%>
<%--                            <ol>--%>
<%--                                <li>분석할 지역 및 업종을 선택합니다.</li>--%>
<%--                                <li>분석하기 버튼을 클릭하여 결과를 확인합니다.</li>--%>
<%--                                <li>결과를 확인 후, 상세 데이터 보기 버튼을 통해 더 많은 정보를 얻을 수 있습니다.</li>--%>
<%--                            </ol>--%>
<%--                            </p>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- 팝업 푸터 (닫기 버튼) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="closePopupModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 메인홈페이지에서 설명 팝업창 -->--%>
<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        // 페이지가 로드되면 자동으로 팝업을 띄우는 함수--%>
<%--        $('#popupModal').modal('show');  // Bootstrap 모달 표시--%>

<%--    });--%>

<%--    $(document).ready(function () {--%>
<%--        // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--        $('#closePopupModal').on('click', function () {--%>
<%--            $('#popupModal').modal('hide'); // detailedModal 닫기--%>
<%--        });--%>

<%--    });--%>
<%--</script>--%>

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    let globalRegionName = '';  // 전역 변수 선언--%>
<%--    let globalSearchedRegion = "";--%>

<%--    function initKakaoMap() {--%>
<%--        var container = document.getElementById('map');--%>
<%--        var options = {--%>
<%--            center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울중심좌표--%>
<%--            level: 7,--%>
<%--        };--%>
<%--        map = new kakao.maps.Map(container, options);--%>
<%--        customOverlay = new kakao.maps.CustomOverlay({});--%>

<%--        var previousZoomLevel = map.getLevel();--%>

<%--        // 범위 설정--%>
<%--        var bounds = new kakao.maps.LatLngBounds(--%>
<%--            new kakao.maps.LatLng(37.4300, 126.8000), // 남서쪽 좌표--%>
<%--            new kakao.maps.LatLng(37.6800, 127.1000)  // 북동쪽 좌표--%>
<%--        );--%>

<%--        // 지도의 이동을 서울시 범위로 제한--%>
<%--        kakao.maps.event.addListener(map, 'center_changed', function () {--%>
<%--            if (!bounds.contain(map.getCenter())) {--%>
<%--                // 현재 지도 중심이 서울시 범위를 벗어난 경우--%>
<%--                var currentCenter = map.getCenter();--%>

<%--                // 지도 중심이 서울시 범위 바깥으로 나갔을 때의 제한 처리--%>
<%--                var newCenter = new kakao.maps.LatLng(--%>
<%--                    Math.min(Math.max(currentCenter.getLat(), bounds.getSouthWest().getLat()), bounds.getNorthEast().getLat()),--%>
<%--                    Math.min(Math.max(currentCenter.getLng(), bounds.getSouthWest().getLng()), bounds.getNorthEast().getLng())--%>
<%--                );--%>

<%--                map.setCenter(newCenter); // 지도 중심을 서울시 범위 내로 고정--%>
<%--            }--%>
<%--        });--%>

<%--        // 확대/축소 레벨 제한--%>
<%--        map.setMinLevel(3);--%>
<%--        map.setMaxLevel(10);--%>

<%--        // 서울시 구 선택 시 해당 구로 지도 이동--%>
<%--        $("#locationSelect").on("change", function () {--%>
<%--            if (map) {--%>
<%--                var coords = $(this).val().split(',');--%>
<%--                var latLng = new kakao.maps.LatLng(coords[0], coords[1]);--%>
<%--                map.setCenter(latLng);--%>
<%--                map.setLevel(8);--%>
<%--            }--%>
<%--        });--%>

<%--        // 지도 레벨 변경에 따른 경계 데이터 처리--%>
<%--        kakao.maps.event.addListener(map, 'zoom_changed', function () {--%>
<%--            var level = map.getLevel();--%>
<%--            console.log('Current zoom level:', level);--%>

<%--            // 확대/축소에 따른 경계 데이터 전환--%>
<%--            if (level <= 7) {--%>
<%--                if (!isEupMyeonDongLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadEupMyeonDongData();--%>
<%--                }--%>
<%--            } else if (level > 7 && level <= 9) {--%>
<%--                if (!isSiGunGuLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadSiGunGuData();--%>
<%--                }--%>
<%--            } else if (level > 9) {--%>
<%--                if (!isSiDoLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadSiDoData();--%>
<%--                }--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    let chartInstance = null;--%>

<%--    // 지역 및 업종을 클릭했을 때 호출되는 함수--%>
<%--    function showRegionInfo(regionName, adminCode, serviceCode) {--%>
<%--        updateSelectedData({ bb_code: serviceCode }, adminCode); // 추가--%>
<%--        $.ajax({--%>
<%--            url: `/api/bizone/getChartDataForDetail`,--%>
<%--            method: 'GET',--%>
<%--            data: {--%>
<%--                admin_code: adminCode,  // 행정동 코드--%>
<%--                service_code: serviceCode  // 서비스 코드--%>
<%--            },--%>
<%--            success: function (data) {--%>
<%--                console.log('Received Data for Chart:', data);--%>

<%--                // 모달 창 업데이트 코드--%>
<%--                $('#regionName').text(regionName + " 상권분석");--%>
<%--                $('#selectedBusinessModal').text(selectedBusiness ? selectedBusiness.bb_name : '정보 없음');--%>

<%--                // 두 번째 모달 창 업데이트 코드 추가--%>
<%--                $('#detailedRegionName').text(globalRegionName || adminCode);  // 전역 변수 사용--%>

<%--                const chartData = {--%>
<%--                    labels: ['평균 임대료', '총 직장인구수', '총 지출 금액', '집객시설 수', '평균 월 매출', '기타'],--%>
<%--                    datasets: [{--%>
<%--                        label: '상권분석 데이터',--%>
<%--                        data: [--%>
<%--                            data.avgRentFeeScore.toFixed(2),--%>
<%--                            data.totalWorkplacePopulationScore.toFixed(2),--%>
<%--                            data.totalExpenditureScore.toFixed(2),--%>
<%--                            data.attractionCountScore.toFixed(2),--%>
<%--                            data.avgMonthlySalesScore.toFixed(2),--%>
<%--                            data.otherScoresTotal.toFixed(2)--%>
<%--                        ],--%>
<%--                        backgroundColor: 'rgba(54, 162, 235, 0.6)',--%>
<%--                        borderColor: 'rgba(54, 162, 235, 1)',--%>
<%--                        borderWidth: 1--%>
<%--                    }]--%>
<%--                };--%>

<%--                if (chartInstance) {--%>
<%--                    chartInstance.destroy();--%>
<%--                }--%>

<%--                const ctx = document.getElementById('regionChart').getContext('2d');--%>
<%--                chartInstance = new Chart(ctx, {--%>
<%--                    type: 'bar',--%>
<%--                    data: chartData,--%>
<%--                    options: {--%>
<%--                        scales: {--%>
<%--                            y: {--%>
<%--                                beginAtZero: true,--%>
<%--                                max: 8  // y값 최대치 정하기--%>
<%--                            }--%>
<%--                        }--%>
<%--                    }--%>
<%--                });--%>

<%--                const successProbability = parseFloat(data.successProbability).toFixed(2);--%>
<%--                $('#successProbability').text(successProbability);--%>

<%--                $('#regionModal').modal('show');--%>
<%--            },--%>
<%--            error: function () {--%>
<%--                alert("지역 및 업종 데이터를 불러오는 중 오류가 발생했습니다.");--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    let selectedServiceCode = null;--%>
<%--    let selectedAdminCode = null;--%>

<%--    // 업종과 지역 선택 시 데이터를 설정하는 함수--%>
<%--    function updateSelectedData(business, areaCode, areaName) {--%>
<%--        selectedServiceCode = business ? business.bb_code : null;--%>
<%--        selectedServiceName = business ? business.bb_name : '정보 없음'; // 업종명 저장--%>
<%--        selectedAdminCode = areaCode;--%>
<%--        selectedAdminName = areaName || '정보 없음'; // 지역명 저장--%>
<%--        console.log('Selected data updated:', selectedServiceCode, selectedAdminCode, selectedServiceName, selectedAdminName);--%>
<%--    }--%>

<%--    // 자세히 보기 버튼 클릭 이벤트 핸들러--%>
<%--    $('#detailbtn').on('click', function () {--%>
<%--        console.log('Before sending request, selectedServiceCode:', selectedServiceCode, 'selectedAdminCode:', selectedAdminCode);--%>

<%--        if (selectedServiceCode && selectedAdminCode) {--%>
<%--            // 지역명을 가져오는 AJAX 요청 추가--%>
<%--            $.ajax({--%>
<%--                url: `/api/bizone/getRegionName`,--%>
<%--                method: 'GET',--%>
<%--                data: { admin_code: selectedAdminCode },--%>
<%--                success: function (regionName) {--%>
<%--                    console.log("in getRegionName")--%>
<%--                    console.log(regionName)--%>
<%--                    $('#detailedRegionName').text(globalRegionName); // 지역명 업데이트--%>
<%--                },--%>
<%--                error: function () {--%>
<%--                    $('#detailedRegionName').text(selectedAdminCode); // 오류 발생 시 코드 표시--%>
<%--                }--%>
<%--            });--%>

<%--            $.ajax({--%>
<%--                url: `/api/bizone/getDetailData`,--%>
<%--                method: 'GET',--%>
<%--                data: {--%>
<%--                    admin_code: selectedAdminCode,--%>
<%--                    service_code: selectedServiceCode--%>
<%--                },--%>
<%--                success: function (data) {--%>
<%--                    console.log('Detailed data received:', data);--%>

<%--                    // 모달 창에 데이터를 표시하는 로직--%>
<%--                    $('#detailedBusinessName').text(selectedBusiness.bb_name || selectedServiceCode);--%>
<%--                    $('#totalResidentPopulation').text(data.totalResidentPopulation.toLocaleString() + "명");--%>
<%--                    $('#totalWorkplacePopulation').text(data.totalWorkplacePopulation.toLocaleString() + "명");--%>
<%--                    $('#totalFloatingPopulation').text(data.totalFloatingPopulation.toLocaleString() + "명");--%>
<%--                    $('#attractionCount').text(data.attractionCount.toLocaleString() + "개");--%>
<%--                    $('#avgMonthlyIncome').text(data.avgMonthlyIncome.toLocaleString() + "원");--%>
<%--                    $('#totalExpenditure').text(data.totalExpenditure.toLocaleString() + "원");--%>
<%--                    $('#avgRentFee').text(data.avgRentFee.toLocaleString() + "원");--%>
<%--                    $('#detailedModal').modal('show');--%>
<%--                },--%>
<%--                error: function (xhr, status, error) {--%>
<%--                    console.error('Error fetching detailed data:', error);--%>
<%--                    alert('자세한 데이터를 불러오는 중 오류가 발생했습니다.');--%>
<%--                }--%>
<%--            });--%>
<%--        } else {--%>
<%--            console.warn("업종과 지역 정보가 누락되었습니다.");--%>
<%--            alert("업종과 지역을 선택해주세요.");--%>
<%--        }--%>
<%--    });--%>

<%--    // GeoJSON 데이터를 불러와 경계선을 그리는 함수--%>
<%--    function loadGeoJson(url, type) {--%>
<%--        $.getJSON(url, function (data) {--%>
<%--            data.features.forEach(function (feature) {--%>
<%--                var path = feature.geometry.coordinates[0].map(function (coord) {--%>
<%--                    return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                });--%>

<%--                var polygon = new kakao.maps.Polygon({--%>
<%--                    map: map,--%>
<%--                    path: path,--%>
<%--                    fillColor: "rgba(30, 144, 255, 0.1)",--%>
<%--                    strokeColor: "#104486",--%>
<%--                    strokeWeight: 2,--%>
<%--                });--%>

<%--                kakao.maps.event.addListener(polygon, 'click', function () {--%>
<%--                    if (isBoundaryLoaded) {  // 경계 데이터가 켜져 있을 때만 실행--%>
<%--                        var regionName = feature.properties.adm_nm ?? feature.properties.sggnm;--%>
<%--                        showRegionInfo(regionName);  // 지역 이름 전달--%>
<%--                    }--%>
<%--                });--%>

<%--                polygons.push(polygon);--%>
<%--            });--%>
<%--        });--%>
<%--    }--%>

<%--    function loadSiDoData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulSi.geojson",  // 시도 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "시도");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulSi GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function loadSiGunGuData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulGu.geojson",  // 서울 구 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "시군구");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulGu GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function loadEupMyeonDongData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulDong.geojson",  // 서울 동 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "읍면동");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulDong GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function removePolygons() {--%>
<%--        polygons.forEach(function (polygon) {--%>
<%--            polygon.setMap(null);--%>
<%--        });--%>
<%--        polygons = [];--%>

<%--        // 남아있는 overlaybox 제거--%>
<%--        if (customOverlay) {--%>
<%--            customOverlay.setMap(null);--%>
<%--        }--%>
<%--    }--%>

<%--    var kkoMap = {--%>
<%--        loadGeoJson: function (geoJsonData, type) {--%>
<%--            var fillColor, strokeColor;--%>
<%--            if (type === "읍면동") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)";--%>
<%--                strokeColor = "#104486";--%>
<%--            } else if (type === "시군구") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)";--%>
<%--                strokeColor = "#163599";--%>
<%--            } else if (type === "시도") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)"--%>
<%--                strokeColor = "#101e4e";--%>
<%--            }--%>

<%--            geoJsonData.features.forEach(function (feature) {--%>
<%--                if (type !== "시도") {--%>

<%--                    if (feature.properties.adm_nm?.split(" ").includes(globalSearchedRegion)) {--%>
<%--                        kkoMap.setPolygon(kkoMap.getPolygonData(feature), "pink", strokeColor, type);--%>
<%--                    } else {--%>
<%--                        if (feature.properties.sggnm.split(" ").includes(globalSearchedRegion)) {--%>
<%--                            kkoMap.setPolygon(kkoMap.getPolygonData(feature), "hotpink", strokeColor, type)--%>
<%--                        } else {--%>
<%--                            kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);--%>
<%--                        }--%>
<%--                    }--%>
<%--                } else {--%>
<%--                    kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);--%>
<%--                }--%>
<%--            });--%>


<%--        },--%>

<%--        getPolygonData: function (feature) {--%>
<%--            var path = [];--%>
<%--            feature.geometry.coordinates.forEach(function (coords) {--%>
<%--                coords.forEach(function (innerCoords) {  // 다차원 좌표 처리--%>
<%--                    path.push(innerCoords.map(function (coord) {--%>
<%--                        return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                    }));--%>
<%--                });--%>
<%--            });--%>
<%--            return {--%>
<%--                code: feature.properties.adm_cd2,--%>
<%--                name: feature.properties.adm_nm ?? feature.properties.sggnm ?? feature.properties.sidonm,--%>
<%--                path: path--%>
<%--            };--%>
<%--        },--%>

<%--        setPolygon: function (area, fillColor, strokeColor, type) {--%>
<%--            var polygon = new kakao.maps.Polygon({--%>
<%--                path: area.path,--%>
<%--                strokeWeight: 2,--%>
<%--                strokeColor: strokeColor,--%>
<%--                strokeOpacity: 0.8,--%>
<%--                fillColor: fillColor,--%>
<%--                fillOpacity: fillColor === "hotpink" ? 0.7 : 0.3,--%>
<%--            });--%>

<%--            let isMouseOver = false;--%>

<%--            kakao.maps.event.addListener(polygon, "mouseover", function () {--%>
<%--                if (!isMouseOver) {--%>
<%--                    isMouseOver = true;--%>
<%--                    polygon.setOptions({fillColor: type === "읍면동" ? "#0D94E8" : "#0031FD"});--%>
<%--                    customOverlay.setContent("<div class='overlaybox'>" + area.name + "</div>");--%>
<%--                    customOverlay.setMap(map);--%>
<%--                }--%>
<%--            });--%>

<%--            kakao.maps.event.addListener(polygon, "mousemove", function (mouseEvent) {--%>
<%--                if (isMouseOver) {--%>
<%--                    const offsetX = 35;--%>
<%--                    const offsetY = 35;--%>
<%--                    const projection = map.getProjection();--%>
<%--                    const point = projection.pointFromCoords(mouseEvent.latLng);--%>
<%--                    point.x += offsetX;--%>
<%--                    point.y += offsetY;--%>
<%--                    const newPosition = projection.coordsFromPoint(point);--%>
<%--                    customOverlay.setPosition(newPosition);--%>
<%--                }--%>
<%--            });--%>

<%--            kakao.maps.event.addListener(polygon, "mouseout", function () {--%>
<%--                if (isMouseOver) {--%>
<%--                    isMouseOver = false;--%>
<%--                    polygon.setOptions({fillColor: fillColor});--%>
<%--                    customOverlay.setMap(null);--%>
<%--                }--%>
<%--            });--%>

<%--            // 지역(폴리곤)을 클릭할 때 updateSelectedData 호출--%>
<%--            kakao.maps.event.addListener(polygon, "click", function () {--%>
<%--                console.log('Polygon Clicked:', area.name); // 클릭된 폴리곤 정보 확인--%>

<%--                if (!selectedBusiness || !selectedBusiness.bb_code) {--%>
<%--                    console.log('alert확인용 코드'); // 로그 추가--%>
<%--                    alert("업종을 선택해주세요.");--%>
<%--                    return; // 업종이 선택되지 않았으면 함수 종료--%>
<%--                }--%>

<%--                previousZoomLevel = map.getLevel(); // 클릭 시 현재 지도 레벨 저장--%>
<%--                selectedAdminCode = area.code; // 클릭한 지역의 행정동 코드 업데이트--%>
<%--                globalRegionName = area.name;--%>

<%--                console.log('Clicked Area Code:', selectedAdminCode);  // 행정동 코드 확인--%>
<%--                console.log('Selected Business Code:', selectedBusiness ? selectedBusiness.bb_code : null);  // 선택된 업종 코드 확인--%>

<%--                // 선택된 업종과 행정동 코드를 updateSelectedData 함수로 업데이트--%>
<%--                updateSelectedData(selectedBusiness, selectedAdminCode, area.name);--%>

<%--                // showRegionInfo 함수에 행정동 이름과 행정동 코드, 그리고 선택된 업종 코드를 함께 전달--%>
<%--                showRegionInfo(area.name, selectedAdminCode, selectedBusiness ? selectedBusiness.bb_code : null);--%>

<%--                if (type === "읍면동") {--%>
<%--                    $("#eupMyeonDongSelectedArea").text("선택된 읍면동: " + area.name);--%>
<%--                } else if (type === "시군구") {--%>
<%--                    $("#siGunGuSelectedArea").text("선택된 시군구: " + area.name);--%>
<%--                } else if (type === "시도") {--%>
<%--                    $("#siDoSelectedArea").text("선택된 시도: " + area.name);--%>
<%--                }--%>
<%--                // 클릭 후 이전 확대 레벨을 유지하면서 중심 이동--%>
<%--                map.setCenter(kkoMap.centroid(area.path[0]));--%>
<%--                map.setLevel(previousZoomLevel);  // 이전 확대 레벨로 설정--%>
<%--            });--%>

<%--            polygon.setMap(map);--%>
<%--            polygons.push(polygon);--%>
<%--        },--%>

<%--        centroid: function (path) {--%>
<%--            let sumX = 0, sumY = 0, length = path.length;--%>
<%--            path.forEach(function (coord) {--%>
<%--                sumX += coord.getLng();--%>
<%--                sumY += coord.getLat();--%>
<%--            });--%>
<%--            return new kakao.maps.LatLng(sumY / length, sumX / length);--%>
<%--        },--%>
<%--    };--%>

<%--    $(document).ready(function () {--%>
<%--        initKakaoMap();  // Kakao 지도 초기화--%>
<%--        loadEupMyeonDongData();  // 페이지 로드 시 자동으로 읍면동 경계 데이터 로드--%>
<%--    });--%>

<%--    // 기존 검색된 마커 및 인포윈도우 제거 함수--%>
<%--    function removeSearchMarkers() {--%>
<%--        if (marker) {--%>
<%--            marker.setMap(null);--%>
<%--            marker = null;--%>
<%--        }--%>
<%--        if (infowindow) {--%>
<%--            infowindow.close();--%>
<%--            infowindow = null;--%>
<%--        }--%>
<%--    }--%>

<%--    // 지역 검색 기능 (마커와 인포윈도우 사용)--%>
<%--    $("#eupMyeonDongSearchButton").on("click", function () {--%>
<%--        var searchQuery = $("#eupMyeonDongSearch").val();--%>

<%--        if (!searchQuery) {--%>
<%--            alert("지역명을 입력하세요.");--%>
<%--            return;--%>
<%--        }--%>

<%--        globalSearchedRegion = searchQuery;--%>
<%--        removePolygons();--%>
<%--        loadEupMyeonDongData();--%>

<%--        // Kakao Geocoder를 사용하여 지역 검색--%>
<%--        var geocoder = new kakao.maps.services.Geocoder();--%>
<%--        geocoder.addressSearch(searchQuery, function (results, status) {--%>
<%--            if (status === kakao.maps.services.Status.OK) {--%>
<%--                var result = results[0];--%>
<%--                var coords = new kakao.maps.LatLng(result.y, result.x);--%>

<%--                // 기존 마커 및 인포윈도우 제거--%>
<%--                removeSearchMarkers();--%>

<%--                // 중심 좌표로 이동--%>
<%--                map.setCenter(coords);--%>
<%--                map.setLevel(5);--%>

<%--                // 마커 생성--%>
<%--                marker = new kakao.maps.Marker({--%>
<%--                    position: coords,--%>
<%--                    map: map--%>
<%--                });--%>

<%--                // 인포윈도우 생성--%>
<%--                var infowindowContent = '<div style="padding:5px;">' + result.address_name + '<br><a href="https://map.kakao.com/link/map/' + result.address_name + ',' + result.y + ',' + result.x + '" target="_blank">큰지도보기</a></div>';--%>

<%--                infowindow = new kakao.maps.InfoWindow({--%>
<%--                    content: infowindowContent,--%>
<%--                    removable: true--%>
<%--                });--%>

<%--                // 인포윈도우를 마커에 연결--%>
<%--                infowindow.open(map, marker);--%>
<%--            } else {--%>
<%--                alert("검색된 지역이 없습니다. 다시 시도하세요.");--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>

<%--    var businessData = [];--%>
<%--    var currentPage = 1;--%>
<%--    var resultsPerPage = 10;--%>

<%--    // 초성 변환 함수--%>
<%--    function getChosung(str) {--%>
<%--        const chosungList = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];--%>
<%--        let result = '';--%>
<%--        for (let i = 0; i < str.length; i++) {--%>
<%--            const code = str.charCodeAt(i) - 44032;--%>
<%--            if (code >= 0 && code <= 11171) {--%>
<%--                result += chosungList[Math.floor(code / 588)];--%>
<%--            } else {--%>
<%--                // 한글 자음이 아닌 경우 그대로 반환 (알파벳 등은 그대로 유지)--%>
<%--                result += str[i];--%>
<%--            }--%>
<%--        }--%>
<%--        return result;--%>
<%--    }--%>

<%--    // 검색어가 초성인지 여부를 판별하는 함수--%>
<%--    function isChosungInput(str) {--%>
<%--        return /^[ㄱ-ㅎ]+$/.test(str); // 입력 문자열이 초성만으로 구성된 경우 true 반환--%>
<%--    }--%>

<%--    // 검색 필터 함수--%>
<%--    function filterFunc(item) {--%>
<%--        const searchQuery = $('#businessCategorySearch').val().toLowerCase();--%>

<%--        if (isChosungInput(searchQuery)) {--%>
<%--            // 초성 검색 처리--%>
<%--            const searchQueryChosung = getChosung(searchQuery);--%>
<%--            const businessNameChosung = getChosung(item.bb_name.toLowerCase());--%>

<%--            // 입력된 초성이 포함되고, 정확한 초성 순서로 일치하는 항목만 반환--%>
<%--            return businessNameChosung.includes(searchQueryChosung) && checkExactChosungMatch(searchQuery, item.bb_name);--%>
<%--        } else {--%>
<%--            // 일반 텍스트 검색 처리--%>
<%--            return item.bb_name.toLowerCase().includes(searchQuery);--%>
<%--        }--%>
<%--    }--%>

<%--    // 초성과 실제 단어가 결합된 경우를 정확히 검사하는 함수--%>
<%--    function checkExactChosungMatch(searchQuery, businessName) {--%>
<%--        const searchChosung = getChosung(searchQuery);--%>
<%--        const businessNameChosung = getChosung(businessName);--%>

<%--        // 초성 비교를 위해 한 글자씩 확인--%>
<%--        for (let i = 0, j = 0; i < searchChosung.length && j < businessNameChosung.length; i++, j++) {--%>
<%--            // 만약 현재 비교 위치에서 자음이 동일하지만 모음까지 결합된 경우가 있다면 false 반환--%>
<%--            while (j < businessNameChosung.length && searchChosung[i] !== businessNameChosung[j]) {--%>
<%--                j++;--%>
<%--            }--%>
<%--            if (j >= businessNameChosung.length || searchChosung[i] !== businessNameChosung[j]) {--%>
<%--                return false; // 초성 순서가 다르거나 결합된 자음이 있음--%>
<%--            }--%>
<%--        }--%>
<%--        return true;--%>
<%--    }--%>

<%--    // 검색 결과를 화면에 표시--%>
<%--    function displayResults(filteredResults) {--%>
<%--        $('#searchResults').empty();--%>
<%--        if (filteredResults.length === 0) {--%>
<%--            $('#searchResults').append('<li>검색 결과가 없습니다.</li>');--%>
<%--            return;--%>
<%--        }--%>

<%--        // 모든 결과를 표시하고, 스크롤을 통해 넘길 수 있도록 함--%>
<%--        filteredResults.forEach(function (item) {--%>
<%--            const listItem = $('<li>' + item.bb_name + ' (' + item.bb_code + ')</li>');--%>

<%--            // 마우스 커서 올리면 강조 효과 추가--%>
<%--            listItem.css({--%>
<%--                'padding': '8px',--%>
<%--                'cursor': 'pointer'--%>
<%--            });--%>

<%--            listItem.hover(--%>
<%--                function () { // 마우스가 들어왔을 때--%>
<%--                    $(this).css('background-color', '#FF2C9760');--%>
<%--                },--%>
<%--                function () { // 마우스가 나갔을 때--%>
<%--                    $(this).css('background-color', '');--%>
<%--                }--%>
<%--            );--%>

<%--            // 클릭 이벤트 추가--%>
<%--            listItem.on('click', function () {--%>
<%--                selectedBusiness = item;--%>
<%--                updateSelectedData(selectedBusiness, selectedAdminCode);  // 선택한 업종과 현재 선택된 지역 코드로 함수 호출(추가10.10)--%>
<%--                displaySelectedBusiness();  // 선택된 업종 표시--%>
<%--            });--%>

<%--            $('#searchResults').append(listItem);--%>
<%--        });--%>

<%--        // 스크롤 처리--%>
<%--        $('#searchResults').css({--%>
<%--            'max-height': '200px', // 사이드바 높이에 맞춤--%>
<%--            'overflow-y': 'scroll' // 스크롤 가능하게 설정--%>
<%--        });--%>
<%--    }--%>

<%--    // 선택된 업종을 표시하는 함수--%>
<%--    function displaySelectedBusiness() {--%>
<%--        if (selectedBusiness) {--%>
<%--            $('#selectedBusiness').html('<p>선택된 업종: ' + selectedBusiness.bb_name + ' (' + selectedBusiness.bb_code + ')</p>');--%>
<%--        }--%>
<%--    }--%>

<%--    // 검색 버튼 클릭 시 검색 결과 필터링 및 표시--%>
<%--    $('#businessCategorySearchButton').on('click', function () {--%>
<%--        const searchQuery = $('#businessCategorySearch').val().toLowerCase();--%>

<%--        // 빈 검색어 입력 시 선택된 업종을 비우고 결과 초기화--%>
<%--        if (!searchQuery) {--%>
<%--            $('#searchResults').empty();--%>
<%--            $('#selectedBusiness').empty();--%>
<%--            selectedBusiness = null;  // 선택한 업종 초기화--%>
<%--            return;--%>
<%--        }--%>

<%--        // 필터링된 결과를 화면에 표시--%>
<%--        const filteredResults = businessData.filter(filterFunc);--%>
<%--        displayResults(filteredResults);--%>
<%--    });--%>

<%--    // 키보드 입력 시 자동완성 + 빈 입력란 처리--%>
<%--    $('#businessCategorySearch').on('input', function () {--%>
<%--        const searchQuery = $(this).val().toLowerCase();--%>

<%--        if (!searchQuery) {--%>
<%--            $('#searchResults').empty();--%>
<%--            $('#selectedBusiness').empty();--%>
<%--            selectedBusiness = null;  // 선택한 업종 초기화--%>
<%--            return;--%>
<%--        }--%>

<%--        const filteredResults = businessData.filter(filterFunc);--%>
<%--        displayResults(filteredResults);--%>
<%--    });--%>

<%--    // 데이터 로드--%>
<%--    $.ajax({--%>
<%--        url: '/api/bizone/services/all',  // API 엔드포인트--%>
<%--        method: 'GET',--%>
<%--        success: function (data) {--%>
<%--            console.log("AJAX 데이터 로드 성공:", data);  // 콘솔에 로드된 데이터 출력--%>
<%--            businessData = data;  // 가져온 데이터를 businessData에 저장--%>
<%--            // 첫 페이지에서는 검색창에 입력될 때만 결과를 표시하므로 초기 표시하지 않음--%>

<%--        },--%>
<%--        error: function (xhr, status, error) {--%>
<%--            console.error("Error fetching business data:", error);--%>
<%--        }--%>
<%--    });--%>

<%--    function sample5_execDaumPostcode() {--%>
<%--        new daum.Postcode({--%>
<%--            oncomplete: function (data) {--%>
<%--                var addr = data.address;--%>

<%--                document.getElementById("sample5_address").value = addr;--%>

<%--                var geocoder = new kakao.maps.services.Geocoder();--%>
<%--                geocoder.addressSearch(addr, function (results, status) {--%>
<%--                    if (status === kakao.maps.services.Status.OK) {--%>
<%--                        var result = results[0];--%>
<%--                        var coords = new kakao.maps.LatLng(result.y, result.x);--%>

<%--                        document.getElementById('mapContainer').style.display = "block";--%>
<%--                        map.relayout();--%>
<%--                        map.setCenter(coords);--%>
<%--                        map.setLevel(3);--%>

<%--                        if (marker) {--%>
<%--                            marker.setMap(null);--%>
<%--                        }--%>
<%--                        if (infowindow) {--%>
<%--                            infowindow.close();--%>
<%--                        }--%>

<%--                        marker = new kakao.maps.Marker({--%>
<%--                            position: coords,--%>
<%--                            map: map--%>
<%--                        });--%>

<%--                        var iwContent = '<div style="padding:5px;">' + addr + '<br><a href="https://map.kakao.com/link/map/' + addr + ',' + result.y + ',' + result.x + '" target="_blank"><img src="/resources/image/kakaomap.png" alt="카카오맵" style="width:44px; height:18px; margin-top:5px;"></a></div>';--%>

<%--                        infowindow = new kakao.maps.InfoWindow({--%>
<%--                            content: iwContent,--%>
<%--                            removable: true--%>
<%--                        });--%>

<%--                        infowindow.open(map, marker);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>
<%--        }).open();--%>
<%--    }--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>

<%-- 10.14 영역 색변환 체크포인트 --%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>상권분석</title>--%>
<%--    <meta charset="UTF-8">--%>

<%--    <!-- jQuery 로드 (필수) -->--%>
<%--    <script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>--%>

<%--    <!-- Popper.js 로드 (Bootstrap 4에서 필수) -->--%>
<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>--%>

<%--    <!-- Bootstrap JavaScript 로드 (jQuery 이후에 로드) -->--%>
<%--    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>--%>

<%--    <!-- Bootstrap CSS -->--%>
<%--    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">--%>

<%--    <!-- Font Awesome 아이콘 CSS (옵션) -->--%>
<%--    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">--%>

<%--    <!-- Chart.js 로드 -->--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>--%>

<%--    <!-- 카카오 맵 및 우편번호 서비스 -->--%>
<%--    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>--%>
<%--    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>--%>

<%--    <style>--%>
<%--        body, html {--%>
<%--            margin: 0;--%>
<%--            padding: 0;--%>
<%--            width: 100%;--%>
<%--            height: 100%;--%>
<%--            background-color: transparent; /* 전체 배경을 투명하게 설정 */--%>
<%--            font-family: 'Noto Sans KR', sans-serif;--%>
<%--        }--%>

<%--        .content {--%>
<%--            display: flex;--%>
<%--            height: 100vh; /* 전체 화면 높이를 유지 */--%>
<%--            background-color: transparent; /* content의 배경을 투명하게 설정 */--%>
<%--            position: relative; /* content를 상대 위치로 설정 */--%>
<%--        }--%>

<%--        #sidebar {--%>
<%--            width: 350px; /* 사이드바 너비 설정 */--%>
<%--            background-color: rgba(255, 255, 255, 0); /* 사이드바를 완전히 투명하게 설정 */--%>
<%--            border: none; /* 경계선 제거 */--%>
<%--            padding: 20px 15px;--%>
<%--            border-radius: 12px;--%>
<%--            margin: 20px;--%>
<%--            position: absolute; /* 절대 위치로 설정 */--%>
<%--            z-index: 10; /* z-index를 높여 지도의 위에 배치 */--%>
<%--        }--%>

<%--        #sidebar-content {--%>
<%--            width: 380px; /* 사이드바 너비 설정 */--%>
<%--            background-color: #ffffff; /* 흰색 배경 */--%>
<%--            border-radius: 20px; /* 둥근 모서리 설정 */--%>
<%--            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* 그림자 효과 */--%>
<%--            padding: 30px 25px; /* 내부 여백 설정 */--%>
<%--            margin: 20px;--%>
<%--            position: relative;; /* 사이드바 내용의 배경을 투명하게 설정 */--%>
<%--        }--%>

<%--        #sidebar h1 {--%>
<%--            font-size: 22px;--%>
<%--            font-weight: bold;--%>
<%--            margin-bottom: 20px;--%>
<%--            color: #333;--%>
<%--        }--%>

<%--        .input-container {--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            margin-bottom: 15px;--%>
<%--        }--%>

<%--        .input-container input[type="text"] {--%>
<%--            flex: 1;--%>
<%--            padding: 12px 15px;--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선을 투명하게 설정 */--%>
<%--            border-radius: 6px;--%>
<%--            font-size: 14px;--%>
<%--            margin-right: 10px;--%>
<%--            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 그림자 효과 */--%>
<%--            background-color: rgba(255, 255, 255, 0.2); /* 입력 필드 배경 투명하게 설정 */--%>
<%--            color: #333; /* 텍스트 색상 설정 */--%>
<%--            transition: all 0.3s ease;--%>
<%--        }--%>

<%--        .input-container input[type="text"]:focus {--%>
<%--            border-color: rgba(65, 105, 225, 0.5); /* 포커스 시 테두리 색 변경 */--%>
<%--            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);--%>
<%--            background-color: rgba(255, 255, 255, 0.4); /* 포커스 시 배경 덜 투명하게 */--%>
<%--        }--%>

<%--        .input-container input[type="button"] {--%>
<%--            padding: 12px 15px;--%>
<%--            border: none;--%>
<%--            border-radius: 6px;--%>
<%--            background-color: rgba(65, 105, 225, 0.8); /* 버튼 배경 설정 */--%>
<%--            color: #fff;--%>
<%--            font-size: 14px;--%>
<%--            cursor: pointer;--%>
<%--            transition: background-color 0.3s ease;--%>
<%--        }--%>

<%--        .input-container input[type="button"]:hover {--%>
<%--            background-color: rgba(39, 72, 179, 0.9); /* 마우스 오버 시 배경 덜 투명하게 */--%>
<%--        }--%>

<%--        .select-container select {--%>
<%--            width: 100%;--%>
<%--            padding: 12px;--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선 투명도 설정 */--%>
<%--            border-radius: 6px;--%>
<%--            margin-bottom: 15px;--%>
<%--            font-size: 14px;--%>
<%--            background-color: rgba(255, 255, 255, 0.2); /* 드롭다운 배경 투명하게 설정 */--%>
<%--            color: #333;--%>
<%--            transition: border-color 0.3s ease, box-shadow 0.3s ease;--%>
<%--        }--%>

<%--        #boundaryToggleButton {--%>
<%--            width: 100%;--%>
<%--            padding: 12px;--%>
<%--            border: none;--%>
<%--            border-radius: 6px;--%>
<%--            background-color: rgba(255, 165, 0, 0.8); /* 오렌지색을 80% 투명하게 설정 */--%>
<%--            color: #fff;--%>
<%--            font-size: 16px;--%>
<%--            cursor: pointer;--%>
<%--            margin-top: 20px;--%>
<%--            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);--%>
<%--            transition: background-color 0.3s ease, box-shadow 0.3s ease;--%>
<%--        }--%>

<%--        #boundaryToggleButton:hover {--%>
<%--            background-color: rgba(230, 149, 0, 0.9); /* 마우스 오버 시 배경 덜 투명하게 */--%>
<%--        }--%>

<%--        #mapContainer {--%>
<%--            flex: 1;--%>
<%--            height: 100vh; /* 전체 화면 높이를 사용 */--%>
<%--            background-color: transparent; /* 지도 컨테이너 배경 투명하게 설정 */--%>
<%--            position: relative;--%>
<%--        }--%>

<%--        #map {--%>
<%--            width: 100%;--%>
<%--            height: 100%;--%>
<%--        }--%>
<%--        .footer {--%>
<%--            display: none; /* 하단 푸터 숨김 처리 */--%>
<%--        }--%>
<%--        #welcomeModal .modal-content {--%>
<%--            border-radius: 12px; /* 모달의 테두리를 둥글게 */--%>
<%--            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 모달에 그림자 효과 추가 */--%>
<%--        }--%>

<%--        #welcomeModal .modal-header {--%>
<%--            border-bottom: 2px solid #17a2b8; /* 모달 헤더 하단 테두리 */--%>
<%--        }--%>

<%--        #welcomeModal .modal-body h6 {--%>
<%--            color: #0056b3; /* 안내 텍스트 색상 */--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="content">--%>
<%--    <div id="sidebar">--%>
<%--        <div id="sidebar-content">--%>
<%--            <h1>상권분석</h1>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="sample5_address" placeholder="주소 찾기" readonly>--%>
<%--                <input type="button" id="search_button" onclick="sample5_execDaumPostcode()" value="주소 찾기">--%>
<%--            </div>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="eupMyeonDongSearch" placeholder="지역 검색">--%>
<%--                <input type="button" id="eupMyeonDongSearchButton" value="지역 검색">--%>
<%--            </div>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="businessCategorySearch" placeholder="업종 검색">--%>
<%--                <input type="button" id="businessCategorySearchButton" value="업종 검색">--%>
<%--            </div>--%>

<%--            <ul id="searchResults"></ul>--%>
<%--            <div id="pagination" style="text-align: center; margin-top: 20px;"></div>--%>
<%--            <div id="selectedBusiness" style="margin-top: 20px;">--%>
<%--                <!-- 선택된 업종이 여기에 표시됩니다. -->--%>
<%--            </div>--%>
<%--            <div class="select-container">--%>
<%--                <select id="locationSelect">--%>
<%--                    <option selected disabled>서울시 구 바로가기</option>--%>
<%--                    <option value="37.5172363,127.0473248">강남구</option>--%>
<%--                    <option value="37.5511,127.1465">강동구</option>--%>
<%--                    <option value="37.6397743,127.0259653">강북구</option>--%>
<%--                    <option value="37.5509787,126.8495384">강서구</option>--%>
<%--                    <option value="37.4784064,126.9516133">관악구</option>--%>
<%--                    <option value="37.5384841,127.0822934">광진구</option>--%>
<%--                    <option value="37.4954856,126.8877243">구로구</option>--%>
<%--                    <option value="37.4568502,126.8958117">금천구</option>--%>
<%--                    <option value="37.6541916,127.0567936">노원구</option>--%>
<%--                    <option value="37.6686912,127.0472104">도봉구</option>--%>
<%--                    <option value="37.5742915,127.0395685">동대문구</option>--%>
<%--                    <option value="37.5124095,126.9395078">동작구</option>--%>
<%--                    <option value="37.5663244,126.9014017">마포구</option>--%>
<%--                    <option value="37.5791433,126.9369178">서대문구</option>--%>
<%--                    <option value="37.4836042,127.0327595">서초구</option>--%>
<%--                    <option value="37.5632561,127.0364285">성동구</option>--%>
<%--                    <option value="37.5893624,127.0167415">성북구</option>--%>
<%--                    <option value="37.5145436,127.1059163">송파구</option>--%>
<%--                    <option value="37.5270616,126.8561536">양천구</option>--%>
<%--                    <option value="37.5263614,126.8966016">영등포구</option>--%>
<%--                    <option value="37.5322958,126.9904348">용산구</option>--%>
<%--                    <option value="37.6026956,126.9291993">은평구</option>--%>
<%--                    <option value="37.573293,126.979672">종로구</option>--%>
<%--                    <option value="37.5636152,126.9979403">중구</option>--%>
<%--                    <option value="37.6063241,127.092728">중랑구</option>--%>
<%--                </select>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div id="mapContainer">--%>
<%--        <div id="map"></div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 모달 창 (regionModal) -->--%>
<%--<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 모달 헤더 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-header bg-primary text-white">--%>
<%--                <h5 class="modal-title" id="regionModalLabel"><i class="fas fa-chart-area"></i> 지역 상권 분석</h5>--%>
<%--            </div>--%>

<%--            <!-- 모달 바디 시작 -->--%>
<%--            <div class="modal-body" id="modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <div class="row">--%>
<%--                        <!-- 지역명 및 차트 -->--%>
<%--                        <div class="col-md-12 mb-4">--%>
<%--                            <h5 class="text-center font-weight-bold" id="regionName">지역명</h5>--%>
<%--                            <canvas id="regionChart" style="max-width: 100%;"></canvas>--%>
<%--                        </div>--%>

<%--                        <!-- 선택된 업종 정보 -->--%>
<%--                        <div class="col-md-12">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body bg-light">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-store"></i> 선택된 업종: <span id="selectedBusinessModal" class="text-primary">정보 없음</span></h6>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <!-- 성공 확률 정보 -->--%>
<%--                        <div class="col-md-6">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-percentage"></i> 성공 확률:</h6>--%>
<%--                                    <span id="successProbability" class="display-4 text-success font-weight-bold">정보 없음</span>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <!-- 성공 확률 평가 -->--%>
<%--                        <div class="col-md-6">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-check-circle"></i> 성공 확률 평가:</h6>--%>
<%--                                    <span id="successEvaluation" class="display-4 text-info font-weight-bold">정보 없음</span>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!-- 모달 바디 끝 -->--%>

<%--            <!-- 모달 푸터 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="detailbtn" class="btn btn-primary btn-lg w-100"><i class="fas fa-info-circle"></i> 데이터 자세히 보기</button>--%>
<%--            </div>--%>
<%--            <!-- 첫 번째 모달의 확인 버튼 -->--%>
<%--            <button id="closeRegionModal" class="btn btn-primary"><i class="fas fa-check-circle"></i> 확인</button>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 두 번째 모달 창 (detailedModal) -->--%>
<%--<div class="modal fade" id="detailedModal" tabindex="-1" role="dialog" aria-labelledby="detailedModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 모달 헤더 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-header bg-info text-white">--%>
<%--                <h5 class="modal-title" id="detailedModalLabel"><i class="fas fa-info-circle"></i> 상세 정보 보기</h5>--%>
<%--            </div>--%>

<%--            <!-- 모달 바디 -->--%>
<%--            <div class="modal-body" id="detailed-modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <!-- 업종 및 지역 정보 -->--%>
<%--                    <div class="card mb-4">--%>
<%--                        <div class="card-body bg-light">--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-briefcase"></i> 업종: <span id="detailedBusinessName" class="text-primary">정보 없음</span></h6>--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-map-marker-alt"></i> 지역: <span id="detailedRegionName" class="text-primary">정보 없음</span></h6>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <!-- 상세 데이터 리스트 -->--%>
<%--                    <ul class="list-group">--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-users"> 총 거주 인구: <span id="totalResidentPopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-building"> 총 직장 인구: <span id="totalWorkplacePopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-chart-line"> 총 유동 인구: <span id="totalFloatingPopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-hotel"> 집객시설 수: <span id="attractionCount"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-dollar-sign"> 평균 월 소득: <span id="avgMonthlyIncome"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-coins"> 총 지출 금액: <span id="totalExpenditure"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-home"> 평균 임대료: <span id="avgRentFee"></span></i>--%>
<%--                        </li>--%>
<%--                    </ul>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- 모달 푸터 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="closeDetailedModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- JavaScript -->--%>
<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        // 첫 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--        $('#closeRegionModal').on('click', function () {--%>
<%--            $('#regionModal').modal('hide'); // regionModal 닫기--%>
<%--        });--%>

<%--    });--%>

<%--    $(document).ready(function () {--%>
<%--        // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--        $('#closeDetailedModal').on('click', function () {--%>
<%--            $('#detailedModal').modal('hide'); // detailedModal 닫기--%>
<%--        });--%>

<%--    });--%>

<%--</script>--%>

<%--<!-- 페이지 첫 접속 시 보여줄 안내 팝업 -->--%>
<%--<div class="modal fade" id="popupModal" tabindex="-1" role="dialog" aria-labelledby="welcomeModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 팝업 헤더 -->--%>
<%--            <div class="modal-header bg-info text-white">--%>
<%--                <h5 class="modal-title" id="welcomeModalLabel"><i class="fas fa-info-circle"></i> 상권 분석 시스템 안내</h5>--%>
<%--            </div>--%>

<%--            <!-- 팝업 바디 -->--%>
<%--            <div class="modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <!-- 안내 내용 구성 -->--%>
<%--                    <div class="card mb-4">--%>
<%--                        <div class="card-body bg-light">--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-lightbulb"></i> 상권 분석 시스템에 오신 것을 환영합니다!</h6>--%>
<%--                            <p>--%>
<%--                                이 시스템을 통해 지역별 상권 분석, 업종 선택 및 분석, 상세 데이터를 확인할 수 있습니다.--%>
<%--                                <br><br>--%>
<%--                                <strong>간단 분석 방법 안내:</strong>--%>
<%--                            <ol>--%>
<%--                                <li>분석할 지역 및 업종을 선택합니다.</li>--%>
<%--                                <li>분석하기 버튼을 클릭하여 결과를 확인합니다.</li>--%>
<%--                                <li>결과를 확인 후, 상세 데이터 보기 버튼을 통해 더 많은 정보를 얻을 수 있습니다.</li>--%>
<%--                            </ol>--%>
<%--                            </p>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- 팝업 푸터 (닫기 버튼) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="closePopupModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 메인홈페이지에서 설명 팝업창 -->--%>
<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        // 페이지가 로드되면 자동으로 팝업을 띄우는 함수--%>
<%--        $('#popupModal').modal('show');  // Bootstrap 모달 표시--%>

<%--    });--%>

<%--    $(document).ready(function () {--%>
<%--        // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--        $('#closePopupModal').on('click', function () {--%>
<%--            $('#popupModal').modal('hide'); // detailedModal 닫기--%>
<%--        });--%>

<%--    });--%>
<%--</script>--%>

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    let globalRegionName = '';  // 전역 변수 선언--%>
<%--    let globalSearchedRegion = "";--%>

<%--    function initKakaoMap() {--%>
<%--        var container = document.getElementById('map');--%>
<%--        var options = {--%>
<%--            center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울중심좌표--%>
<%--            level: 7,--%>
<%--        };--%>
<%--        map = new kakao.maps.Map(container, options);--%>
<%--        customOverlay = new kakao.maps.CustomOverlay({});--%>

<%--        var previousZoomLevel = map.getLevel();--%>

<%--        // 범위 설정--%>
<%--        var bounds = new kakao.maps.LatLngBounds(--%>
<%--            new kakao.maps.LatLng(37.4300, 126.8000), // 남서쪽 좌표--%>
<%--            new kakao.maps.LatLng(37.6800, 127.1000)  // 북동쪽 좌표--%>
<%--        );--%>

<%--        // 지도의 이동을 서울시 범위로 제한--%>
<%--        kakao.maps.event.addListener(map, 'center_changed', function () {--%>
<%--            if (!bounds.contain(map.getCenter())) {--%>
<%--                // 현재 지도 중심이 서울시 범위를 벗어난 경우--%>
<%--                var currentCenter = map.getCenter();--%>

<%--                // 지도 중심이 서울시 범위 바깥으로 나갔을 때의 제한 처리--%>
<%--                var newCenter = new kakao.maps.LatLng(--%>
<%--                    Math.min(Math.max(currentCenter.getLat(), bounds.getSouthWest().getLat()), bounds.getNorthEast().getLat()),--%>
<%--                    Math.min(Math.max(currentCenter.getLng(), bounds.getSouthWest().getLng()), bounds.getNorthEast().getLng())--%>
<%--                );--%>

<%--                map.setCenter(newCenter); // 지도 중심을 서울시 범위 내로 고정--%>
<%--            }--%>
<%--        });--%>

<%--        // 확대/축소 레벨 제한--%>
<%--        map.setMinLevel(3);--%>
<%--        map.setMaxLevel(10);--%>

<%--        // 서울시 구 선택 시 해당 구로 지도 이동--%>
<%--        $("#locationSelect").on("change", function () {--%>
<%--            if (map) {--%>
<%--                var coords = $(this).val().split(',');--%>
<%--                var latLng = new kakao.maps.LatLng(coords[0], coords[1]);--%>
<%--                map.setCenter(latLng);--%>
<%--                map.setLevel(8);--%>
<%--            }--%>
<%--        });--%>

<%--        // 지도 레벨 변경에 따른 경계 데이터 처리--%>
<%--        kakao.maps.event.addListener(map, 'zoom_changed', function () {--%>
<%--            var level = map.getLevel();--%>
<%--            console.log('Current zoom level:', level);--%>

<%--            // 확대/축소에 따른 경계 데이터 전환--%>
<%--            if (level <= 7) {--%>
<%--                if (!isEupMyeonDongLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadEupMyeonDongData();--%>
<%--                }--%>
<%--            } else if (level > 7 && level <= 9) {--%>
<%--                if (!isSiGunGuLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadSiGunGuData();--%>
<%--                }--%>
<%--            } else if (level > 9) {--%>
<%--                if (!isSiDoLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadSiDoData();--%>
<%--                }--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    let chartInstance = null;--%>

<%--    // 지역 및 업종을 클릭했을 때 호출되는 함수--%>
<%--    function showRegionInfo(regionName, adminCode, serviceCode) {--%>
<%--        updateSelectedData({ bb_code: serviceCode }, adminCode); // 추가--%>
<%--        $.ajax({--%>
<%--            url: `/api/bizone/getChartDataForDetail`,--%>
<%--            method: 'GET',--%>
<%--            data: {--%>
<%--                admin_code: adminCode,  // 행정동 코드--%>
<%--                service_code: serviceCode  // 서비스 코드--%>
<%--            },--%>
<%--            success: function (data) {--%>
<%--                console.log('Received Data for Chart:', data);--%>

<%--                // 모달 창 업데이트 코드--%>
<%--                $('#regionName').text(regionName + " 상권분석");--%>
<%--                $('#selectedBusinessModal').text(selectedBusiness ? selectedBusiness.bb_name : '정보 없음');--%>

<%--                // 두 번째 모달 창 업데이트 코드 추가--%>
<%--                $('#detailedRegionName').text(globalRegionName || adminCode);  // 전역 변수 사용--%>

<%--                const chartData = {--%>
<%--                    labels: ['평균 임대료', '총 직장인구수', '총 지출 금액', '집객시설 수', '평균 월 매출', '기타'],--%>
<%--                    datasets: [{--%>
<%--                        label: '상권분석 데이터',--%>
<%--                        data: [--%>
<%--                            data.avgRentFeeScore.toFixed(2),--%>
<%--                            data.totalWorkplacePopulationScore.toFixed(2),--%>
<%--                            data.totalExpenditureScore.toFixed(2),--%>
<%--                            data.attractionCountScore.toFixed(2),--%>
<%--                            data.avgMonthlySalesScore.toFixed(2),--%>
<%--                            data.otherScoresTotal.toFixed(2)--%>
<%--                        ],--%>
<%--                        backgroundColor: 'rgba(54, 162, 235, 0.6)',--%>
<%--                        borderColor: 'rgba(54, 162, 235, 1)',--%>
<%--                        borderWidth: 1--%>
<%--                    }]--%>
<%--                };--%>

<%--                if (chartInstance) {--%>
<%--                    chartInstance.destroy();--%>
<%--                }--%>

<%--                const ctx = document.getElementById('regionChart').getContext('2d');--%>
<%--                chartInstance = new Chart(ctx, {--%>
<%--                    type: 'bar',--%>
<%--                    data: chartData,--%>
<%--                    options: {--%>
<%--                        scales: {--%>
<%--                            y: {--%>
<%--                                beginAtZero: true,--%>
<%--                                max: 8  // y값 최대치 정하기--%>
<%--                            }--%>
<%--                        }--%>
<%--                    }--%>
<%--                });--%>

<%--                const successProbability = parseFloat(data.successProbability).toFixed(2);--%>
<%--                $('#successProbability').text(successProbability + '%');--%>
<%--                const evaluation = getEvaluation(successProbability);--%>
<%--                $('#successEvaluation').text(evaluation);--%>

<%--                $('#regionModal').modal('show');--%>
<%--            },--%>
<%--            error: function () {--%>
<%--                alert("지역 및 업종 데이터를 불러오는 중 오류가 발생했습니다.");--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    let selectedServiceCode = null;--%>
<%--    let selectedAdminCode = null;--%>

<%--    // 업종과 지역 선택 시 데이터를 설정하는 함수--%>
<%--    function updateSelectedData(business, areaCode, areaName) {--%>
<%--        selectedServiceCode = business ? business.bb_code : null;--%>
<%--        selectedServiceName = business ? business.bb_name : '정보 없음'; // 업종명 저장--%>
<%--        selectedAdminCode = areaCode;--%>
<%--        selectedAdminName = areaName || '정보 없음'; // 지역명 저장--%>
<%--        console.log('Selected data updated:', selectedServiceCode, selectedAdminCode, selectedServiceName, selectedAdminName);--%>
<%--    }--%>

<%--    // 자세히 보기 버튼 클릭 이벤트 핸들러--%>
<%--    $('#detailbtn').on('click', function () {--%>
<%--        console.log('Before sending request, selectedServiceCode:', selectedServiceCode, 'selectedAdminCode:', selectedAdminCode);--%>

<%--        if (selectedServiceCode && selectedAdminCode) {--%>
<%--            // 지역명을 가져오는 AJAX 요청 추가--%>
<%--            $.ajax({--%>
<%--                url: `/api/bizone/getRegionName`,--%>
<%--                method: 'GET',--%>
<%--                data: { admin_code: selectedAdminCode },--%>
<%--                success: function (regionName) {--%>
<%--                    console.log("in getRegionName")--%>
<%--                    console.log(regionName)--%>
<%--                    $('#detailedRegionName').text(globalRegionName); // 지역명 업데이트--%>
<%--                },--%>
<%--                error: function () {--%>
<%--                    $('#detailedRegionName').text(selectedAdminCode); // 오류 발생 시 코드 표시--%>
<%--                }--%>
<%--            });--%>

<%--            $.ajax({--%>
<%--                url: `/api/bizone/getDetailData`,--%>
<%--                method: 'GET',--%>
<%--                data: {--%>
<%--                    admin_code: selectedAdminCode,--%>
<%--                    service_code: selectedServiceCode--%>
<%--                },--%>
<%--                success: function (data) {--%>
<%--                    console.log('Detailed data received:', data);--%>

<%--                    // 모달 창에 데이터를 표시하는 로직--%>
<%--                    $('#detailedBusinessName').text(selectedBusiness.bb_name || selectedServiceCode);--%>
<%--                    $('#totalResidentPopulation').text(data.totalResidentPopulation.toLocaleString() + "명");--%>
<%--                    $('#totalWorkplacePopulation').text(data.totalWorkplacePopulation.toLocaleString() + "명");--%>
<%--                    $('#totalFloatingPopulation').text(data.totalFloatingPopulation.toLocaleString() + "명");--%>
<%--                    $('#attractionCount').text(data.attractionCount.toLocaleString() + "개");--%>
<%--                    $('#avgMonthlyIncome').text(data.avgMonthlyIncome.toLocaleString() + "원");--%>
<%--                    $('#totalExpenditure').text(data.totalExpenditure.toLocaleString() + "원");--%>
<%--                    $('#avgRentFee').text(data.avgRentFee.toLocaleString() + "원");--%>
<%--                    $('#detailedModal').modal('show');--%>
<%--                },--%>
<%--                error: function (xhr, status, error) {--%>
<%--                    console.error('Error fetching detailed data:', error);--%>
<%--                    alert('자세한 데이터를 불러오는 중 오류가 발생했습니다.');--%>
<%--                }--%>
<%--            });--%>
<%--        } else {--%>
<%--            console.warn("업종과 지역 정보가 누락되었습니다.");--%>
<%--            alert("업종과 지역을 선택해주세요.");--%>
<%--        }--%>
<%--    });--%>

<%--    // 성공 확률 평가 함수--%>
<%--    function getEvaluation(score) {--%>
<%--        if (score >= 90) {--%>
<%--            return '매우 높음';--%>
<%--        } else if (score >= 70) {--%>
<%--            return '높음';--%>
<%--        } else if (score >= 50) {--%>
<%--            return '중간';--%>
<%--        } else if (score >= 30) {--%>
<%--            return '낮음';--%>
<%--        } else {--%>
<%--            return '매우 낮음';--%>
<%--        }--%>
<%--    }--%>

<%--    // GeoJSON 데이터를 불러와 경계선을 그리는 함수--%>
<%--    function loadGeoJson(url, type) {--%>
<%--        $.getJSON(url, function (data) {--%>
<%--            data.features.forEach(function (feature) {--%>
<%--                var path = feature.geometry.coordinates[0].map(function (coord) {--%>
<%--                    return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                });--%>

<%--                var polygon = new kakao.maps.Polygon({--%>
<%--                    map: map,--%>
<%--                    path: path,--%>
<%--                    fillColor: "rgba(30, 144, 255, 0.1)",--%>
<%--                    strokeColor: "#104486",--%>
<%--                    strokeWeight: 2,--%>
<%--                });--%>

<%--                kakao.maps.event.addListener(polygon, 'click', function () {--%>
<%--                    if (isBoundaryLoaded) {  // 경계 데이터가 켜져 있을 때만 실행--%>
<%--                        var regionName = feature.properties.adm_nm ?? feature.properties.sggnm;--%>
<%--                        showRegionInfo(regionName);  // 지역 이름 전달--%>
<%--                    }--%>
<%--                });--%>

<%--                polygons.push(polygon);--%>
<%--            });--%>
<%--        });--%>
<%--    }--%>

<%--    function loadSiDoData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulSi.geojson",  // 시도 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "시도");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulSi GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function loadSiGunGuData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulGu.geojson",  // 서울 구 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "시군구");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulGu GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function loadEupMyeonDongData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulDong.geojson",  // 서울 동 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "읍면동");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulDong GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function removePolygons() {--%>
<%--        polygons.forEach(function (polygon) {--%>
<%--            polygon.setMap(null);--%>
<%--        });--%>
<%--        polygons = [];--%>

<%--        // 남아있는 overlaybox 제거--%>
<%--        if (customOverlay) {--%>
<%--            customOverlay.setMap(null);--%>
<%--        }--%>
<%--    }--%>

<%--    var kkoMap = {--%>
<%--        loadGeoJson: function (geoJsonData, type) {--%>
<%--            var fillColor, strokeColor;--%>
<%--            if (type === "읍면동") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)";--%>
<%--                strokeColor = "#104486";--%>
<%--            } else if (type === "시군구") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)";--%>
<%--                strokeColor = "#163599";--%>
<%--            } else if (type === "시도") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)"--%>
<%--                strokeColor = "#101e4e";--%>
<%--            }--%>

<%--            geoJsonData.features.forEach(function (feature) {--%>
<%--                if (type !== "시도") {--%>

<%--                    if (feature.properties.adm_nm?.split(" ").includes(globalSearchedRegion)) {--%>
<%--                        kkoMap.setPolygon(kkoMap.getPolygonData(feature), "pink", strokeColor, type);--%>
<%--                    } else {--%>
<%--                        if (feature.properties.sggnm.split(" ").includes(globalSearchedRegion)) {--%>
<%--                            kkoMap.setPolygon(kkoMap.getPolygonData(feature), "hotpink", strokeColor, type)--%>
<%--                        } else {--%>
<%--                            kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);--%>
<%--                        }--%>
<%--                    }--%>
<%--                } else {--%>
<%--                    kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);--%>
<%--                }--%>
<%--            });--%>


<%--        },--%>

<%--        getPolygonData: function (feature) {--%>
<%--            var path = [];--%>
<%--            feature.geometry.coordinates.forEach(function (coords) {--%>
<%--                coords.forEach(function (innerCoords) {  // 다차원 좌표 처리--%>
<%--                    path.push(innerCoords.map(function (coord) {--%>
<%--                        return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                    }));--%>
<%--                });--%>
<%--            });--%>
<%--            return {--%>
<%--                code: feature.properties.adm_cd2,--%>
<%--                name: feature.properties.adm_nm ?? feature.properties.sggnm ?? feature.properties.sidonm,--%>
<%--                path: path--%>
<%--            };--%>
<%--        },--%>

<%--        setPolygon: function (area, fillColor, strokeColor, type) {--%>
<%--            var polygon = new kakao.maps.Polygon({--%>
<%--                path: area.path,--%>
<%--                strokeWeight: 2,--%>
<%--                strokeColor: strokeColor,--%>
<%--                strokeOpacity: 0.8,--%>
<%--                fillColor: fillColor,--%>
<%--                fillOpacity: fillColor === "hotpink" ? 0.7 : 0.3,--%>
<%--            });--%>

<%--            let isMouseOver = false;--%>

<%--            kakao.maps.event.addListener(polygon, "mouseover", function () {--%>
<%--                if (!isMouseOver) {--%>
<%--                    isMouseOver = true;--%>
<%--                    polygon.setOptions({fillColor: type === "읍면동" ? "#0D94E8" : "#0031FD"});--%>
<%--                    customOverlay.setContent("<div class='overlaybox'>" + area.name + "</div>");--%>
<%--                    customOverlay.setMap(map);--%>
<%--                }--%>
<%--            });--%>

<%--            kakao.maps.event.addListener(polygon, "mousemove", function (mouseEvent) {--%>
<%--                if (isMouseOver) {--%>
<%--                    const offsetX = 35;--%>
<%--                    const offsetY = 35;--%>
<%--                    const projection = map.getProjection();--%>
<%--                    const point = projection.pointFromCoords(mouseEvent.latLng);--%>
<%--                    point.x += offsetX;--%>
<%--                    point.y += offsetY;--%>
<%--                    const newPosition = projection.coordsFromPoint(point);--%>
<%--                    customOverlay.setPosition(newPosition);--%>
<%--                }--%>
<%--            });--%>

<%--            kakao.maps.event.addListener(polygon, "mouseout", function () {--%>
<%--                if (isMouseOver) {--%>
<%--                    isMouseOver = false;--%>
<%--                    polygon.setOptions({fillColor: fillColor});--%>
<%--                    customOverlay.setMap(null);--%>
<%--                }--%>
<%--            });--%>

<%--            // 지역(폴리곤)을 클릭할 때 updateSelectedData 호출--%>
<%--            kakao.maps.event.addListener(polygon, "click", function () {--%>
<%--                console.log('Polygon Clicked:', area.name); // 클릭된 폴리곤 정보 확인--%>

<%--                if (!selectedBusiness || !selectedBusiness.bb_code) {--%>
<%--                    console.log('alert확인용 코드'); // 로그 추가--%>
<%--                    alert("업종을 선택해주세요.");--%>
<%--                    return; // 업종이 선택되지 않았으면 함수 종료--%>
<%--                }--%>

<%--                previousZoomLevel = map.getLevel(); // 클릭 시 현재 지도 레벨 저장--%>
<%--                selectedAdminCode = area.code; // 클릭한 지역의 행정동 코드 업데이트--%>
<%--                globalRegionName = area.name;--%>

<%--                console.log('Clicked Area Code:', selectedAdminCode);  // 행정동 코드 확인--%>
<%--                console.log('Selected Business Code:', selectedBusiness ? selectedBusiness.bb_code : null);  // 선택된 업종 코드 확인--%>

<%--                // 선택된 업종과 행정동 코드를 updateSelectedData 함수로 업데이트--%>
<%--                updateSelectedData(selectedBusiness, selectedAdminCode, area.name);--%>

<%--                // showRegionInfo 함수에 행정동 이름과 행정동 코드, 그리고 선택된 업종 코드를 함께 전달--%>
<%--                showRegionInfo(area.name, selectedAdminCode, selectedBusiness ? selectedBusiness.bb_code : null);--%>

<%--                if (type === "읍면동") {--%>
<%--                    $("#eupMyeonDongSelectedArea").text("선택된 읍면동: " + area.name);--%>
<%--                } else if (type === "시군구") {--%>
<%--                    $("#siGunGuSelectedArea").text("선택된 시군구: " + area.name);--%>
<%--                } else if (type === "시도") {--%>
<%--                    $("#siDoSelectedArea").text("선택된 시도: " + area.name);--%>
<%--                }--%>
<%--                // 클릭 후 이전 확대 레벨을 유지하면서 중심 이동--%>
<%--                map.setCenter(kkoMap.centroid(area.path[0]));--%>
<%--                map.setLevel(previousZoomLevel);  // 이전 확대 레벨로 설정--%>
<%--            });--%>

<%--            polygon.setMap(map);--%>
<%--            polygons.push(polygon);--%>
<%--        },--%>

<%--        centroid: function (path) {--%>
<%--            let sumX = 0, sumY = 0, length = path.length;--%>
<%--            path.forEach(function (coord) {--%>
<%--                sumX += coord.getLng();--%>
<%--                sumY += coord.getLat();--%>
<%--            });--%>
<%--            return new kakao.maps.LatLng(sumY / length, sumX / length);--%>
<%--        },--%>
<%--    };--%>

<%--    $(document).ready(function () {--%>
<%--        initKakaoMap();  // Kakao 지도 초기화--%>
<%--        loadEupMyeonDongData();  // 페이지 로드 시 자동으로 읍면동 경계 데이터 로드--%>
<%--    });--%>

<%--    // 기존 검색된 마커 및 인포윈도우 제거 함수--%>
<%--    function removeSearchMarkers() {--%>
<%--        if (marker) {--%>
<%--            marker.setMap(null);--%>
<%--            marker = null;--%>
<%--        }--%>
<%--        if (infowindow) {--%>
<%--            infowindow.close();--%>
<%--            infowindow = null;--%>
<%--        }--%>
<%--    }--%>

<%--    // 지역 검색 기능 (마커와 인포윈도우 사용)--%>
<%--    $("#eupMyeonDongSearchButton").on("click", function () {--%>
<%--        var searchQuery = $("#eupMyeonDongSearch").val();--%>

<%--        if (!searchQuery) {--%>
<%--            alert("지역명을 입력하세요.");--%>
<%--            return;--%>
<%--        }--%>

<%--        globalSearchedRegion = searchQuery;--%>
<%--        removePolygons();--%>
<%--        loadEupMyeonDongData();--%>

<%--        // Kakao Geocoder를 사용하여 지역 검색--%>
<%--        var geocoder = new kakao.maps.services.Geocoder();--%>
<%--        geocoder.addressSearch(searchQuery, function (results, status) {--%>
<%--            if (status === kakao.maps.services.Status.OK) {--%>
<%--                var result = results[0];--%>
<%--                var coords = new kakao.maps.LatLng(result.y, result.x);--%>

<%--                // 기존 마커 및 인포윈도우 제거--%>
<%--                removeSearchMarkers();--%>

<%--                // 중심 좌표로 이동--%>
<%--                map.setCenter(coords);--%>
<%--                map.setLevel(5);--%>

<%--                // 마커 생성--%>
<%--                marker = new kakao.maps.Marker({--%>
<%--                    position: coords,--%>
<%--                    map: map--%>
<%--                });--%>

<%--                // 인포윈도우 생성--%>
<%--                var infowindowContent = '<div style="padding:5px;">' + result.address_name + '<br><a href="https://map.kakao.com/link/map/' + result.address_name + ',' + result.y + ',' + result.x + '" target="_blank">큰지도보기</a></div>';--%>

<%--                infowindow = new kakao.maps.InfoWindow({--%>
<%--                    content: infowindowContent,--%>
<%--                    removable: true--%>
<%--                });--%>

<%--                // 인포윈도우를 마커에 연결--%>
<%--                infowindow.open(map, marker);--%>
<%--            } else {--%>
<%--                alert("검색된 지역이 없습니다. 다시 시도하세요.");--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>

<%--    var businessData = [];--%>
<%--    var currentPage = 1;--%>
<%--    var resultsPerPage = 10;--%>

<%--    // 초성 변환 함수--%>
<%--    function getChosung(str) {--%>
<%--        const chosungList = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];--%>
<%--        let result = '';--%>
<%--        for (let i = 0; i < str.length; i++) {--%>
<%--            const code = str.charCodeAt(i) - 44032;--%>
<%--            if (code >= 0 && code <= 11171) {--%>
<%--                result += chosungList[Math.floor(code / 588)];--%>
<%--            } else {--%>
<%--                // 한글 자음이 아닌 경우 그대로 반환 (알파벳 등은 그대로 유지)--%>
<%--                result += str[i];--%>
<%--            }--%>
<%--        }--%>
<%--        return result;--%>
<%--    }--%>

<%--    // 검색어가 초성인지 여부를 판별하는 함수--%>
<%--    function isChosungInput(str) {--%>
<%--        return /^[ㄱ-ㅎ]+$/.test(str); // 입력 문자열이 초성만으로 구성된 경우 true 반환--%>
<%--    }--%>

<%--    // 검색 필터 함수--%>
<%--    function filterFunc(item) {--%>
<%--        const searchQuery = $('#businessCategorySearch').val().toLowerCase();--%>

<%--        if (isChosungInput(searchQuery)) {--%>
<%--            // 초성 검색 처리--%>
<%--            const searchQueryChosung = getChosung(searchQuery);--%>
<%--            const businessNameChosung = getChosung(item.bb_name.toLowerCase());--%>

<%--            // 입력된 초성이 포함되고, 정확한 초성 순서로 일치하는 항목만 반환--%>
<%--            return businessNameChosung.includes(searchQueryChosung) && checkExactChosungMatch(searchQuery, item.bb_name);--%>
<%--        } else {--%>
<%--            // 일반 텍스트 검색 처리--%>
<%--            return item.bb_name.toLowerCase().includes(searchQuery);--%>
<%--        }--%>
<%--    }--%>

<%--    // 초성과 실제 단어가 결합된 경우를 정확히 검사하는 함수--%>
<%--    function checkExactChosungMatch(searchQuery, businessName) {--%>
<%--        const searchChosung = getChosung(searchQuery);--%>
<%--        const businessNameChosung = getChosung(businessName);--%>

<%--        // 초성 비교를 위해 한 글자씩 확인--%>
<%--        for (let i = 0, j = 0; i < searchChosung.length && j < businessNameChosung.length; i++, j++) {--%>
<%--            // 만약 현재 비교 위치에서 자음이 동일하지만 모음까지 결합된 경우가 있다면 false 반환--%>
<%--            while (j < businessNameChosung.length && searchChosung[i] !== businessNameChosung[j]) {--%>
<%--                j++;--%>
<%--            }--%>
<%--            if (j >= businessNameChosung.length || searchChosung[i] !== businessNameChosung[j]) {--%>
<%--                return false; // 초성 순서가 다르거나 결합된 자음이 있음--%>
<%--            }--%>
<%--        }--%>
<%--        return true;--%>
<%--    }--%>

<%--    // 검색 결과를 화면에 표시--%>
<%--    function displayResults(filteredResults) {--%>
<%--        $('#searchResults').empty();--%>
<%--        if (filteredResults.length === 0) {--%>
<%--            $('#searchResults').append('<li>검색 결과가 없습니다.</li>');--%>
<%--            return;--%>
<%--        }--%>

<%--        // 모든 결과를 표시하고, 스크롤을 통해 넘길 수 있도록 함--%>
<%--        filteredResults.forEach(function (item) {--%>
<%--            const listItem = $('<li>' + item.bb_name + ' (' + item.bb_code + ')</li>');--%>

<%--            // 마우스 커서 올리면 강조 효과 추가--%>
<%--            listItem.css({--%>
<%--                'padding': '8px',--%>
<%--                'cursor': 'pointer'--%>
<%--            });--%>

<%--            listItem.hover(--%>
<%--                function () { // 마우스가 들어왔을 때--%>
<%--                    $(this).css('background-color', '#FF2C9760');--%>
<%--                },--%>
<%--                function () { // 마우스가 나갔을 때--%>
<%--                    $(this).css('background-color', '');--%>
<%--                }--%>
<%--            );--%>

<%--            // 클릭 이벤트 추가--%>
<%--            listItem.on('click', function () {--%>
<%--                selectedBusiness = item;--%>
<%--                updateSelectedData(selectedBusiness, selectedAdminCode);  // 선택한 업종과 현재 선택된 지역 코드로 함수 호출(추가10.10)--%>
<%--                displaySelectedBusiness();  // 선택된 업종 표시--%>
<%--            });--%>

<%--            $('#searchResults').append(listItem);--%>
<%--        });--%>

<%--        // 스크롤 처리--%>
<%--        $('#searchResults').css({--%>
<%--            'max-height': '200px', // 사이드바 높이에 맞춤--%>
<%--            'overflow-y': 'scroll' // 스크롤 가능하게 설정--%>
<%--        });--%>
<%--    }--%>

<%--    // 선택된 업종을 표시하는 함수--%>
<%--    function displaySelectedBusiness() {--%>
<%--        if (selectedBusiness) {--%>
<%--            $('#selectedBusiness').html('<p>선택된 업종: ' + selectedBusiness.bb_name + ' (' + selectedBusiness.bb_code + ')</p>');--%>
<%--        }--%>
<%--    }--%>

<%--    // 검색 버튼 클릭 시 검색 결과 필터링 및 표시--%>
<%--    $('#businessCategorySearchButton').on('click', function () {--%>
<%--        const searchQuery = $('#businessCategorySearch').val().toLowerCase();--%>

<%--        // 빈 검색어 입력 시 선택된 업종을 비우고 결과 초기화--%>
<%--        if (!searchQuery) {--%>
<%--            $('#searchResults').empty();--%>
<%--            $('#selectedBusiness').empty();--%>
<%--            selectedBusiness = null;  // 선택한 업종 초기화--%>
<%--            return;--%>
<%--        }--%>

<%--        // 필터링된 결과를 화면에 표시--%>
<%--        const filteredResults = businessData.filter(filterFunc);--%>
<%--        displayResults(filteredResults);--%>
<%--    });--%>

<%--    // 키보드 입력 시 자동완성 + 빈 입력란 처리--%>
<%--    $('#businessCategorySearch').on('input', function () {--%>
<%--        const searchQuery = $(this).val().toLowerCase();--%>

<%--        if (!searchQuery) {--%>
<%--            $('#searchResults').empty();--%>
<%--            $('#selectedBusiness').empty();--%>
<%--            selectedBusiness = null;  // 선택한 업종 초기화--%>
<%--            return;--%>
<%--        }--%>

<%--        const filteredResults = businessData.filter(filterFunc);--%>
<%--        displayResults(filteredResults);--%>
<%--    });--%>

<%--    // 데이터 로드--%>
<%--    $.ajax({--%>
<%--        url: '/api/bizone/services/all',  // API 엔드포인트--%>
<%--        method: 'GET',--%>
<%--        success: function (data) {--%>
<%--            console.log("AJAX 데이터 로드 성공:", data);  // 콘솔에 로드된 데이터 출력--%>
<%--            businessData = data;  // 가져온 데이터를 businessData에 저장--%>
<%--            // 첫 페이지에서는 검색창에 입력될 때만 결과를 표시하므로 초기 표시하지 않음--%>

<%--        },--%>
<%--        error: function (xhr, status, error) {--%>
<%--            console.error("Error fetching business data:", error);--%>
<%--        }--%>
<%--    });--%>

<%--    function sample5_execDaumPostcode() {--%>
<%--        new daum.Postcode({--%>
<%--            oncomplete: function (data) {--%>
<%--                var addr = data.address;--%>

<%--                document.getElementById("sample5_address").value = addr;--%>

<%--                var geocoder = new kakao.maps.services.Geocoder();--%>
<%--                geocoder.addressSearch(addr, function (results, status) {--%>
<%--                    if (status === kakao.maps.services.Status.OK) {--%>
<%--                        var result = results[0];--%>
<%--                        var coords = new kakao.maps.LatLng(result.y, result.x);--%>

<%--                        document.getElementById('mapContainer').style.display = "block";--%>
<%--                        map.relayout();--%>
<%--                        map.setCenter(coords);--%>
<%--                        map.setLevel(3);--%>

<%--                        if (marker) {--%>
<%--                            marker.setMap(null);--%>
<%--                        }--%>
<%--                        if (infowindow) {--%>
<%--                            infowindow.close();--%>
<%--                        }--%>

<%--                        marker = new kakao.maps.Marker({--%>
<%--                            position: coords,--%>
<%--                            map: map--%>
<%--                        });--%>

<%--                        var iwContent = '<div style="padding:5px;">' + addr + '<br><a href="https://map.kakao.com/link/map/' + addr + ',' + result.y + ',' + result.x + '" target="_blank"><img src="/resources/image/kakaomap.png" alt="카카오맵" style="width:44px; height:18px; margin-top:5px;"></a></div>';--%>

<%--                        infowindow = new kakao.maps.InfoWindow({--%>
<%--                            content: iwContent,--%>
<%--                            removable: true--%>
<%--                        });--%>

<%--                        infowindow.open(map, marker);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>
<%--        }).open();--%>
<%--    }--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>


<%-- 10.14 백업본 --%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>상권분석</title>--%>
<%--    <meta charset="UTF-8">--%>

<%--    <!-- jQuery 로드 (필수) -->--%>
<%--    <script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>--%>

<%--    <!-- Popper.js 로드 (Bootstrap 4에서 필수) -->--%>
<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>--%>

<%--    <!-- Bootstrap JavaScript 로드 (jQuery 이후에 로드) -->--%>
<%--    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>--%>

<%--    <!-- Bootstrap CSS -->--%>
<%--    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">--%>

<%--    <!-- Font Awesome 아이콘 CSS (옵션) -->--%>
<%--    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">--%>

<%--    <!-- Chart.js 로드 -->--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>--%>

<%--    <!-- 카카오 맵 및 우편번호 서비스 -->--%>
<%--    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>--%>
<%--    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>--%>

<%--    <style>--%>
<%--        body, html {--%>
<%--            margin: 0;--%>
<%--            padding: 0;--%>
<%--            width: 100%;--%>
<%--            height: 100%;--%>
<%--            background-color: transparent; /* 전체 배경을 투명하게 설정 */--%>
<%--            font-family: 'Noto Sans KR', sans-serif;--%>
<%--        }--%>

<%--        .content {--%>
<%--            display: flex;--%>
<%--            height: 100vh; /* 전체 화면 높이를 유지 */--%>
<%--            background-color: transparent; /* content의 배경을 투명하게 설정 */--%>
<%--            position: relative; /* content를 상대 위치로 설정 */--%>
<%--        }--%>

<%--        #sidebar {--%>
<%--            width: 350px; /* 사이드바 너비 설정 */--%>
<%--            background-color: rgba(255, 255, 255, 0); /* 사이드바를 완전히 투명하게 설정 */--%>
<%--            border: none; /* 경계선 제거 */--%>
<%--            padding: 20px 15px;--%>
<%--            border-radius: 12px;--%>
<%--            margin: 20px;--%>
<%--            position: absolute; /* 절대 위치로 설정 */--%>
<%--            z-index: 10; /* z-index를 높여 지도의 위에 배치 */--%>
<%--        }--%>

<%--        #sidebar-content {--%>
<%--            width: 380px; /* 사이드바 너비 설정 */--%>
<%--            background-color: #ffffff; /* 흰색 배경 */--%>
<%--            border-radius: 20px; /* 둥근 모서리 설정 */--%>
<%--            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* 그림자 효과 */--%>
<%--            padding: 30px 25px; /* 내부 여백 설정 */--%>
<%--            margin: 20px;--%>
<%--            position: relative;; /* 사이드바 내용의 배경을 투명하게 설정 */--%>
<%--        }--%>

<%--        #sidebar h1 {--%>
<%--            font-size: 22px;--%>
<%--            font-weight: bold;--%>
<%--            margin-bottom: 20px;--%>
<%--            color: #333;--%>
<%--        }--%>

<%--        .input-container {--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            margin-bottom: 15px;--%>
<%--        }--%>

<%--        .input-container input[type="text"] {--%>
<%--            flex: 1;--%>
<%--            padding: 12px 15px;--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선을 투명하게 설정 */--%>
<%--            border-radius: 6px;--%>
<%--            font-size: 14px;--%>
<%--            margin-right: 10px;--%>
<%--            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 그림자 효과 */--%>
<%--            background-color: rgba(255, 255, 255, 0.2); /* 입력 필드 배경 투명하게 설정 */--%>
<%--            color: #333; /* 텍스트 색상 설정 */--%>
<%--            transition: all 0.3s ease;--%>
<%--        }--%>

<%--        .input-container input[type="text"]:focus {--%>
<%--            border-color: rgba(65, 105, 225, 0.5); /* 포커스 시 테두리 색 변경 */--%>
<%--            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);--%>
<%--            background-color: rgba(255, 255, 255, 0.4); /* 포커스 시 배경 덜 투명하게 */--%>
<%--        }--%>

<%--        .input-container input[type="button"] {--%>
<%--            padding: 12px 15px;--%>
<%--            border: none;--%>
<%--            border-radius: 6px;--%>
<%--            background-color: rgba(65, 105, 225, 0.8); /* 버튼 배경 설정 */--%>
<%--            color: #fff;--%>
<%--            font-size: 14px;--%>
<%--            cursor: pointer;--%>
<%--            transition: background-color 0.3s ease;--%>
<%--        }--%>

<%--        .input-container input[type="button"]:hover {--%>
<%--            background-color: rgba(39, 72, 179, 0.9); /* 마우스 오버 시 배경 덜 투명하게 */--%>
<%--        }--%>

<%--        .select-container select {--%>
<%--            width: 100%;--%>
<%--            padding: 12px;--%>
<%--            border: 1px solid rgba(255, 255, 255, 0.3); /* 경계선 투명도 설정 */--%>
<%--            border-radius: 6px;--%>
<%--            margin-bottom: 15px;--%>
<%--            font-size: 14px;--%>
<%--            background-color: rgba(255, 255, 255, 0.2); /* 드롭다운 배경 투명하게 설정 */--%>
<%--            color: #333;--%>
<%--            transition: border-color 0.3s ease, box-shadow 0.3s ease;--%>
<%--        }--%>

<%--        #mapContainer {--%>
<%--            flex: 1;--%>
<%--            height: 100vh; /* 전체 화면 높이를 사용 */--%>
<%--            background-color: transparent; /* 지도 컨테이너 배경 투명하게 설정 */--%>
<%--            position: relative;--%>
<%--        }--%>

<%--        #map {--%>
<%--            width: 100%;--%>
<%--            height: 100%;--%>
<%--        }--%>
<%--        .footer {--%>
<%--            display: none; /* 하단 푸터 숨김 처리 */--%>
<%--        }--%>
<%--        #welcomeModal .modal-content {--%>
<%--            border-radius: 12px; /* 모달의 테두리를 둥글게 */--%>
<%--            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 모달에 그림자 효과 추가 */--%>
<%--        }--%>

<%--        #welcomeModal .modal-header {--%>
<%--            border-bottom: 2px solid #17a2b8; /* 모달 헤더 하단 테두리 */--%>
<%--        }--%>

<%--        #welcomeModal .modal-body h6 {--%>
<%--            color: #0056b3; /* 안내 텍스트 색상 */--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="content">--%>
<%--    <div id="sidebar">--%>
<%--        <div id="sidebar-content">--%>
<%--            <h1>상권분석</h1>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="sample5_address" placeholder="주소 찾기" readonly>--%>
<%--                <input type="button" id="search_button" onclick="sample5_execDaumPostcode()" value="주소 찾기">--%>
<%--            </div>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="eupMyeonDongSearch" placeholder="지역 검색">--%>
<%--                <input type="button" id="eupMyeonDongSearchButton" value="지역 검색">--%>
<%--            </div>--%>
<%--            <div class="input-container">--%>
<%--                <input type="text" id="businessCategorySearch" placeholder="업종 검색">--%>
<%--                <input type="button" id="businessCategorySearchButton" value="업종 검색">--%>
<%--            </div>--%>

<%--            <ul id="searchResults"></ul>--%>
<%--            <div id="pagination" style="text-align: center; margin-top: 20px;"></div>--%>
<%--            <div id="selectedBusiness" style="margin-top: 20px;">--%>
<%--                <!-- 선택된 업종이 여기에 표시됩니다. -->--%>
<%--            </div>--%>
<%--            <div class="select-container">--%>
<%--                <select id="locationSelect">--%>
<%--                    <option selected disabled>서울시 구 바로가기</option>--%>
<%--                    <option value="37.5172363,127.0473248">강남구</option>--%>
<%--                    <option value="37.5511,127.1465">강동구</option>--%>
<%--                    <option value="37.6397743,127.0259653">강북구</option>--%>
<%--                    <option value="37.5509787,126.8495384">강서구</option>--%>
<%--                    <option value="37.4784064,126.9516133">관악구</option>--%>
<%--                    <option value="37.5384841,127.0822934">광진구</option>--%>
<%--                    <option value="37.4954856,126.8877243">구로구</option>--%>
<%--                    <option value="37.4568502,126.8958117">금천구</option>--%>
<%--                    <option value="37.6541916,127.0567936">노원구</option>--%>
<%--                    <option value="37.6686912,127.0472104">도봉구</option>--%>
<%--                    <option value="37.5742915,127.0395685">동대문구</option>--%>
<%--                    <option value="37.5124095,126.9395078">동작구</option>--%>
<%--                    <option value="37.5663244,126.9014017">마포구</option>--%>
<%--                    <option value="37.5791433,126.9369178">서대문구</option>--%>
<%--                    <option value="37.4836042,127.0327595">서초구</option>--%>
<%--                    <option value="37.5632561,127.0364285">성동구</option>--%>
<%--                    <option value="37.5893624,127.0167415">성북구</option>--%>
<%--                    <option value="37.5145436,127.1059163">송파구</option>--%>
<%--                    <option value="37.5270616,126.8561536">양천구</option>--%>
<%--                    <option value="37.5263614,126.8966016">영등포구</option>--%>
<%--                    <option value="37.5322958,126.9904348">용산구</option>--%>
<%--                    <option value="37.6026956,126.9291993">은평구</option>--%>
<%--                    <option value="37.573293,126.979672">종로구</option>--%>
<%--                    <option value="37.5636152,126.9979403">중구</option>--%>
<%--                    <option value="37.6063241,127.092728">중랑구</option>--%>
<%--                </select>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div id="mapContainer">--%>
<%--        <div id="map"></div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 모달 창 (regionModal) -->--%>
<%--<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 모달 헤더 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-header bg-primary text-white">--%>
<%--                <h5 class="modal-title" id="regionModalLabel"><i class="fas fa-chart-area"></i> 지역 상권 분석</h5>--%>
<%--            </div>--%>

<%--            <!-- 모달 바디 시작 -->--%>
<%--            <div class="modal-body" id="modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <div class="row">--%>
<%--                        <!-- 지역명 및 차트 -->--%>
<%--                        <div class="col-md-12 mb-4">--%>
<%--                            <h5 class="text-center font-weight-bold" id="regionName">지역명</h5>--%>
<%--                            <canvas id="regionChart" style="max-width: 100%;"></canvas>--%>
<%--                        </div>--%>

<%--                        <!-- 선택된 업종 정보 -->--%>
<%--                        <div class="col-md-12">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body bg-light">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-store"></i> 선택된 업종: <span id="selectedBusinessModal" class="text-primary">정보 없음</span></h6>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <!-- 성공 확률 정보 -->--%>
<%--                        <div class="col-md-6">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-percentage"></i> 성공 확률:</h6>--%>
<%--                                    <span id="successProbability" class="display-4 text-success font-weight-bold">정보 없음</span>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>

<%--                        <!-- 성공 확률 평가 -->--%>
<%--                        <div class="col-md-6">--%>
<%--                            <div class="card mb-4">--%>
<%--                                <div class="card-body">--%>
<%--                                    <h6 class="font-weight-bold"><i class="fas fa-check-circle"></i> 성공 확률 평가:</h6>--%>
<%--                                    <span id="successEvaluation" class="display-4 text-info font-weight-bold">정보 없음</span>--%>
<%--                                </div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <!-- 모달 바디 끝 -->--%>


<%--            <!-- 모달 푸터 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="detailbtn" class="btn btn-primary btn-lg w-100"><i class="fas fa-info-circle"></i> 데이터 자세히 보기</button>--%>
<%--            </div>--%>
<%--                <!-- 첫 번째 모달의 확인 버튼 -->--%>
<%--                <button id="closeRegionModal" class="btn btn-primary"><i class="fas fa-check-circle"></i> 확인</button>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>



<%--<!-- 두 번째 모달 창 (detailedModal) -->--%>
<%--<div class="modal fade" id="detailedModal" tabindex="-1" role="dialog" aria-labelledby="detailedModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 모달 헤더 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-header bg-info text-white">--%>
<%--                <h5 class="modal-title" id="detailedModalLabel"><i class="fas fa-info-circle"></i> 상세 정보 보기</h5>--%>
<%--            </div>--%>

<%--            <!-- 모달 바디 -->--%>
<%--            <div class="modal-body" id="detailed-modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <!-- 업종 및 지역 정보 -->--%>
<%--                    <div class="card mb-4">--%>
<%--                        <div class="card-body bg-light">--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-briefcase"></i> 업종: <span id="detailedBusinessName" class="text-primary">정보 없음</span></h6>--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-map-marker-alt"></i> 지역: <span id="detailedRegionName" class="text-primary">정보 없음</span></h6>--%>
<%--                        </div>--%>
<%--                    </div>--%>

<%--                    <!-- 상세 데이터 리스트 -->--%>
<%--                    <ul class="list-group">--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-users"> 총 거주 인구: <span id="totalResidentPopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-building"> 총 직장 인구: <span id="totalWorkplacePopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-dollar-sign"> 평균 월 소득: <span id="avgMonthlyIncome"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-coins"> 총 소비 금액: <span id="totalExpenditure"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-chart-line"> 총 유동 인구: <span id="totalFloatingPopulation"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-hotel"> 집객시설 수: <span id="attractionCount"></span></i>--%>
<%--                        </li>--%>
<%--                        <li class="list-group-item d-flex justify-content-between align-items-center">--%>
<%--                            <i class="fas fa-home"> 평균 임대료: <span id="avgRentFee"></span></i>--%>
<%--                        </li>--%>
<%--                    </ul>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- 모달 푸터 (닫기 버튼 없음) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="closeDetailedModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- JavaScript -->--%>
<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        // 첫 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--        $('#closeRegionModal').on('click', function () {--%>
<%--            $('#regionModal').modal('hide'); // regionModal 닫기--%>
<%--        });--%>

<%--    });--%>

<%--    $(document).ready(function () {--%>
<%--    // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--    $('#closeDetailedModal').on('click', function () {--%>
<%--        $('#detailedModal').modal('hide'); // detailedModal 닫기--%>
<%--    });--%>

<%--    });--%>

<%--</script>--%>

<%--<!-- 페이지 첫 접속 시 보여줄 안내 팝업 -->--%>
<%--<div class="modal fade" id="popupModal" tabindex="-1" role="dialog" aria-labelledby="welcomeModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog modal-lg" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <!-- 팝업 헤더 -->--%>
<%--            <div class="modal-header bg-info text-white">--%>
<%--                <h5 class="modal-title" id="welcomeModalLabel"><i class="fas fa-info-circle"></i> 상권 분석 시스템 안내</h5>--%>
<%--            </div>--%>

<%--            <!-- 팝업 바디 -->--%>
<%--            <div class="modal-body">--%>
<%--                <div class="container-fluid">--%>
<%--                    <!-- 안내 내용 구성 -->--%>
<%--                    <div class="card mb-4">--%>
<%--                        <div class="card-body bg-light">--%>
<%--                            <h6 class="font-weight-bold"><i class="fas fa-lightbulb"></i> 상권 분석 시스템에 오신 것을 환영합니다!</h6>--%>
<%--                            <p>--%>
<%--                                이 시스템을 통해 지역별 상권 분석, 업종 선택 및 분석, 상세 데이터를 확인할 수 있습니다.--%>
<%--                                <br><br>--%>
<%--                                <strong>간단 분석 방법 안내:</strong>--%>
<%--                            <ol>--%>
<%--                                <li>분석할 지역 및 업종을 선택합니다.</li>--%>
<%--                                <li>분석하기 버튼을 클릭하여 결과를 확인합니다.</li>--%>
<%--                                <li>결과를 확인 후, 상세 데이터 보기 버튼을 통해 더 많은 정보를 얻을 수 있습니다.</li>--%>
<%--                            </ol>--%>
<%--                            </p>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- 팝업 푸터 (닫기 버튼) -->--%>
<%--            <div class="modal-footer">--%>
<%--                <button id="closePopupModal" class="btn btn-primary">확인</button> <!-- 확인 버튼을 눌렀을 때 모달 닫기 -->--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 메인홈페이지에서 설명 팝업창 -->--%>
<%--<script>--%>
<%--    $(document).ready(function () {--%>
<%--        // 페이지가 로드되면 자동으로 팝업을 띄우는 함수--%>
<%--        $('#popupModal').modal('show');  // Bootstrap 모달 표시--%>

<%--    });--%>

<%--        $(document).ready(function () {--%>
<%--            // 두 번째 모달의 확인 버튼 클릭 시 모달 닫기--%>
<%--            $('#closePopupModal').on('click', function () {--%>
<%--                $('#popupModal').modal('hide'); // detailedModal 닫기--%>
<%--            });--%>

<%--        });--%>
<%--</script>--%>

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    var globalRegionName = '';  // 전역 변수 선언--%>

<%--    function initKakaoMap() {--%>
<%--        var container = document.getElementById('map');--%>
<%--        var options = {--%>
<%--            center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울중심좌표--%>
<%--            level: 7,--%>
<%--        };--%>
<%--        map = new kakao.maps.Map(container, options);--%>
<%--        customOverlay = new kakao.maps.CustomOverlay({});--%>

<%--        var previousZoomLevel = map.getLevel();--%>

<%--        // 범위 설정--%>
<%--        var bounds = new kakao.maps.LatLngBounds(--%>
<%--            new kakao.maps.LatLng(37.4300, 126.8000), // 남서쪽 좌표--%>
<%--            new kakao.maps.LatLng(37.6800, 127.1000)  // 북동쪽 좌표--%>
<%--        );--%>

<%--        // 지도의 이동을 서울시 범위로 제한--%>
<%--        kakao.maps.event.addListener(map, 'center_changed', function () {--%>
<%--            if (!bounds.contain(map.getCenter())) {--%>
<%--                // 현재 지도 중심이 서울시 범위를 벗어난 경우--%>
<%--                var currentCenter = map.getCenter();--%>

<%--                // 지도 중심이 서울시 범위 바깥으로 나갔을 때의 제한 처리--%>
<%--                var newCenter = new kakao.maps.LatLng(--%>
<%--                    Math.min(Math.max(currentCenter.getLat(), bounds.getSouthWest().getLat()), bounds.getNorthEast().getLat()),--%>
<%--                    Math.min(Math.max(currentCenter.getLng(), bounds.getSouthWest().getLng()), bounds.getNorthEast().getLng())--%>
<%--                );--%>

<%--                map.setCenter(newCenter); // 지도 중심을 서울시 범위 내로 고정--%>
<%--            }--%>
<%--        });--%>

<%--        // 확대/축소 레벨 제한--%>
<%--        kakao.maps.event.addListener(map, 'zoom_changed', function () {--%>
<%--            var level = map.getLevel();--%>
<%--            if (level > 10) { // 최대 축소 레벨을 10으로 제한--%>
<%--                map.setLevel(10); // 축소 레벨이 10을 넘으면 다시 10으로 되돌림--%>
<%--            }--%>
<%--        });--%>

<%--        // 서울시 구 선택 시 해당 구로 지도 이동--%>
<%--        $("#locationSelect").on("change", function () {--%>
<%--            if (map) {--%>
<%--                var coords = $(this).val().split(',');--%>
<%--                var latLng = new kakao.maps.LatLng(coords[0], coords[1]);--%>
<%--                map.setCenter(latLng);--%>
<%--                map.setLevel(8);--%>
<%--            }--%>
<%--        });--%>

<%--        // 지도 레벨 변경에 따른 경계 데이터 처리--%>
<%--        kakao.maps.event.addListener(map, 'zoom_changed', function () {--%>
<%--            var level = map.getLevel();--%>
<%--            console.log('Current zoom level:', level);--%>

<%--            // 확대/축소에 따른 경계 데이터 전환--%>
<%--            if (level <= 7) {--%>
<%--                if (!isEupMyeonDongLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadEupMyeonDongData();--%>
<%--                }--%>
<%--            } else if (level > 7 && level <= 9) {--%>
<%--                if (!isSiGunGuLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadSiGunGuData();--%>
<%--                }--%>
<%--            } else if (level > 9) {--%>
<%--                if (!isSiDoLoaded) {--%>
<%--                    removePolygons();--%>
<%--                    loadSiDoData();--%>
<%--                }--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    let chartInstance = null;--%>

<%--    // 지역 및 업종을 클릭했을 때 호출되는 함수--%>
<%--    function showRegionInfo(regionName, adminCode, serviceCode) {--%>
<%--        globalRegionName = regionName;  // 지역명을 전역 변수에 저장--%>
<%--        updateSelectedData({ bb_code: serviceCode }, adminCode); // 추가--%>
<%--        $.ajax({--%>
<%--            url: `/api/bizone/getChartDataForDetail`,--%>
<%--            method: 'GET',--%>
<%--            data: {--%>
<%--                admin_code: adminCode,  // 행정동 코드--%>
<%--                service_code: serviceCode  // 서비스 코드--%>
<%--            },--%>
<%--            success: function (data) {--%>
<%--                console.log('Received Data for Chart:', data);--%>

<%--                // 모달 창 업데이트 코드--%>
<%--                $('#regionName').text(regionName + " 상권분석");--%>
<%--                $('#selectedBusinessModal').text(selectedBusiness ? selectedBusiness.bb_name : '정보 없음');--%>

<%--                // 두 번째 모달 창 업데이트 코드 추가--%>
<%--                $('#detailedRegionName').text(globalRegionName || adminCode);  // 전역 변수 사용--%>

<%--                const chartData = {--%>
<%--                    labels: ['평균 임대료', '총 직장인구수', '총 소비 금액', '집객시설 수', '평균 월 매출', '기타'],--%>
<%--                    datasets: [{--%>
<%--                        label: '상권분석 데이터',--%>
<%--                        data: [--%>
<%--                            data.avgRentFeeScore.toFixed(2),--%>
<%--                            data.totalWorkplacePopulationScore.toFixed(2),--%>
<%--                            data.totalExpenditureScore.toFixed(2),--%>
<%--                            data.attractionCountScore.toFixed(2),--%>
<%--                            data.avgMonthlySalesScore.toFixed(2),--%>
<%--                            data.otherScoresTotal.toFixed(2)--%>
<%--                        ],--%>
<%--                        backgroundColor: 'rgba(54, 162, 235, 0.6)',--%>
<%--                        borderColor: 'rgba(54, 162, 235, 1)',--%>
<%--                        borderWidth: 1--%>
<%--                    }]--%>
<%--                };--%>

<%--                if (chartInstance) {--%>
<%--                    chartInstance.destroy();--%>
<%--                }--%>

<%--                const ctx = document.getElementById('regionChart').getContext('2d');--%>
<%--                chartInstance = new Chart(ctx, {--%>
<%--                    type: 'bar',--%>
<%--                    data: chartData,--%>
<%--                    options: {--%>
<%--                        scales: {--%>
<%--                            y: {--%>
<%--                                beginAtZero: true--%>
<%--                            }--%>
<%--                        }--%>
<%--                    }--%>
<%--                });--%>

<%--                const successProbability = parseFloat(data.successProbability).toFixed(2);--%>
<%--                $('#successProbability').text(successProbability + '%');--%>
<%--                const evaluation = getEvaluation(successProbability);--%>
<%--                $('#successEvaluation').text(evaluation);--%>

<%--                $('#regionModal').modal('show');--%>
<%--            },--%>
<%--            error: function () {--%>
<%--                alert("지역 및 업종 데이터를 불러오는 중 오류가 발생했습니다.");--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    let selectedServiceCode = null;--%>
<%--    let selectedAdminCode = null;--%>

<%--    // 업종과 지역 선택 시 데이터를 설정하는 함수--%>
<%--    function updateSelectedData(business, areaCode, areaName) {--%>
<%--        selectedServiceCode = business ? business.bb_code : null;--%>
<%--        selectedServiceName = business ? business.bb_name : '정보 없음'; // 업종명 저장--%>
<%--        selectedAdminCode = areaCode;--%>
<%--        selectedAdminName = areaName || '정보 없음'; // 지역명 저장--%>
<%--        console.log('Selected data updated:', selectedServiceCode, selectedAdminCode, selectedServiceName, selectedAdminName);--%>
<%--    }--%>

<%--    // 자세히 보기 버튼 클릭 이벤트 핸들러--%>
<%--    $('#detailbtn').on('click', function () {--%>
<%--        console.log('Before sending request, selectedServiceCode:', selectedServiceCode, 'selectedAdminCode:', selectedAdminCode);--%>

<%--        if (selectedServiceCode && selectedAdminCode) {--%>
<%--            // 지역명을 가져오는 AJAX 요청 추가--%>
<%--            $.ajax({--%>
<%--                url: `/api/bizone/getRegionName`,--%>
<%--                method: 'GET',--%>
<%--                data: { admin_code: selectedAdminCode },--%>
<%--                success: function (regionName) {--%>
<%--                    $('#detailedRegionName').text(regionName || selectedAdminCode); // 지역명 업데이트--%>
<%--                },--%>
<%--                error: function () {--%>
<%--                    $('#detailedRegionName').text(selectedAdminCode); // 오류 발생 시 코드 표시--%>
<%--                }--%>
<%--            });--%>

<%--            $.ajax({--%>
<%--                url: `/api/bizone/getDetailData`,--%>
<%--                method: 'GET',--%>
<%--                data: {--%>
<%--                    admin_code: selectedAdminCode,--%>
<%--                    service_code: selectedServiceCode--%>
<%--                },--%>
<%--                success: function (data) {--%>
<%--                    console.log('Detailed data received:', data);--%>

<%--                    // 모달 창에 데이터를 표시하는 로직--%>
<%--                    $('#detailedBusinessName').text(selectedBusiness.bb_name || selectedServiceCode);--%>
<%--                    $('#totalResidentPopulation').text(data.totalResidentPopulation);--%>
<%--                    $('#totalWorkplacePopulation').text(data.totalWorkplacePopulation);--%>
<%--                    $('#avgMonthlyIncome').text(data.avgMonthlyIncome);--%>
<%--                    $('#totalExpenditure').text(data.totalExpenditure);--%>
<%--                    $('#totalFloatingPopulation').text(data.totalFloatingPopulation);--%>
<%--                    $('#attractionCount').text(data.attractionCount);--%>
<%--                    $('#avgRentFee').text(data.avgRentFee);--%>
<%--                    $('#detailedModal').modal('show');--%>
<%--                },--%>
<%--                error: function (xhr, status, error) {--%>
<%--                    console.error('Error fetching detailed data:', error);--%>
<%--                    alert('자세한 데이터를 불러오는 중 오류가 발생했습니다.');--%>
<%--                }--%>
<%--            });--%>
<%--        } else {--%>
<%--            console.warn("업종과 지역 정보가 누락되었습니다.");--%>
<%--            alert("업종과 지역을 선택해주세요.");--%>
<%--        }--%>
<%--    });--%>

<%--    // 성공 확률 평가 함수--%>
<%--    function getEvaluation(score) {--%>
<%--        if (score >= 90) {--%>
<%--            return '매우 높음';--%>
<%--        } else if (score >= 70) {--%>
<%--            return '높음';--%>
<%--        } else if (score >= 50) {--%>
<%--            return '중간';--%>
<%--        } else if (score >= 30) {--%>
<%--            return '낮음';--%>
<%--        } else {--%>
<%--            return '매우 낮음';--%>
<%--        }--%>
<%--    }--%>

<%--    // GeoJSON 데이터를 불러와 경계선을 그리는 함수--%>
<%--    function loadGeoJson(url, type) {--%>
<%--        $.getJSON(url, function (data) {--%>
<%--            data.features.forEach(function (feature) {--%>
<%--                var path = feature.geometry.coordinates[0].map(function (coord) {--%>
<%--                    return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                });--%>

<%--                var polygon = new kakao.maps.Polygon({--%>
<%--                    map: map,--%>
<%--                    path: path,--%>
<%--                    fillColor: "rgba(30, 144, 255, 0.1)",--%>
<%--                    strokeColor: "#104486",--%>
<%--                    strokeWeight: 2,--%>
<%--                });--%>

<%--                kakao.maps.event.addListener(polygon, 'click', function () {--%>
<%--                    if (isBoundaryLoaded) {  // 경계 데이터가 켜져 있을 때만 실행--%>
<%--                        var regionName = feature.properties.adm_nm ?? feature.properties.sggnm;--%>
<%--                        showRegionInfo(regionName);  // 지역 이름 전달--%>
<%--                    }--%>
<%--                });--%>

<%--                polygons.push(polygon);--%>
<%--            });--%>
<%--        });--%>
<%--    }--%>

<%--    function loadSiDoData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulSi.geojson",  // 시도 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "시도");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulSi GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function loadSiGunGuData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulGu.geojson",  // 서울 구 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "시군구");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulGu GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function loadEupMyeonDongData() {--%>
<%--        $.ajax({--%>
<%--            url: "/resources/data/SeoulDong.geojson",  // 서울 동 경계 데이터--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                kkoMap.loadGeoJson(data, "읍면동");--%>
<%--            },--%>
<%--            error: function (jqXHR, textStatus, errorThrown) {--%>
<%--                console.error("Error loading SeoulDong GeoJSON data:", textStatus, errorThrown);--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    function removePolygons() {--%>
<%--        polygons.forEach(function (polygon) {--%>
<%--            polygon.setMap(null);--%>
<%--        });--%>
<%--        polygons = [];--%>

<%--        // 남아있는 overlaybox 제거--%>
<%--        if (customOverlay) {--%>
<%--            customOverlay.setMap(null);--%>
<%--        }--%>
<%--    }--%>

<%--    var kkoMap = {--%>
<%--        loadGeoJson: function (geoJsonData, type) {--%>
<%--            var fillColor, strokeColor;--%>
<%--            if (type === "읍면동") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)";--%>
<%--                strokeColor = "#104486";--%>
<%--            } else if (type === "시군구") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)";--%>
<%--                strokeColor = "#163599";--%>
<%--            } else if (type === "시도") {--%>
<%--                fillColor = "rgba(30, 144, 255, 0.1)"--%>
<%--                strokeColor = "#101e4e";--%>
<%--            }--%>

<%--            geoJsonData.features.forEach(function (feature) {--%>
<%--                kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);--%>
<%--            });--%>
<%--        },--%>

<%--        getPolygonData: function (feature) {--%>
<%--            var path = [];--%>
<%--            feature.geometry.coordinates.forEach(function (coords) {--%>
<%--                coords.forEach(function (innerCoords) {  // 다차원 좌표 처리--%>
<%--                    path.push(innerCoords.map(function (coord) {--%>
<%--                        return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                    }));--%>
<%--                });--%>
<%--            });--%>
<%--            return {--%>
<%--                code: feature.properties.adm_cd2,--%>
<%--                name: feature.properties.adm_nm ?? feature.properties.sggnm ?? feature.properties.sidonm,--%>
<%--                path: path--%>
<%--            };--%>
<%--        },--%>

<%--        setPolygon: function (area, fillColor, strokeColor, type) {--%>
<%--            var polygon = new kakao.maps.Polygon({--%>
<%--                path: area.path,--%>
<%--                strokeWeight: 2,--%>
<%--                strokeColor: strokeColor,--%>
<%--                strokeOpacity: 0.8,--%>
<%--                fillColor: fillColor,--%>
<%--                fillOpacity: 0.3,--%>
<%--            });--%>

<%--            let isMouseOver = false;--%>

<%--            kakao.maps.event.addListener(polygon, "mouseover", function () {--%>
<%--                if (!isMouseOver) {--%>
<%--                    isMouseOver = true;--%>
<%--                    polygon.setOptions({fillColor: type === "읍면동" ? "#0D94E8" : "#0031FD"});--%>
<%--                    customOverlay.setContent("<div class='overlaybox'>" + area.name + "</div>");--%>
<%--                    customOverlay.setMap(map);--%>
<%--                }--%>
<%--            });--%>

<%--            kakao.maps.event.addListener(polygon, "mousemove", function (mouseEvent) {--%>
<%--                if (isMouseOver) {--%>
<%--                    const offsetX = 35;--%>
<%--                    const offsetY = 35;--%>
<%--                    const projection = map.getProjection();--%>
<%--                    const point = projection.pointFromCoords(mouseEvent.latLng);--%>
<%--                    point.x += offsetX;--%>
<%--                    point.y += offsetY;--%>
<%--                    const newPosition = projection.coordsFromPoint(point);--%>
<%--                    customOverlay.setPosition(newPosition);--%>
<%--                }--%>
<%--            });--%>

<%--            kakao.maps.event.addListener(polygon, "mouseout", function () {--%>
<%--                if (isMouseOver) {--%>
<%--                    isMouseOver = false;--%>
<%--                    polygon.setOptions({fillColor: fillColor});--%>
<%--                    customOverlay.setMap(null);--%>
<%--                }--%>
<%--            });--%>

<%--            // 지역(폴리곤)을 클릭할 때 updateSelectedData 호출--%>
<%--            kakao.maps.event.addListener(polygon, "click", function () {--%>
<%--                console.log('Polygon Clicked:', area.name); // 클릭된 폴리곤 정보 확인--%>

<%--                if (!selectedBusiness || !selectedBusiness.bb_code) {--%>
<%--                    console.log('alert확인용 코드'); // 로그 추가--%>
<%--                    alert("업종을 선택해주세요.");--%>
<%--                    return; // 업종이 선택되지 않았으면 함수 종료--%>
<%--                }--%>

<%--                previousZoomLevel = map.getLevel(); // 클릭 시 현재 지도 레벨 저장--%>
<%--                selectedAdminCode = area.code; // 클릭한 지역의 행정동 코드 업데이트--%>

<%--                console.log('Clicked Area Code:', selectedAdminCode);  // 행정동 코드 확인--%>
<%--                console.log('Selected Business Code:', selectedBusiness ? selectedBusiness.bb_code : null);  // 선택된 업종 코드 확인--%>

<%--                // 선택된 업종과 행정동 코드를 updateSelectedData 함수로 업데이트--%>
<%--                updateSelectedData(selectedBusiness, selectedAdminCode, area.name);--%>

<%--                // showRegionInfo 함수에 행정동 이름과 행정동 코드, 그리고 선택된 업종 코드를 함께 전달--%>
<%--                showRegionInfo(area.name, selectedAdminCode, selectedBusiness ? selectedBusiness.bb_code : null);--%>

<%--                if (type === "읍면동") {--%>
<%--                    $("#eupMyeonDongSelectedArea").text("선택된 읍면동: " + area.name);--%>
<%--                } else if (type === "시군구") {--%>
<%--                    $("#siGunGuSelectedArea").text("선택된 시군구: " + area.name);--%>
<%--                } else if (type === "시도") {--%>
<%--                    $("#siDoSelectedArea").text("선택된 시도: " + area.name);--%>
<%--                }--%>
<%--                // 클릭 후 이전 확대 레벨을 유지하면서 중심 이동--%>
<%--                map.setCenter(kkoMap.centroid(area.path[0]));--%>
<%--                map.setLevel(previousZoomLevel);  // 이전 확대 레벨로 설정--%>
<%--            });--%>

<%--            polygon.setMap(map);--%>
<%--            polygons.push(polygon);--%>
<%--        },--%>

<%--        centroid: function (path) {--%>
<%--            let sumX = 0, sumY = 0, length = path.length;--%>
<%--            path.forEach(function (coord) {--%>
<%--                sumX += coord.getLng();--%>
<%--                sumY += coord.getLat();--%>
<%--            });--%>
<%--            return new kakao.maps.LatLng(sumY / length, sumX / length);--%>
<%--        },--%>
<%--    };--%>

<%--    $(document).ready(function () {--%>
<%--        initKakaoMap();  // Kakao 지도 초기화--%>
<%--        loadEupMyeonDongData();  // 페이지 로드 시 자동으로 읍면동 경계 데이터 로드--%>
<%--    });--%>

<%--    // 기존 검색된 마커 및 인포윈도우 제거 함수--%>
<%--    function removeSearchMarkers() {--%>
<%--        if (marker) {--%>
<%--            marker.setMap(null);--%>
<%--            marker = null;--%>
<%--        }--%>
<%--        if (infowindow) {--%>
<%--            infowindow.close();--%>
<%--            infowindow = null;--%>
<%--        }--%>
<%--    }--%>

<%--    // 지역 검색 기능 (마커와 인포윈도우 사용)--%>
<%--    $("#eupMyeonDongSearchButton").on("click", function () {--%>
<%--        var searchQuery = $("#eupMyeonDongSearch").val();--%>

<%--        if (!searchQuery) {--%>
<%--            alert("지역명을 입력하세요.");--%>
<%--            return;--%>
<%--        }--%>

<%--        // Kakao Geocoder를 사용하여 지역 검색--%>
<%--        var geocoder = new kakao.maps.services.Geocoder();--%>
<%--        geocoder.addressSearch(searchQuery, function (results, status) {--%>
<%--            if (status === kakao.maps.services.Status.OK) {--%>
<%--                var result = results[0];--%>
<%--                var coords = new kakao.maps.LatLng(result.y, result.x);--%>

<%--                // 기존 마커 및 인포윈도우 제거--%>
<%--                removeSearchMarkers();--%>

<%--                // 중심 좌표로 이동--%>
<%--                map.setCenter(coords);--%>
<%--                map.setLevel(5);--%>

<%--                // 마커 생성--%>
<%--                marker = new kakao.maps.Marker({--%>
<%--                    position: coords,--%>
<%--                    map: map--%>
<%--                });--%>

<%--                // 인포윈도우 생성--%>
<%--                var infowindowContent = '<div style="padding:5px;">' + result.address_name + '<br><a href="https://map.kakao.com/link/map/' + result.address_name + ',' + result.y + ',' + result.x + '" target="_blank">큰지도보기</a></div>';--%>

<%--                infowindow = new kakao.maps.InfoWindow({--%>
<%--                    content: infowindowContent,--%>
<%--                    removable: true--%>
<%--                });--%>

<%--                // 인포윈도우를 마커에 연결--%>
<%--                infowindow.open(map, marker);--%>
<%--            } else {--%>
<%--                alert("검색된 지역이 없습니다. 다시 시도하세요.");--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>

<%--    var businessData = [];--%>
<%--    var currentPage = 1;--%>
<%--    var resultsPerPage = 10;--%>

<%--    // 초성 변환 함수--%>
<%--    function getChosung(str) {--%>
<%--        const chosungList = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];--%>
<%--        let result = '';--%>
<%--        for (let i = 0; i < str.length; i++) {--%>
<%--            const code = str.charCodeAt(i) - 44032;--%>
<%--            if (code >= 0 && code <= 11171) {--%>
<%--                result += chosungList[Math.floor(code / 588)];--%>
<%--            } else {--%>
<%--                // 한글 자음이 아닌 경우 그대로 반환 (알파벳 등은 그대로 유지)--%>
<%--                result += str[i];--%>
<%--            }--%>
<%--        }--%>
<%--        return result;--%>
<%--    }--%>

<%--    // 검색어가 초성인지 여부를 판별하는 함수--%>
<%--    function isChosungInput(str) {--%>
<%--        return /^[ㄱ-ㅎ]+$/.test(str); // 입력 문자열이 초성만으로 구성된 경우 true 반환--%>
<%--    }--%>

<%--    // 검색 필터 함수--%>
<%--    function filterFunc(item) {--%>
<%--        const searchQuery = $('#businessCategorySearch').val().toLowerCase();--%>

<%--        if (isChosungInput(searchQuery)) {--%>
<%--            // 초성 검색 처리--%>
<%--            const searchQueryChosung = getChosung(searchQuery);--%>
<%--            const businessNameChosung = getChosung(item.bb_name.toLowerCase());--%>

<%--            // 입력된 초성이 포함되고, 정확한 초성 순서로 일치하는 항목만 반환--%>
<%--            return businessNameChosung.includes(searchQueryChosung) && checkExactChosungMatch(searchQuery, item.bb_name);--%>
<%--        } else {--%>
<%--            // 일반 텍스트 검색 처리--%>
<%--            return item.bb_name.toLowerCase().includes(searchQuery);--%>
<%--        }--%>
<%--    }--%>

<%--    // 초성과 실제 단어가 결합된 경우를 정확히 검사하는 함수--%>
<%--    function checkExactChosungMatch(searchQuery, businessName) {--%>
<%--        const searchChosung = getChosung(searchQuery);--%>
<%--        const businessNameChosung = getChosung(businessName);--%>

<%--        // 초성 비교를 위해 한 글자씩 확인--%>
<%--        for (let i = 0, j = 0; i < searchChosung.length && j < businessNameChosung.length; i++, j++) {--%>
<%--            // 만약 현재 비교 위치에서 자음이 동일하지만 모음까지 결합된 경우가 있다면 false 반환--%>
<%--            while (j < businessNameChosung.length && searchChosung[i] !== businessNameChosung[j]) {--%>
<%--                j++;--%>
<%--            }--%>
<%--            if (j >= businessNameChosung.length || searchChosung[i] !== businessNameChosung[j]) {--%>
<%--                return false; // 초성 순서가 다르거나 결합된 자음이 있음--%>
<%--            }--%>
<%--        }--%>
<%--        return true;--%>
<%--    }--%>

<%--    // 검색 결과를 화면에 표시--%>
<%--    function displayResults(filteredResults) {--%>
<%--        $('#searchResults').empty();--%>
<%--        if (filteredResults.length === 0) {--%>
<%--            $('#searchResults').append('<li>검색 결과가 없습니다.</li>');--%>
<%--            return;--%>
<%--        }--%>

<%--        // 모든 결과를 표시하고, 스크롤을 통해 넘길 수 있도록 함--%>
<%--        filteredResults.forEach(function (item) {--%>
<%--            const listItem = $('<li>' + item.bb_name + ' (' + item.bb_code + ')</li>');--%>

<%--            // 마우스 커서 올리면 강조 효과 추가--%>
<%--            listItem.css({--%>
<%--                'padding': '8px',--%>
<%--                'cursor': 'pointer'--%>
<%--            });--%>

<%--            listItem.hover(--%>
<%--                function () { // 마우스가 들어왔을 때--%>
<%--                    $(this).css('background-color', '#FF2C9760');--%>
<%--                },--%>
<%--                function () { // 마우스가 나갔을 때--%>
<%--                    $(this).css('background-color', '');--%>
<%--                }--%>
<%--            );--%>

<%--            // 클릭 이벤트 추가--%>
<%--            listItem.on('click', function () {--%>
<%--                selectedBusiness = item;--%>
<%--                updateSelectedData(selectedBusiness, selectedAdminCode);  // 선택한 업종과 현재 선택된 지역 코드로 함수 호출(추가10.10)--%>
<%--                displaySelectedBusiness();  // 선택된 업종 표시--%>
<%--            });--%>

<%--            $('#searchResults').append(listItem);--%>
<%--        });--%>

<%--        // 스크롤 처리--%>
<%--        $('#searchResults').css({--%>
<%--            'max-height': '200px', // 사이드바 높이에 맞춤--%>
<%--            'overflow-y': 'scroll' // 스크롤 가능하게 설정--%>
<%--        });--%>
<%--    }--%>

<%--    // 선택된 업종을 표시하는 함수--%>
<%--    function displaySelectedBusiness() {--%>
<%--        if (selectedBusiness) {--%>
<%--            $('#selectedBusiness').html('<p>선택된 업종: ' + selectedBusiness.bb_name + ' (' + selectedBusiness.bb_code + ')</p>');--%>
<%--        }--%>
<%--    }--%>

<%--    // 검색 버튼 클릭 시 검색 결과 필터링 및 표시--%>
<%--    $('#businessCategorySearchButton').on('click', function () {--%>
<%--        const searchQuery = $('#businessCategorySearch').val().toLowerCase();--%>

<%--        // 빈 검색어 입력 시 선택된 업종을 비우고 결과 초기화--%>
<%--        if (!searchQuery) {--%>
<%--            $('#searchResults').empty();--%>
<%--            $('#selectedBusiness').empty();--%>
<%--            selectedBusiness = null;  // 선택한 업종 초기화--%>
<%--            return;--%>
<%--        }--%>

<%--        // 필터링된 결과를 화면에 표시--%>
<%--        const filteredResults = businessData.filter(filterFunc);--%>
<%--        displayResults(filteredResults);--%>
<%--    });--%>

<%--    // 키보드 입력 시 자동완성 + 빈 입력란 처리--%>
<%--    $('#businessCategorySearch').on('input', function () {--%>
<%--        const searchQuery = $(this).val().toLowerCase();--%>

<%--        if (!searchQuery) {--%>
<%--            $('#searchResults').empty();--%>
<%--            $('#selectedBusiness').empty();--%>
<%--            selectedBusiness = null;  // 선택한 업종 초기화--%>
<%--            return;--%>
<%--        }--%>

<%--        const filteredResults = businessData.filter(filterFunc);--%>
<%--        displayResults(filteredResults);--%>
<%--    });--%>

<%--    // 데이터 로드--%>
<%--    $.ajax({--%>
<%--        url: '/api/bizone/services/all',  // API 엔드포인트--%>
<%--        method: 'GET',--%>
<%--        success: function (data) {--%>
<%--            console.log("AJAX 데이터 로드 성공:", data);  // 콘솔에 로드된 데이터 출력--%>
<%--            businessData = data;  // 가져온 데이터를 businessData에 저장--%>
<%--            // 첫 페이지에서는 검색창에 입력될 때만 결과를 표시하므로 초기 표시하지 않음--%>
<%--        },--%>
<%--        error: function (xhr, status, error) {--%>
<%--            console.error("Error fetching business data:", error);--%>
<%--        }--%>
<%--    });--%>

<%--    function sample5_execDaumPostcode() {--%>
<%--        new daum.Postcode({--%>
<%--            oncomplete: function (data) {--%>
<%--                var addr = data.address;--%>

<%--                document.getElementById("sample5_address").value = addr;--%>

<%--                var geocoder = new kakao.maps.services.Geocoder();--%>
<%--                geocoder.addressSearch(addr, function (results, status) {--%>
<%--                    if (status === kakao.maps.services.Status.OK) {--%>
<%--                        var result = results[0];--%>
<%--                        var coords = new kakao.maps.LatLng(result.y, result.x);--%>

<%--                        document.getElementById('mapContainer').style.display = "block";--%>
<%--                        map.relayout();--%>
<%--                        map.setCenter(coords);--%>
<%--                        map.setLevel(3);--%>

<%--                        if (marker) {--%>
<%--                            marker.setMap(null);--%>
<%--                        }--%>
<%--                        if (infowindow) {--%>
<%--                            infowindow.close();--%>
<%--                        }--%>

<%--                        marker = new kakao.maps.Marker({--%>
<%--                            position: coords,--%>
<%--                            map: map--%>
<%--                        });--%>

<%--                        var iwContent = '<div style="padding:5px;">' + addr + '<br><a href="https://map.kakao.com/link/map/' + addr + ',' + result.y + ',' + result.x + '" target="_blank"><img src="/resources/image/kakaomap.png" alt="카카오맵" style="width:44px; height:18px; margin-top:5px;"></a></div>';--%>

<%--                        infowindow = new kakao.maps.InfoWindow({--%>
<%--                            content: iwContent,--%>
<%--                            removable: true--%>
<%--                        });--%>

<%--                        infowindow.open(map, marker);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>
<%--        }).open();--%>
<%--    }--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>