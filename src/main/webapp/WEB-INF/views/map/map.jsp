<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>상권분석</title>
    <meta charset="UTF-8">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            margin: 0;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
        }

        .content {
            display: flex;
            height: calc(100vh);
            position: relative;
        }

        #mapContainer {
            flex-grow: 1;
            height: 100%;
        }

        #map {
            width: 100%;
            height: 100%;
        }

        #sidebar {
            width: 35%;
            max-width: 400px;
            background-color: rgba(255, 255, 255, 0.8);
            margin: 20px;
            box-shadow: 2px 0px 5px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
            font-family: Arial, sans-serif;
            z-index: 100;
            height: calc(100vh - 240px);
            border-radius: 5px;
            top: 100px;
            position: absolute;
        }

        div.header {
            z-index: 100;
            border-radius: 10px;
            margin: 20px;
            background-color: rgba(255, 255, 255, 0.8);
            box-shadow: 2px 0px 5px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
            width: 75%;
            height: 80px;
            padding: 10px;
        }

        #sidebar-content {
            padding: 20px;
            height: max-content;
        }

        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            margin-bottom: 20px;
        }

        .selected-categories {
            border-bottom: 1px solid #ccc;
            padding-bottom: 10px;
            margin-bottom: 10px;
            font-size: 14px;
        }

        div#sidebar-content > div {
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
        }

        input[type="text"] {
            flex: 1;
            box-sizing: border-box;
            width: 100%;
        }

        input[type="button"] {
            flex: 0 1 auto;
            box-sizing: border-box;
            width: auto;
            min-width: 10px;
        }

        .header {
            height: 100px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: sticky;
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
        }

        .overlaybox {
            background-color: hotpink;
            padding: 5px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        #boundaryToggleButton {
            margin-bottom: 20px;
            width: 100%;
            padding: 10px;
            border: 1px solid #FF2C97;
            border-radius: 5px;
            background-color: #FFB0DD80;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="content">
    <div class="header" style="position:absolute;">
        <h1>상권분석</h1>
    </div>
    <div id="sidebar">
        <div id="sidebar-content">
            <div style="display: flex; align-items: center; margin-bottom: 20px;">
                <input type="text" id="sample5_address" placeholder="주소 찾기" readonly
                       style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">
                <input type="button" id="search_button" onclick="sample5_execDaumPostcode()" value="주소 찾기"
                       style="padding: 10px; margin-left: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0; font-size: 16px; cursor: pointer;">
            </div>

            <div style="display: flex; align-items: center; margin-bottom: 20px;">
                <input type="text" id="eupMyeonDongSearch" placeholder="지역 검색"
                       style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">
                <input type="button" id="eupMyeonDongSearchButton" value="지역 검색"
                       style="padding: 10px; margin-left: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0; font-size: 16px; cursor: pointer;">
            </div>

            <div style="display: flex; align-items: center; margin-bottom: 20px;">
                <input type="text" id="businessCategorySearch" placeholder="업종 검색"
                       style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">
                <input type="button" id="businessCategorySearchButton" value="업종 검색"
                       style="padding: 10px; margin-left: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0; font-size: 16px; cursor: pointer;">
            </div>

            <ul id="searchResults"></ul>
            <div id="pagination" style="text-align: center; margin-top: 20px;"></div>
            <div id="selectedBusiness" style="margin-top: 20px;">
                <!-- 선택된 업종이 여기에 표시됩니다. -->
            </div>

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

            <!-- 단일 버튼으로 경계데이터 토글 -->
            <button id="boundaryToggleButton">경계데이터 켜기</button>

            <div id="eupMyeonDongSelectedArea" style="display: none;"></div>
            <div id="siGunGuSelectedArea" style="display: none;"></div>
        </div>
    </div>
    <div id="mapContainer">
        <div id="map"></div>
    </div>
</div>

<!-- 모달 창 관련 부분 -->
<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <h5 id="regionName">지역명</h5>
                <canvas id="regionChart" style="max-width: 100%;"></canvas>
                <div>선택된 업종: <strong id="selectedBusinessModal">정보 없음</strong></div>
                <hr/>
                <div>성공 확률: <strong id="successProbability">정보 없음</strong></div>
                <div>성공 확률 평가: <strong id="successEvaluation">정보 없음</strong></div>
                <hr/>
                <!-- 자세히 보기 버튼 추가 -->
                <a href="/map/detail" class="btn btn-primary">자세히 보기</a>
            </div>
        </div>
    </div>
</div>

<script>
    var map, customOverlay, polygons = [];
    var isBoundaryLoaded = false;
    var marker = null;
    var infowindow = null;

    // 경계 데이터 로드 상태를 추적하는 변수
    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부
    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부
    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부

    function initKakaoMap() {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 9,
        };
        map = new kakao.maps.Map(container, options);
        customOverlay = new kakao.maps.CustomOverlay({});

        var previousZoomLevel = map.getLevel();

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

            if (isBoundaryLoaded) {  // 경계 데이터가 켜져 있을 때만 작동
                if (level <= 6) {
                    if (!isEupMyeonDongLoaded) {  // 읍면동 경계가 안 켜져 있을 때만 불러오기
                        removePolygons();  // 기존 시군구 경계 제거
                        loadEupMyeonDongData();  // 읍면동 경계 불러오기
                        isEupMyeonDongLoaded = true;
                        isSiGunGuLoaded = false;
                        isSiDoLoaded = false;
                    }
                } else if (level >= 7 && level <= 9) {
                    if (!isSiGunGuLoaded) {  // 시군구 경계가 안 켜져 있을 때만 불러오기
                        removePolygons();  // 기존 나머지 경계 제거
                        loadSiGunGuData();  // 시군구 경계 불러오기
                        isSiGunGuLoaded = true;
                        isEupMyeonDongLoaded = false;
                        isSiDoLoaded = false;
                    }
                } else if (level >= 10 && level <= 12) {
                    if (!isSiDoLoaded) {  // 시도 경계가 안 켜져 있을 때만 불러오기
                        removePolygons();  // 기존 나머지 경계 제거
                        loadSiDoData();  // 시도 경계 불러오기
                        isSiDoLoaded = true;
                        isEupMyeonDongLoaded = false;
                        isSiGunGuLoaded = false;
                    }
                } else if (level >= 13) {
                    removePolygons();
                    isEupMyeonDongLoaded = false;
                    isSiGunGuLoaded = false;
                    isSiDoLoaded = false;
                    $("#boundaryToggleButton").text("경계데이터 켜기");  // 버튼 상태 변경
                    isBoundaryLoaded = false;  // 경계 데이터 해제
                }
            }

            if (level > 14) {
                map.setLevel(14);  // 최대 축소 레벨 제한
            }
        });
    }

    let chartInstance = null;

    // 모달 창에 지역 이름과 그래프 데이터를 표시하는 함수
    function showRegionInfo(regionName, adminCode, serviceCode) {
        $.ajax({
            url: `/api/bizone/getChartDataForDetail`,
            method: 'GET',
            data: {
                admin_code: adminCode,
                service_code: serviceCode
            },
            success: function (data) {
                // 실제 데이터를 바탕으로 모달 창 업데이트
                $('#regionName').text(regionName + " 상권분석");
                $('#selectedBusinessModal').text(selectedBusiness ? selectedBusiness.bb_name : '정보 없음');

                const chartData = {
                    labels: ['평균 임대료', '총 직장인구수', '총 지출 금액', '집객시설 수', '평균 월 매출', '기타'],
                    datasets: [{
                        label: '상권분석 데이터',
                        data: [
                            data.avgRentFee,
                            data.totalWorkplacePopulation,
                            data.totalExpenditure,
                            data.attractionCount,
                            data.avgMonthlySales,
                            data.기타
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
                                beginAtZero: true
                            }
                        }
                    }
                });

                // 성공 확률과 평가 업데이트
                const successProbability = calculateSuccessProbability(data); // 성공 확률 계산 로직에 따라 변경
                $('#successProbability').text(successProbability + '%');
                const evaluation = getEvaluation(successProbability);
                $('#successEvaluation').text(evaluation);

                $('#regionModal').modal('show'); // 모달 창 열기
            },
            error: function () {
                alert("데이터를 불러오는 중 오류가 발생했습니다.");
            }
        });
    }

    // // 모달 창에 지역 이름과 그래프 데이터를 표시하는 함수
    // function showRegionInfo(regionName) {
    //     $('#regionName').text(regionName + " 상권분석");
    //     $('#selectedBusinessModal').text(selectedBusiness ? selectedBusiness.bb_name : '정보 없음');
    //
    //     const chartData = {
    //         labels: ['평균 월매출', '총 직장인구수', '지역 집객시설 수', '지역 지출 총금액', '평균 임대료', '기타'],
    //         datasets: [{
    //             label: '상권분석 데이터',
    //             data: [300, 5000, 10, 7000, 1000, 200], // 예시 데이터, 실제 데이터로 교체 필요
    //             backgroundColor: 'rgba(54, 162, 235, 0.6)',
    //             borderColor: 'rgba(54, 162, 235, 1)',
    //             borderWidth: 1
    //         }]
    //     };
    //
    //     if (chartInstance) {
    //         chartInstance.destroy();
    //     }
    //
    //     const ctx = document.getElementById('regionChart').getContext('2d');
    //     chartInstance = new Chart(ctx, {
    //         type: 'bar',
    //         data: chartData,
    //         options: {
    //             scales: {
    //                 y: {
    //                     beginAtZero: true
    //                 }
    //             }
    //         }
    //     });
    //
    //     // 성공 확률과 평가 업데이트
    //     const successProbability = 85; // 예시 점수, 실제 계산된 값으로 교체 필요
    //     $('#successProbability').text(successProbability + '%');
    //     const evaluation = getEvaluation(successProbability);
    //     $('#successEvaluation').text(evaluation);
    //
    //     $('#regionModal').modal('show'); // 모달 창 열기
    // }

    // 성공 확률 평가 함수
    function getEvaluation(score) {
        if (score >= 90) {
            return '매우 높음';
        } else if (score >= 70) {
            return '높음';
        } else if (score >= 50) {
            return '중간';
        } else if (score >= 30) {
            return '낮음';
        } else {
            return '매우 낮음';
        }
    }

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
                kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, type);
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
                code: feature.properties?.adm_cd2,
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
                fillOpacity: 0.3,
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

            kakao.maps.event.addListener(polygon, "click", function () {
                previousZoomLevel = map.getLevel();  // 현재 확대 레벨을 저장

                console.log(area.code)

                showRegionInfo(null, area.code, "CS100007");

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

    // 버튼 토글
    function toggleBoundaryData() {
        if (!selectedBusiness) {  // 업종이 선택되지 않은 경우
            alert("업종을 먼저 검색해주세요.");  // 경고 메시지 표시
            return;  // 버튼 기능 작동 중지
        }

        if (isBoundaryLoaded) {
            removePolygons();
            isBoundaryLoaded = false;
            $("#boundaryToggleButton").text("경계데이터 켜기");
        } else {
            var level = map.getLevel();
            if (level <= 6) {
                loadEupMyeonDongData();
                isEupMyeonDongLoaded = true;
            } else if (level >= 7 && level <= 9) {
                loadSiGunGuData();
                isSiGunGuLoaded = true;
            } else if (level >= 10 && level <= 12) {
                loadSiDoData();
                isSiDoLoaded = true;
            }
            isBoundaryLoaded = true;
            $("#boundaryToggleButton").text("경계데이터 끄기");
        }
    }

    $(document).ready(function () {
        initKakaoMap();
        // 버튼 클릭 이벤트 설정
        $("#boundaryToggleButton").on("click", toggleBoundaryData);
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
    var selectedBusiness = null;  // 선택된 업종을 저장할 변수

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

<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>상권분석</title>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>--%>
<%--    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>--%>
<%--    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>--%>
<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>--%>
<%--    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>--%>
<%--    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>--%>
<%--    <style>--%>
<%--        body {--%>
<%--            margin: 0;--%>
<%--            display: flex;--%>
<%--            flex-direction: column;--%>
<%--            overflow-y: auto;--%>
<%--        }--%>

<%--        .content {--%>
<%--            display: flex;--%>
<%--            height: calc(100vh);--%>
<%--            position: relative;--%>
<%--        }--%>

<%--        #mapContainer {--%>
<%--            flex-grow: 1;--%>
<%--            height: 100%;--%>
<%--        }--%>

<%--        #map {--%>
<%--            width: 100%;--%>
<%--            height: 100%;--%>
<%--        }--%>

<%--        #sidebar {--%>
<%--            width: 35%;--%>
<%--            max-width: 400px;--%>
<%--            background-color: rgba(255, 255, 255, 0.8);--%>
<%--            margin: 20px;--%>
<%--            box-shadow: 2px 0px 5px rgba(0, 0, 0, 0.1);--%>
<%--            box-sizing: border-box;--%>
<%--            font-family: Arial, sans-serif;--%>
<%--            z-index: 100;--%>
<%--            height: calc(100vh - 240px);--%>
<%--            border-radius: 5px;--%>
<%--            top: 100px;--%>
<%--            position: absolute;--%>
<%--        }--%>

<%--        div.header {--%>
<%--            z-index: 100;--%>
<%--            border-radius: 10px;--%>
<%--            margin: 20px;--%>
<%--            background-color: rgba(255, 255, 255, 0.8);--%>
<%--            box-shadow: 2px 0px 5px rgba(0, 0, 0, 0.1);--%>
<%--            box-sizing: border-box;--%>
<%--            width: 75%;--%>
<%--            height: 80px;--%>
<%--            padding: 10px;--%>
<%--        }--%>

<%--        #sidebar-content {--%>
<%--            padding: 20px;--%>
<%--            height: max-content;--%>
<%--        }--%>

<%--        select {--%>
<%--            width: 100%;--%>
<%--            padding: 10px;--%>
<%--            border: 1px solid #ccc;--%>
<%--            border-radius: 5px;--%>
<%--            font-size: 16px;--%>
<%--            margin-bottom: 20px;--%>
<%--        }--%>

<%--        .selected-categories {--%>
<%--            border-bottom: 1px solid #ccc;--%>
<%--            padding-bottom: 10px;--%>
<%--            margin-bottom: 10px;--%>
<%--            font-size: 14px;--%>
<%--        }--%>

<%--        div#sidebar-content > div {--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            gap: 10px;--%>
<%--            width: 100%;--%>
<%--        }--%>

<%--        input[type="text"] {--%>
<%--            flex: 1;--%>
<%--            box-sizing: border-box;--%>
<%--            width: 100%;--%>
<%--        }--%>

<%--        input[type="button"] {--%>
<%--            flex: 0 1 auto;--%>
<%--            box-sizing: border-box;--%>
<%--            width: auto;--%>
<%--            min-width: 10px;--%>
<%--        }--%>

<%--        .header {--%>
<%--            height: 100px;--%>
<%--            background-color: #f8f9fa;--%>
<%--            display: flex;--%>
<%--            align-items: center;--%>
<%--            justify-content: space-between;--%>
<%--            padding: 0 20px;--%>
<%--            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);--%>
<%--            position: sticky;--%>
<%--        }--%>

<%--        .header h1 {--%>
<%--            margin: 0;--%>
<%--            font-size: 24px;--%>
<%--        }--%>

<%--        .overlaybox {--%>
<%--            background-color: hotpink;--%>
<%--            padding: 5px 10px;--%>
<%--            border-radius: 4px;--%>
<%--            border: 1px solid #ccc;--%>
<%--            font-size: 14px;--%>
<%--        }--%>

<%--        #boundaryToggleButton {--%>
<%--            margin-bottom: 20px;--%>
<%--            width: 100%;--%>
<%--            padding: 10px;--%>
<%--            border: 1px solid #FF2C97;--%>
<%--            border-radius: 5px;--%>
<%--            background-color: #FFB0DD80;--%>
<%--            font-size: 16px;--%>
<%--            cursor: pointer;--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="content">--%>
<%--    <div class="header" style="position:absolute;">--%>
<%--        <h1>상권분석</h1>--%>
<%--    </div>--%>
<%--    <div id="sidebar">--%>
<%--        <div id="sidebar-content">--%>
<%--            <div style="display: flex; align-items: center; margin-bottom: 20px;">--%>
<%--                <input type="text" id="sample5_address" placeholder="주소 찾기" readonly--%>
<%--                       style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">--%>
<%--                <input type="button" id="search_button" onclick="sample5_execDaumPostcode()" value="주소 찾기"--%>
<%--                       style="padding: 10px; margin-left: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0; font-size: 16px; cursor: pointer;">--%>
<%--            </div>--%>

<%--            <div style="display: flex; align-items: center; margin-bottom: 20px;">--%>
<%--                <input type="text" id="eupMyeonDongSearch" placeholder="지역 검색"--%>
<%--                       style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">--%>
<%--                <input type="button" id="eupMyeonDongSearchButton" value="지역 검색"--%>
<%--                       style="padding: 10px; margin-left: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0; font-size: 16px; cursor: pointer;">--%>
<%--            </div>--%>

<%--            <div style="display: flex; align-items: center; margin-bottom: 20px;">--%>
<%--                <input type="text" id="businessCategorySearch" placeholder="업종 검색"--%>
<%--                       style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">--%>
<%--                <input type="button" id="businessCategorySearchButton" value="업종 검색"--%>
<%--                       style="padding: 10px; margin-left: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0; font-size: 16px; cursor: pointer;">--%>
<%--            </div>--%>

<%--            <ul id="searchResults"></ul>--%>
<%--            <div id="pagination" style="text-align: center; margin-top: 20px;"></div>--%>
<%--            <div id="selectedBusiness" style="margin-top: 20px;">--%>
<%--                <!-- 선택된 업종이 여기에 표시됩니다. -->--%>
<%--            </div>--%>

<%--            <select id="locationSelect">--%>
<%--                <option selected disabled>서울시 구 바로가기</option>--%>
<%--                <option value="37.5172363,127.0473248">강남구</option>--%>
<%--                <option value="37.5511,127.1465">강동구</option>--%>
<%--                <option value="37.6397743,127.0259653">강북구</option>--%>
<%--                <option value="37.5509787,126.8495384">강서구</option>--%>
<%--                <option value="37.4784064,126.9516133">관악구</option>--%>
<%--                <option value="37.5384841,127.0822934">광진구</option>--%>
<%--                <option value="37.4954856,126.8877243">구로구</option>--%>
<%--                <option value="37.4568502,126.8958117">금천구</option>--%>
<%--                <option value="37.6541916,127.0567936">노원구</option>--%>
<%--                <option value="37.6686912,127.0472104">도봉구</option>--%>
<%--                <option value="37.5742915,127.0395685">동대문구</option>--%>
<%--                <option value="37.5124095,126.9395078">동작구</option>--%>
<%--                <option value="37.5663244,126.9014017">마포구</option>--%>
<%--                <option value="37.5791433,126.9369178">서대문구</option>--%>
<%--                <option value="37.4836042,127.0327595">서초구</option>--%>
<%--                <option value="37.5632561,127.0364285">성동구</option>--%>
<%--                <option value="37.5893624,127.0167415">성북구</option>--%>
<%--                <option value="37.5145436,127.1059163">송파구</option>--%>
<%--                <option value="37.5270616,126.8561536">양천구</option>--%>
<%--                <option value="37.5263614,126.8966016">영등포구</option>--%>
<%--                <option value="37.5322958,126.9904348">용산구</option>--%>
<%--                <option value="37.6026956,126.9291993">은평구</option>--%>
<%--                <option value="37.573293,126.979672">종로구</option>--%>
<%--                <option value="37.5636152,126.9979403">중구</option>--%>
<%--                <option value="37.6063241,127.092728">중랑구</option>--%>
<%--            </select>--%>

<%--            <!-- 단일 버튼으로 경계데이터 토글 -->--%>
<%--            <button id="boundaryToggleButton">경계데이터 켜기</button>--%>

<%--            <div id="eupMyeonDongSelectedArea" style="display: none;"></div>--%>
<%--            <div id="siGunGuSelectedArea" style="display: none;"></div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div id="mapContainer">--%>
<%--        <div id="map"></div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<!-- 모달 창 관련 부분 -->--%>
<%--<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <div class="modal-body">--%>
<%--                <h5 id="regionName">지역명</h5>--%>
<%--                <canvas id="regionChart" style="max-width: 100%;"></canvas>--%>
<%--                <div>선택된 업종: <strong id="selectedBusinessModal">정보 없음</strong></div>--%>
<%--                <hr/>--%>
<%--                <div>성공 확률: <strong id="successProbability">정보 없음</strong></div>--%>
<%--                <div>성공 확률 평가: <strong id="successEvaluation">정보 없음</strong></div>--%>
<%--                <hr/>--%>
<%--                <!-- 자세히 보기 버튼 추가 -->--%>
<%--                <a href="/map/detail" class="btn btn-primary">자세히 보기</a>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    function initKakaoMap() {--%>
<%--        var container = document.getElementById('map');--%>
<%--        var options = {--%>
<%--            center: new kakao.maps.LatLng(37.5665, 126.9780),--%>
<%--            level: 9,--%>
<%--        };--%>
<%--        map = new kakao.maps.Map(container, options);--%>
<%--        customOverlay = new kakao.maps.CustomOverlay({});--%>

<%--        var previousZoomLevel = map.getLevel();--%>

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

<%--            if (isBoundaryLoaded) {  // 경계 데이터가 켜져 있을 때만 작동--%>
<%--                if (level <= 6) {--%>
<%--                    if (!isEupMyeonDongLoaded) {  // 읍면동 경계가 안 켜져 있을 때만 불러오기--%>
<%--                        removePolygons();  // 기존 시군구 경계 제거--%>
<%--                        loadEupMyeonDongData();  // 읍면동 경계 불러오기--%>
<%--                        isEupMyeonDongLoaded = true;--%>
<%--                        isSiGunGuLoaded = false;--%>
<%--                        isSiDoLoaded = false;--%>
<%--                    }--%>
<%--                } else if (level >= 7 && level <= 9) {--%>
<%--                    if (!isSiGunGuLoaded) {  // 시군구 경계가 안 켜져 있을 때만 불러오기--%>
<%--                        removePolygons();  // 기존 나머지 경계 제거--%>
<%--                        loadSiGunGuData();  // 시군구 경계 불러오기--%>
<%--                        isSiGunGuLoaded = true;--%>
<%--                        isEupMyeonDongLoaded = false;--%>
<%--                        isSiDoLoaded = false;--%>
<%--                    }--%>
<%--                } else if (level >= 10 && level <= 12) {--%>
<%--                    if (!isSiDoLoaded) {  // 시도 경계가 안 켜져 있을 때만 불러오기--%>
<%--                        removePolygons();  // 기존 나머지 경계 제거--%>
<%--                        loadSiDoData();  // 시도 경계 불러오기--%>
<%--                        isSiDoLoaded = true;--%>
<%--                        isEupMyeonDongLoaded = false;--%>
<%--                        isSiGunGuLoaded = false;--%>
<%--                    }--%>
<%--                } else if (level >= 13) {--%>
<%--                    removePolygons();--%>
<%--                    isEupMyeonDongLoaded = false;--%>
<%--                    isSiGunGuLoaded = false;--%>
<%--                    isSiDoLoaded = false;--%>
<%--                    $("#boundaryToggleButton").text("경계데이터 켜기");  // 버튼 상태 변경--%>
<%--                    isBoundaryLoaded = false;  // 경계 데이터 해제--%>
<%--                }--%>
<%--            }--%>

<%--            if (level > 14) {--%>
<%--                map.setLevel(14);  // 최대 축소 레벨 제한--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    let chartInstance = null;--%>

<%--    // 모달 창에 지역 이름과 그래프 데이터를 표시하는 함수--%>
<%--    function showRegionInfo(regionName) {--%>
<%--        $('#regionName').text(regionName + " 상권분석");--%>
<%--        $('#selectedBusinessModal').text(selectedBusiness ? selectedBusiness.bb_name : '정보 없음');--%>

<%--        const chartData = {--%>
<%--            labels: ['평균 월매출', '총 직장인구수', '지역 집객시설 수', '지역 지출 총금액', '평균 임대료', '기타'],--%>
<%--            datasets: [{--%>
<%--                label: '상권분석 데이터',--%>
<%--                data: [300, 5000, 10, 7000, 1000, 200], // 예시 데이터, 실제 데이터로 교체 필요--%>
<%--                backgroundColor: 'rgba(54, 162, 235, 0.6)',--%>
<%--                borderColor: 'rgba(54, 162, 235, 1)',--%>
<%--                borderWidth: 1--%>
<%--            }]--%>
<%--        };--%>

<%--        if (chartInstance) {--%>
<%--            chartInstance.destroy();--%>
<%--        }--%>

<%--        const ctx = document.getElementById('regionChart').getContext('2d');--%>
<%--        chartInstance = new Chart(ctx, {--%>
<%--            type: 'bar',--%>
<%--            data: chartData,--%>
<%--            options: {--%>
<%--                scales: {--%>
<%--                    y: {--%>
<%--                        beginAtZero: true--%>
<%--                    }--%>
<%--                }--%>
<%--            }--%>
<%--        });--%>

<%--        // 성공 확률과 평가 업데이트--%>
<%--        const successProbability = 85; // 예시 점수, 실제 계산된 값으로 교체 필요--%>
<%--        $('#successProbability').text(successProbability + '%');--%>
<%--        const evaluation = getEvaluation(successProbability);--%>
<%--        $('#successEvaluation').text(evaluation);--%>

<%--        $('#regionModal').modal('show'); // 모달 창 열기--%>
<%--    }--%>

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

<%--            kakao.maps.event.addListener(polygon, "click", function () {--%>
<%--                previousZoomLevel = map.getLevel();  // 현재 확대 레벨을 저장--%>

<%--                showRegionInfo(area.name);--%>

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

<%--    // 버튼 토글--%>
<%--    function toggleBoundaryData() {--%>
<%--        if (!selectedBusiness) {  // 업종이 선택되지 않은 경우--%>
<%--            alert("업종을 먼저 검색해주세요.");  // 경고 메시지 표시--%>
<%--            return;  // 버튼 기능 작동 중지--%>
<%--        }--%>

<%--        if (isBoundaryLoaded) {--%>
<%--            removePolygons();--%>
<%--            isBoundaryLoaded = false;--%>
<%--            $("#boundaryToggleButton").text("경계데이터 켜기");--%>
<%--        } else {--%>
<%--            var level = map.getLevel();--%>
<%--            if (level <= 6) {--%>
<%--                loadEupMyeonDongData();--%>
<%--                isEupMyeonDongLoaded = true;--%>
<%--            } else if (level >= 7 && level <= 9) {--%>
<%--                loadSiGunGuData();--%>
<%--                isSiGunGuLoaded = true;--%>
<%--            } else if (level >= 10 && level <= 12) {--%>
<%--                loadSiDoData();--%>
<%--                isSiDoLoaded = true;--%>
<%--            }--%>
<%--            isBoundaryLoaded = true;--%>
<%--            $("#boundaryToggleButton").text("경계데이터 끄기");--%>
<%--        }--%>
<%--    }--%>

<%--    $(document).ready(function () {--%>
<%--        initKakaoMap();--%>
<%--        // 버튼 클릭 이벤트 설정--%>
<%--        $("#boundaryToggleButton").on("click", toggleBoundaryData);--%>
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
<%--    var selectedBusiness = null;  // 선택된 업종을 저장할 변수--%>

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
<%--        url: '/services/all',  // API 엔드포인트--%>
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
