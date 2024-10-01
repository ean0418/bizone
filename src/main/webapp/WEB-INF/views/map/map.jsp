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

        button {
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

            <select id="largeCategory">
                <option selected disabled>업종 대분류 선택</option>
            </select>

            <select id="middleCategory" disabled>
                <option selected disabled>중분류 선택</option>
            </select>

            <select id="smallCategory" disabled>
                <option selected disabled>소분류 선택</option>
            </select>

            <div class="selected-categories">
                <div>대분류: <span id="selectedLarge"></span></div>
                <div>중분류: <span id="selectedMedium"></span></div>
                <div>소분류: <span id="selectedSmall"></span></div>
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
            <div class="modal-header">
                <h5 class="modal-title" id="regionModalLabel">지역 정보</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <h5 id="regionName">지역명</h5>
                <ul id="regionDetails">
                    <li>인구 수: <span id="population">정보 없음</span></li>
                    <li>업종 수: <span id="businessCount">정보 없음</span></li>
                    <li>상업 밀도: <span id="commercialDensity">정보 없음</span></li>
                    <li>유동 인구: <span id="floatingPopulation">정보 없음</span></li>
                    <li>임대료 평균: <span id="averageRent">정보 없음</span></li>
                </ul>
                <hr />
                <div>총합 점수: <strong id="totalScore">정보 없음</strong></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<script>
    var map, customOverlay, polygons = [];
    var isBoundaryLoaded = false;
    var marker = null;
    var infowindow = null;
    var overlayVisible = false;
    var searchPolygons = [];

    // 경계 데이터 로드 상태를 추적하는 변수
    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부
    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부
    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부

    const serviceKey = 'w9FXvIN3+LWgl4iLJ3oj6lRTmIWY8+tbn5ToqYBuj7CJ0aKMfTqEYndsCsfS+DCAno9Rznj3aUTDx4MyHUgHVw==';

    $(document).ready(function () {
        // 대분류 데이터 가져오기
        $.ajax({
            url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/largeUpjongList',
            type: 'GET',
            data: {
                servicekey: serviceKey,
                type: 'json'
            },
            success: function (response) {
                const largeCategories = response.body.items;
                largeCategories.forEach(function (category) {
                    $('#largeCategory').append(new Option(category.indsLclsNm, category.indsLclsCd));
                });
            },
            error: function (error) {
                console.log('대분류 데이터 불러오기 실패:', error);
            }
        });

        // 대분류 선택 시 중분류 불러오기
        $('#largeCategory').change(function () {
            const largeCategoryCode = $(this).val();
            const largeCategoryName = $('#largeCategory option:selected').text();
            $('#middleCategory').empty().append(new Option('중분류 선택', ''));
            $('#smallCategory').empty().append(new Option('소분류 선택', ''));
            $('#middleCategory').prop('disabled', false);

            if (largeCategoryCode) {
                $.ajax({
                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/middleUpjongList',
                    type: 'GET',
                    data: {
                        servicekey: serviceKey,
                        indsLclsCd: largeCategoryCode,
                        type: 'json'
                    },
                    success: function (response) {
                        const middleCategories = response.body.items;
                        middleCategories.forEach(function (category) {
                            $('#middleCategory').append(new Option(category.indsMclsNm, category.indsMclsCd));
                        });
                    },
                    error: function (error) {
                        console.log('중분류 데이터 불러오기 실패:', error);
                    }
                });
            }

            // 선택된 대분류 코드 및 이름 표시
            $('#selectedLarge').text(largeCategoryName + ' (' + largeCategoryCode + ')');
            $('#selectedMedium').text('');
            $('#selectedSmall').text('');
        });

        // 중분류 선택 시 소분류 불러오기
        $('#middleCategory').change(function () {
            const middleCategoryCode = $(this).val();
            const middleCategoryName = $('#middleCategory option:selected').text();
            $('#smallCategory').empty().append(new Option('소분류 선택', ''));
            $('#smallCategory').prop('disabled', false);

            if (middleCategoryCode) {
                $.ajax({
                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/smallUpjongList',
                    type: 'GET',
                    data: {
                        servicekey: serviceKey,
                        indsMclsCd: middleCategoryCode,
                        type: 'json'
                    },
                    success: function (response) {
                        const smallCategories = response.body.items;
                        smallCategories.forEach(function (category) {
                            $('#smallCategory').append(new Option(category.indsSclsNm, category.indsSclsCd));
                        });
                    },
                    error: function (error) {
                        console.log('소분류 데이터 불러오기 실패:', error);
                    }
                });
            }

            // 선택된 중분류 코드 및 이름 표시
            $('#selectedMedium').text(middleCategoryName + ' (' + middleCategoryCode + ')');
            $('#selectedSmall').text('');
        });

        // 소분류 선택 시 선택한 항목 표시
        $('#smallCategory').change(function () {
            const selectedSmallName = $('#smallCategory option:selected').text();
            const selectedSmallCode = $(this).val();

            const selectedLarge = $('#largeCategory option:selected').text();
            const selectedLargeCode = $('#largeCategory').val();
            const selectedMedium = $('#middleCategory option:selected').text();
            const selectedMediumCode = $('#middleCategory').val();

            // 선택된 소분류 코드 및 이름 표시
            $('#selectedSmall').text(selectedSmallName + ' (' + selectedSmallCode + ')');
        });
    });

    function initKakaoMap() {
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 9,
        };
        map = new kakao.maps.Map(container, options);
        customOverlay = new kakao.maps.CustomOverlay({});

        // 경계 데이터가 켜졌을 때만 클릭 이벤트 작동
        kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
            if (!isBoundaryLoaded) return;  // 경계 데이터가 꺼져있으면 클릭 이벤트 처리 안함
            var clickedInPolygon = polygons.some(function(polygon) {
                return kakao.maps.geometry.poly.contains(polygon.getPath(), mouseEvent.latLng);
            });

            if (!clickedInPolygon) return;  // 폴리곤 내 클릭이 아닌 경우 모달을 열지 않음
        });

        var previousZoomLevel = map.getLevel();

        // 지도 클릭 시 모달 띄우기 예시
        kakao.maps.event.addListener(map, 'click', function (mouseEvent) {
            if (!isBoundaryLoaded) return;  // 경계데이터가 켜지지 않은 상태에서는 동작 안함


            // 모달에 표시할 예시 데이터
            showRegionInfo(
                '예시 지역',    // 지역명
                '100,000명',     // 인구 수
                '5,000개',       // 업종 수
                '높음',          // 상업 밀도
                '500,000명',     // 유동 인구
                '200만원',       // 임대료 평균
                '85점'           // 총합 점수
            );
        });

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

    // 모달 창에 지역 이름을 표시하는 함수
    function showRegionInfo(regionName) {
        $('#regionName').text(regionName + " 상권분석");  // 클릭한 지역명 표시
        $('#population').text('정보 없음');  // 기본 데이터 설정 (실제 데이터 입력 가능)
        $('#businessCount').text('정보 없음');
        $('#commercialDensity').text('정보 없음');
        $('#floatingPopulation').text('정보 없음');
        $('#averageRent').text('정보 없음');
        $('#totalScore').text('정보 없음');
        $('#regionModal').modal('show');  // 모달 창 열기
    }

    // GeoJSON 데이터를 불러와 경계선을 그리는 함수
    function loadGeoJson(url, type) {
        $.getJSON(url, function(data) {
            data.features.forEach(function(feature) {
                var path = feature.geometry.coordinates[0].map(function(coord) {
                    return new kakao.maps.LatLng(coord[1], coord[0]);
                });

                var polygon = new kakao.maps.Polygon({
                    map: map,
                    path: path,
                    fillColor: "rgba(30, 144, 255, 0.1)",
                    strokeColor: "#104486",
                    strokeWeight: 2,
                });

                kakao.maps.event.addListener(polygon, 'click', function() {
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

                showRegionInfo(area.name);

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

    // 모달 닫기 버튼 문제 해결
    $(document).on('click', '.close', function() {
        $('#regionModal').modal('hide');
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

<%-- 모달 창 오류 수정2 --%>
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

<%--        button {--%>
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

<%--            <select id="largeCategory">--%>
<%--                <option selected disabled>업종 대분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="middleCategory" disabled>--%>
<%--                <option selected disabled>중분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="smallCategory" disabled>--%>
<%--                <option selected disabled>소분류 선택</option>--%>
<%--            </select>--%>

<%--            <div class="selected-categories">--%>
<%--                <div>대분류: <span id="selectedLarge"></span></div>--%>
<%--                <div>중분류: <span id="selectedMedium"></span></div>--%>
<%--                <div>소분류: <span id="selectedSmall"></span></div>--%>
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

<%--&lt;%&ndash; 모달 창 관련 부분 &ndash;%&gt;--%>
<%--<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <div class="modal-header">--%>
<%--                <h5 class="modal-title" id="regionModalLabel">지역 정보</h5>--%>
<%--                <button type="button" class="close" data-dismiss="modal" aria-label="Close">--%>
<%--                    <span aria-hidden="true">&times;</span>--%>
<%--                </button>--%>
<%--            </div>--%>
<%--            <div class="modal-body">--%>
<%--                <h5 id="regionName">지역명</h5>--%>
<%--                <ul id="regionDetails">--%>
<%--                    <li>인구 수: <span id="population">정보 없음</span></li>--%>
<%--                    <li>업종 수: <span id="businessCount">정보 없음</span></li>--%>
<%--                    <li>상업 밀도: <span id="commercialDensity">정보 없음</span></li>--%>
<%--                    <li>유동 인구: <span id="floatingPopulation">정보 없음</span></li>--%>
<%--                    <li>임대료 평균: <span id="averageRent">정보 없음</span></li>--%>
<%--                </ul>--%>
<%--                <hr />--%>
<%--                <div>총합 점수: <strong id="totalScore">정보 없음</strong></div>--%>
<%--            </div>--%>
<%--            <div class="modal-footer">--%>
<%--                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>
<%--    var overlayVisible = false;--%>
<%--    var searchPolygons = [];--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    const serviceKey = 'w9FXvIN3+LWgl4iLJ3oj6lRTmIWY8+tbn5ToqYBuj7CJ0aKMfTqEYndsCsfS+DCAno9Rznj3aUTDx4MyHUgHVw==';--%>

<%--    $(document).ready(function () {--%>
<%--        // 대분류 데이터 가져오기--%>
<%--        $.ajax({--%>
<%--            url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/largeUpjongList',--%>
<%--            type: 'GET',--%>
<%--            data: {--%>
<%--                servicekey: serviceKey,--%>
<%--                type: 'json'--%>
<%--            },--%>
<%--            success: function (response) {--%>
<%--                const largeCategories = response.body.items;--%>
<%--                largeCategories.forEach(function (category) {--%>
<%--                    $('#largeCategory').append(new Option(category.indsLclsNm, category.indsLclsCd));--%>
<%--                });--%>
<%--            },--%>
<%--            error: function (error) {--%>
<%--                console.log('대분류 데이터 불러오기 실패:', error);--%>
<%--            }--%>
<%--        });--%>

<%--        // 대분류 선택 시 중분류 불러오기--%>
<%--        $('#largeCategory').change(function () {--%>
<%--            const largeCategoryCode = $(this).val();--%>
<%--            const largeCategoryName = $('#largeCategory option:selected').text();--%>
<%--            $('#middleCategory').empty().append(new Option('중분류 선택', ''));--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#middleCategory').prop('disabled', false);--%>

<%--            if (largeCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/middleUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsLclsCd: largeCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const middleCategories = response.body.items;--%>
<%--                        middleCategories.forEach(function (category) {--%>
<%--                            $('#middleCategory').append(new Option(category.indsMclsNm, category.indsMclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('중분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 대분류 코드 및 이름 표시--%>
<%--            $('#selectedLarge').text(largeCategoryName + ' (' + largeCategoryCode + ')');--%>
<%--            $('#selectedMedium').text('');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 중분류 선택 시 소분류 불러오기--%>
<%--        $('#middleCategory').change(function () {--%>
<%--            const middleCategoryCode = $(this).val();--%>
<%--            const middleCategoryName = $('#middleCategory option:selected').text();--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#smallCategory').prop('disabled', false);--%>

<%--            if (middleCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/smallUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsMclsCd: middleCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const smallCategories = response.body.items;--%>
<%--                        smallCategories.forEach(function (category) {--%>
<%--                            $('#smallCategory').append(new Option(category.indsSclsNm, category.indsSclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('소분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 중분류 코드 및 이름 표시--%>
<%--            $('#selectedMedium').text(middleCategoryName + ' (' + middleCategoryCode + ')');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 소분류 선택 시 선택한 항목 표시--%>
<%--        $('#smallCategory').change(function () {--%>
<%--            const selectedSmallName = $('#smallCategory option:selected').text();--%>
<%--            const selectedSmallCode = $(this).val();--%>

<%--            const selectedLarge = $('#largeCategory option:selected').text();--%>
<%--            const selectedLargeCode = $('#largeCategory').val();--%>
<%--            const selectedMedium = $('#middleCategory option:selected').text();--%>
<%--            const selectedMediumCode = $('#middleCategory').val();--%>

<%--            // 선택된 소분류 코드 및 이름 표시--%>
<%--            $('#selectedSmall').text(selectedSmallName + ' (' + selectedSmallCode + ')');--%>
<%--        });--%>
<%--    });--%>

<%--    function initKakaoMap() {--%>
<%--        var container = document.getElementById('map');--%>
<%--        var options = {--%>
<%--            center: new kakao.maps.LatLng(37.5665, 126.9780),--%>
<%--            level: 9,--%>
<%--        };--%>
<%--        map = new kakao.maps.Map(container, options);--%>
<%--        customOverlay = new kakao.maps.CustomOverlay({});--%>

<%--        // 경계 데이터가 켜졌을 때만 클릭 이벤트 작동--%>
<%--        kakao.maps.event.addListener(map, 'click', function(mouseEvent) {--%>
<%--            if (!isBoundaryLoaded) return;  // 경계 데이터가 꺼져있으면 클릭 이벤트 처리 안함--%>
<%--        });--%>

<%--        var previousZoomLevel = map.getLevel();--%>

<%--        // 지도 클릭 시 모달 띄우기 예시--%>
<%--        kakao.maps.event.addListener(map, 'click', function (mouseEvent) {--%>
<%--            if (!isBoundaryLoaded) return;  // 경계데이터가 켜지지 않은 상태에서는 동작 안함--%>
<%--            // 모달에 표시할 예시 데이터--%>
<%--            showRegionInfo(--%>
<%--                '예시 지역',    // 지역명--%>
<%--                '100,000명',     // 인구 수--%>
<%--                '5,000개',       // 업종 수--%>
<%--                '높음',          // 상업 밀도--%>
<%--                '500,000명',     // 유동 인구--%>
<%--                '200만원',       // 임대료 평균--%>
<%--                '85점'           // 총합 점수--%>
<%--            );--%>
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

<%--    // 모달 창에 지역 이름을 표시하는 함수--%>
<%--    function showRegionInfo(regionName) {--%>
<%--        $('#regionName').text(regionName + " 상권분석");  // 클릭한 지역명 표시--%>
<%--        $('#population').text('정보 없음');  // 기본 데이터 설정 (실제 데이터 입력 가능)--%>
<%--        $('#businessCount').text('정보 없음');--%>
<%--        $('#commercialDensity').text('정보 없음');--%>
<%--        $('#floatingPopulation').text('정보 없음');--%>
<%--        $('#averageRent').text('정보 없음');--%>
<%--        $('#totalScore').text('정보 없음');--%>
<%--        $('#regionModal').modal('show');  // 모달 창 열기--%>
<%--    }--%>

<%--    // GeoJSON 데이터를 불러와 경계선을 그리는 함수--%>
<%--    function loadGeoJson(url, type) {--%>
<%--        $.getJSON(url, function(data) {--%>
<%--            data.features.forEach(function(feature) {--%>
<%--                var path = feature.geometry.coordinates[0].map(function(coord) {--%>
<%--                    return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                });--%>

<%--                var polygon = new kakao.maps.Polygon({--%>
<%--                    map: map,--%>
<%--                    path: path,--%>
<%--                    fillColor: "rgba(30, 144, 255, 0.1)",--%>
<%--                    strokeColor: "#104486",--%>
<%--                    strokeWeight: 2,--%>
<%--                });--%>

<%--                kakao.maps.event.addListener(polygon, 'click', function() {--%>
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


<%-- 모달창 이슈 --%>
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

<%--        button {--%>
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

<%--            <select id="largeCategory">--%>
<%--                <option selected disabled>업종 대분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="middleCategory" disabled>--%>
<%--                <option selected disabled>중분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="smallCategory" disabled>--%>
<%--                <option selected disabled>소분류 선택</option>--%>
<%--            </select>--%>

<%--            <div class="selected-categories">--%>
<%--                <div>대분류: <span id="selectedLarge"></span></div>--%>
<%--                <div>중분류: <span id="selectedMedium"></span></div>--%>
<%--                <div>소분류: <span id="selectedSmall"></span></div>--%>
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

<%--&lt;%&ndash; 모달 창 관련 부분 &ndash;%&gt;--%>
<%--<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <div class="modal-header">--%>
<%--                <h5 class="modal-title" id="regionModalLabel">지역 정보</h5>--%>
<%--                <button type="button" class="close" data-dismiss="modal" aria-label="Close">--%>
<%--                    <span aria-hidden="true">&times;</span>--%>
<%--                </button>--%>
<%--            </div>--%>
<%--            <div class="modal-body">--%>
<%--                <h5 id="regionName">지역명</h5>--%>
<%--                <ul id="regionDetails">--%>
<%--                    <li>인구 수: <span id="population">정보 없음</span></li>--%>
<%--                    <li>업종 수: <span id="businessCount">정보 없음</span></li>--%>
<%--                    <li>상업 밀도: <span id="commercialDensity">정보 없음</span></li>--%>
<%--                    <li>유동 인구: <span id="floatingPopulation">정보 없음</span></li>--%>
<%--                    <li>임대료 평균: <span id="averageRent">정보 없음</span></li>--%>
<%--                </ul>--%>
<%--                <hr />--%>
<%--                <div>총합 점수: <strong id="totalScore">정보 없음</strong></div>--%>
<%--            </div>--%>
<%--            <div class="modal-footer">--%>
<%--                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>
<%--    var overlayVisible = false;--%>
<%--    var searchPolygons = [];--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    const serviceKey = 'w9FXvIN3+LWgl4iLJ3oj6lRTmIWY8+tbn5ToqYBuj7CJ0aKMfTqEYndsCsfS+DCAno9Rznj3aUTDx4MyHUgHVw==';--%>

<%--    $(document).ready(function () {--%>
<%--        // 대분류 데이터 가져오기--%>
<%--        $.ajax({--%>
<%--            url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/largeUpjongList',--%>
<%--            type: 'GET',--%>
<%--            data: {--%>
<%--                servicekey: serviceKey,--%>
<%--                type: 'json'--%>
<%--            },--%>
<%--            success: function (response) {--%>
<%--                const largeCategories = response.body.items;--%>
<%--                largeCategories.forEach(function (category) {--%>
<%--                    $('#largeCategory').append(new Option(category.indsLclsNm, category.indsLclsCd));--%>
<%--                });--%>
<%--            },--%>
<%--            error: function (error) {--%>
<%--                console.log('대분류 데이터 불러오기 실패:', error);--%>
<%--            }--%>
<%--        });--%>

<%--        // 대분류 선택 시 중분류 불러오기--%>
<%--        $('#largeCategory').change(function () {--%>
<%--            const largeCategoryCode = $(this).val();--%>
<%--            const largeCategoryName = $('#largeCategory option:selected').text();--%>
<%--            $('#middleCategory').empty().append(new Option('중분류 선택', ''));--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#middleCategory').prop('disabled', false);--%>

<%--            if (largeCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/middleUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsLclsCd: largeCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const middleCategories = response.body.items;--%>
<%--                        middleCategories.forEach(function (category) {--%>
<%--                            $('#middleCategory').append(new Option(category.indsMclsNm, category.indsMclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('중분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 대분류 코드 및 이름 표시--%>
<%--            $('#selectedLarge').text(largeCategoryName + ' (' + largeCategoryCode + ')');--%>
<%--            $('#selectedMedium').text('');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 중분류 선택 시 소분류 불러오기--%>
<%--        $('#middleCategory').change(function () {--%>
<%--            const middleCategoryCode = $(this).val();--%>
<%--            const middleCategoryName = $('#middleCategory option:selected').text();--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#smallCategory').prop('disabled', false);--%>

<%--            if (middleCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/smallUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsMclsCd: middleCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const smallCategories = response.body.items;--%>
<%--                        smallCategories.forEach(function (category) {--%>
<%--                            $('#smallCategory').append(new Option(category.indsSclsNm, category.indsSclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('소분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 중분류 코드 및 이름 표시--%>
<%--            $('#selectedMedium').text(middleCategoryName + ' (' + middleCategoryCode + ')');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 소분류 선택 시 선택한 항목 표시--%>
<%--        $('#smallCategory').change(function () {--%>
<%--            const selectedSmallName = $('#smallCategory option:selected').text();--%>
<%--            const selectedSmallCode = $(this).val();--%>

<%--            const selectedLarge = $('#largeCategory option:selected').text();--%>
<%--            const selectedLargeCode = $('#largeCategory').val();--%>
<%--            const selectedMedium = $('#middleCategory option:selected').text();--%>
<%--            const selectedMediumCode = $('#middleCategory').val();--%>

<%--            // 선택된 소분류 코드 및 이름 표시--%>
<%--            $('#selectedSmall').text(selectedSmallName + ' (' + selectedSmallCode + ')');--%>
<%--        });--%>
<%--    });--%>

<%--    function initKakaoMap() {--%>
<%--        var container = document.getElementById('map');--%>
<%--        var options = {--%>
<%--            center: new kakao.maps.LatLng(37.5665, 126.9780),--%>
<%--            level: 9,--%>
<%--        };--%>
<%--        map = new kakao.maps.Map(container, options);--%>
<%--        customOverlay = new kakao.maps.CustomOverlay({});--%>

<%--        // 경계 데이터가 켜졌을 때만 클릭 이벤트 작동--%>
<%--        kakao.maps.event.addListener(map, 'click', function(mouseEvent) {--%>
<%--            if (!isBoundaryLoaded) return;  // 경계 데이터가 꺼져있으면 클릭 이벤트 처리 안함--%>
<%--        });--%>

<%--        var previousZoomLevel = map.getLevel();--%>

<%--        // 지도 클릭 시 모달 띄우기 예시--%>
<%--        kakao.maps.event.addListener(map, 'click', function (mouseEvent) {--%>
<%--            // 모달에 표시할 예시 데이터--%>
<%--            showRegionInfo(--%>
<%--                '예시 지역',    // 지역명--%>
<%--                '100,000명',     // 인구 수--%>
<%--                '5,000개',       // 업종 수--%>
<%--                '높음',          // 상업 밀도--%>
<%--                '500,000명',     // 유동 인구--%>
<%--                '200만원',       // 임대료 평균--%>
<%--                '85점'           // 총합 점수--%>
<%--            );--%>
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

<%--    // 모달 창에 지역 이름을 표시하는 함수--%>
<%--    function showRegionInfo(regionName) {--%>
<%--        $('#regionName').text(regionName + " 상권분석");  // 클릭한 지역명 표시--%>
<%--        $('#population').text('정보 없음');  // 기본 데이터 설정 (실제 데이터 입력 가능)--%>
<%--        $('#businessCount').text('정보 없음');--%>
<%--        $('#commercialDensity').text('정보 없음');--%>
<%--        $('#floatingPopulation').text('정보 없음');--%>
<%--        $('#averageRent').text('정보 없음');--%>
<%--        $('#totalScore').text('정보 없음');--%>
<%--        $('#regionModal').modal('show');  // 모달 창 열기--%>
<%--    }--%>

<%--    // GeoJSON 데이터를 불러와 경계선을 그리는 함수--%>
<%--    function loadGeoJson(url, type) {--%>
<%--        $.getJSON(url, function(data) {--%>
<%--            data.features.forEach(function(feature) {--%>
<%--                var path = feature.geometry.coordinates[0].map(function(coord) {--%>
<%--                    return new kakao.maps.LatLng(coord[1], coord[0]);--%>
<%--                });--%>

<%--                var polygon = new kakao.maps.Polygon({--%>
<%--                    map: map,--%>
<%--                    path: path,--%>
<%--                    fillColor: "rgba(30, 144, 255, 0.1)",--%>
<%--                    strokeColor: "#104486",--%>
<%--                    strokeWeight: 2,--%>
<%--                });--%>

<%--                kakao.maps.event.addListener(polygon, 'click', function() {--%>
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


<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>상권분석</title>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>--%>
<%--    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>--%>
<%--    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>--%>
<%--    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">--%>
<%--    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>--%>
<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>--%>
<%--    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>--%>

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

<%--        button {--%>
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

<%--            <select id="largeCategory">--%>
<%--                <option selected disabled>업종 대분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="middleCategory" disabled>--%>
<%--                <option selected disabled>중분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="smallCategory" disabled>--%>
<%--                <option selected disabled>소분류 선택</option>--%>
<%--            </select>--%>

<%--            <div class="selected-categories">--%>
<%--                <div>대분류: <span id="selectedLarge"></span></div>--%>
<%--                <div>중분류: <span id="selectedMedium"></span></div>--%>
<%--                <div>소분류: <span id="selectedSmall"></span></div>--%>
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

<%--&lt;%&ndash; 모달 창 관련 부분 &ndash;%&gt;--%>
<%--<div class="modal fade" id="regionModal" tabindex="-1" role="dialog" aria-labelledby="regionModalLabel" aria-hidden="true">--%>
<%--    <div class="modal-dialog" role="document">--%>
<%--        <div class="modal-content">--%>
<%--            <div class="modal-header">--%>
<%--                <h5 class="modal-title" id="regionModalLabel">지역 정보</h5>--%>
<%--                <button type="button" class="close" data-dismiss="modal" aria-label="Close">--%>
<%--                    <span aria-hidden="true">&times;</span>--%>
<%--                </button>--%>
<%--            </div>--%>
<%--            <div class="modal-body">--%>
<%--                <h5 id="regionName">지역명</h5>--%>
<%--                <ul id="regionDetails">--%>
<%--                    <li>인구 수: <span id="population">정보 없음</span></li>--%>
<%--                    <li>업종 수: <span id="businessCount">정보 없음</span></li>--%>
<%--                    <li>상업 밀도: <span id="commercialDensity">정보 없음</span></li>--%>
<%--                    <li>유동 인구: <span id="floatingPopulation">정보 없음</span></li>--%>
<%--                    <li>임대료 평균: <span id="averageRent">정보 없음</span></li>--%>
<%--                </ul>--%>
<%--                <hr />--%>
<%--                <div>총합 점수: <strong id="totalScore">정보 없음</strong></div>--%>
<%--            </div>--%>
<%--            <div class="modal-footer">--%>
<%--                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>
<%--    var overlayVisible = false;--%>
<%--    var searchPolygons = [];--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    const serviceKey = 'w9FXvIN3+LWgl4iLJ3oj6lRTmIWY8+tbn5ToqYBuj7CJ0aKMfTqEYndsCsfS+DCAno9Rznj3aUTDx4MyHUgHVw==';--%>

<%--    $(document).ready(function () {--%>
<%--        // 대분류 데이터 가져오기--%>
<%--        $.ajax({--%>
<%--            url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/largeUpjongList',--%>
<%--            type: 'GET',--%>
<%--            data: {--%>
<%--                servicekey: serviceKey,--%>
<%--                type: 'json'--%>
<%--            },--%>
<%--            success: function (response) {--%>
<%--                const largeCategories = response.body.items;--%>
<%--                largeCategories.forEach(function (category) {--%>
<%--                    $('#largeCategory').append(new Option(category.indsLclsNm, category.indsLclsCd));--%>
<%--                });--%>
<%--            },--%>
<%--            error: function (error) {--%>
<%--                console.log('대분류 데이터 불러오기 실패:', error);--%>
<%--            }--%>
<%--        });--%>

<%--        // 대분류 선택 시 중분류 불러오기--%>
<%--        $('#largeCategory').change(function () {--%>
<%--            const largeCategoryCode = $(this).val();--%>
<%--            const largeCategoryName = $('#largeCategory option:selected').text();--%>
<%--            $('#middleCategory').empty().append(new Option('중분류 선택', ''));--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#middleCategory').prop('disabled', false);--%>

<%--            if (largeCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/middleUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsLclsCd: largeCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const middleCategories = response.body.items;--%>
<%--                        middleCategories.forEach(function (category) {--%>
<%--                            $('#middleCategory').append(new Option(category.indsMclsNm, category.indsMclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('중분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 대분류 코드 및 이름 표시--%>
<%--            $('#selectedLarge').text(largeCategoryName + ' (' + largeCategoryCode + ')');--%>
<%--            $('#selectedMedium').text('');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 중분류 선택 시 소분류 불러오기--%>
<%--        $('#middleCategory').change(function () {--%>
<%--            const middleCategoryCode = $(this).val();--%>
<%--            const middleCategoryName = $('#middleCategory option:selected').text();--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#smallCategory').prop('disabled', false);--%>

<%--            if (middleCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/smallUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsMclsCd: middleCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const smallCategories = response.body.items;--%>
<%--                        smallCategories.forEach(function (category) {--%>
<%--                            $('#smallCategory').append(new Option(category.indsSclsNm, category.indsSclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('소분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 중분류 코드 및 이름 표시--%>
<%--            $('#selectedMedium').text(middleCategoryName + ' (' + middleCategoryCode + ')');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 소분류 선택 시 선택한 항목 표시--%>
<%--        $('#smallCategory').change(function () {--%>
<%--            const selectedSmallName = $('#smallCategory option:selected').text();--%>
<%--            const selectedSmallCode = $(this).val();--%>

<%--            const selectedLarge = $('#largeCategory option:selected').text();--%>
<%--            const selectedLargeCode = $('#largeCategory').val();--%>
<%--            const selectedMedium = $('#middleCategory option:selected').text();--%>
<%--            const selectedMediumCode = $('#middleCategory').val();--%>

<%--            // 선택된 소분류 코드 및 이름 표시--%>
<%--            $('#selectedSmall').text(selectedSmallName + ' (' + selectedSmallCode + ')');--%>
<%--        });--%>
<%--    });--%>

<%--    function initKakaoMap() {--%>
<%--        var container = document.getElementById('map');--%>
<%--        var options = {--%>
<%--            center: new kakao.maps.LatLng(37.5665, 126.9780),--%>
<%--            level: 9,--%>
<%--        };--%>
<%--        map = new kakao.maps.Map(container, options);--%>
<%--        customOverlay = new kakao.maps.CustomOverlay({});--%>

<%--        var previousZoomLevel = map.getLevel();--%>

<%--        // 지도 클릭 시 모달 띄우기 예시--%>
<%--        kakao.maps.event.addListener(map, 'click', function (mouseEvent) {--%>
<%--            // 모달에 표시할 예시 데이터--%>
<%--            showRegionInfo(--%>
<%--                '예시 지역',    // 지역명--%>
<%--                '100,000명',     // 인구 수--%>
<%--                '5,000개',       // 업종 수--%>
<%--                '높음',          // 상업 밀도--%>
<%--                '500,000명',     // 유동 인구--%>
<%--                '200만원',       // 임대료 평균--%>
<%--                '85점'           // 총합 점수--%>
<%--            );--%>
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

<%--    // 모달창을 띄우는 함수--%>
<%--    function showRegionInfo(regionName) {--%>
<%--        $('#regionName').text(regionName + " 상권분석");  // 지역명 상권분석--%>
<%--        $('#population').text('정보 없음');  // 실제 데이터가 없으므로 기본값--%>
<%--        $('#businessCount').text('정보 없음');--%>
<%--        $('#commercialDensity').text('정보 없음');--%>
<%--        $('#floatingPopulation').text('정보 없음');--%>
<%--        $('#averageRent').text('정보 없음');--%>
<%--        $('#totalScore').text('정보 없음');--%>

<%--        // 모달 창 띄우기--%>
<%--        $('#regionModal').modal('show');--%>
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

<%-- 서울시 한정, api로 분류 가져오는 기능 추가 --%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>상권분석</title>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>--%>
<%--    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>--%>
<%--    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>--%>
<%--    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">--%>

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

<%--        button {--%>
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

<%--            <select id="largeCategory">--%>
<%--                <option selected disabled>업종 대분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="middleCategory" disabled>--%>
<%--                <option selected disabled>중분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="smallCategory" disabled>--%>
<%--                <option selected disabled>소분류 선택</option>--%>
<%--            </select>--%>

<%--            <div class="selected-categories">--%>
<%--                <div>대분류: <span id="selectedLarge"></span></div>--%>
<%--                <div>중분류: <span id="selectedMedium"></span></div>--%>
<%--                <div>소분류: <span id="selectedSmall"></span></div>--%>
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

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>
<%--    var overlayVisible = false;--%>
<%--    var searchPolygons = [];--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    const serviceKey = 'w9FXvIN3+LWgl4iLJ3oj6lRTmIWY8+tbn5ToqYBuj7CJ0aKMfTqEYndsCsfS+DCAno9Rznj3aUTDx4MyHUgHVw==';--%>

<%--    $(document).ready(function () {--%>
<%--        // 대분류 데이터 가져오기--%>
<%--        $.ajax({--%>
<%--            url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/largeUpjongList',--%>
<%--            type: 'GET',--%>
<%--            data: {--%>
<%--                servicekey: serviceKey,--%>
<%--                type: 'json'--%>
<%--            },--%>
<%--            success: function (response) {--%>
<%--                const largeCategories = response.body.items;--%>
<%--                largeCategories.forEach(function (category) {--%>
<%--                    $('#largeCategory').append(new Option(category.indsLclsNm, category.indsLclsCd));--%>
<%--                });--%>
<%--            },--%>
<%--            error: function (error) {--%>
<%--                console.log('대분류 데이터 불러오기 실패:', error);--%>
<%--            }--%>
<%--        });--%>

<%--        // 대분류 선택 시 중분류 불러오기--%>
<%--        $('#largeCategory').change(function () {--%>
<%--            const largeCategoryCode = $(this).val();--%>
<%--            const largeCategoryName = $('#largeCategory option:selected').text();--%>
<%--            $('#middleCategory').empty().append(new Option('중분류 선택', ''));--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#middleCategory').prop('disabled', false);--%>

<%--            if (largeCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/middleUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsLclsCd: largeCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const middleCategories = response.body.items;--%>
<%--                        middleCategories.forEach(function (category) {--%>
<%--                            $('#middleCategory').append(new Option(category.indsMclsNm, category.indsMclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('중분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 대분류 코드 및 이름 표시--%>
<%--            $('#selectedLarge').text(largeCategoryName + ' (' + largeCategoryCode + ')');--%>
<%--            $('#selectedMedium').text('');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 중분류 선택 시 소분류 불러오기--%>
<%--        $('#middleCategory').change(function () {--%>
<%--            const middleCategoryCode = $(this).val();--%>
<%--            const middleCategoryName = $('#middleCategory option:selected').text();--%>
<%--            $('#smallCategory').empty().append(new Option('소분류 선택', ''));--%>
<%--            $('#smallCategory').prop('disabled', false);--%>

<%--            if (middleCategoryCode) {--%>
<%--                $.ajax({--%>
<%--                    url: 'http://apis.data.go.kr/B553077/api/open/sdsc2/smallUpjongList',--%>
<%--                    type: 'GET',--%>
<%--                    data: {--%>
<%--                        servicekey: serviceKey,--%>
<%--                        indsMclsCd: middleCategoryCode,--%>
<%--                        type: 'json'--%>
<%--                    },--%>
<%--                    success: function (response) {--%>
<%--                        const smallCategories = response.body.items;--%>
<%--                        smallCategories.forEach(function (category) {--%>
<%--                            $('#smallCategory').append(new Option(category.indsSclsNm, category.indsSclsCd));--%>
<%--                        });--%>
<%--                    },--%>
<%--                    error: function (error) {--%>
<%--                        console.log('소분류 데이터 불러오기 실패:', error);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            // 선택된 중분류 코드 및 이름 표시--%>
<%--            $('#selectedMedium').text(middleCategoryName + ' (' + middleCategoryCode + ')');--%>
<%--            $('#selectedSmall').text('');--%>
<%--        });--%>

<%--        // 소분류 선택 시 선택한 항목 표시--%>
<%--        $('#smallCategory').change(function () {--%>
<%--            const selectedSmallName = $('#smallCategory option:selected').text();--%>
<%--            const selectedSmallCode = $(this).val();--%>

<%--            const selectedLarge = $('#largeCategory option:selected').text();--%>
<%--            const selectedLargeCode = $('#largeCategory').val();--%>
<%--            const selectedMedium = $('#middleCategory option:selected').text();--%>
<%--            const selectedMediumCode = $('#middleCategory').val();--%>

<%--            // 선택된 소분류 코드 및 이름 표시--%>
<%--            $('#selectedSmall').text(selectedSmallName + ' (' + selectedSmallCode + ')');--%>
<%--        });--%>
<%--    });--%>

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

<%--수정 전 코드--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>상권분석</title>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>--%>
<%--    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>--%>
<%--    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>--%>
<%--    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">--%>

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

<%--        button {--%>
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
<%--                <input type="text" id="eupMyeonDongSearch" placeholder="지역 검색" style="flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px;">--%>
<%--                <input type="button" id="eupMyeonDongSearchButton" value="지역 검색" style="padding: 10px; margin-left: 10px; border: 1px solid #ccc; border-radius: 5px; background-color: #f0f0f0; font-size: 16px; cursor: pointer;">--%>
<%--            </div>--%>

<%--            <select id="industrySelect">--%>
<%--                <option selected disabled>업종 대분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="subIndustrySelect" disabled>--%>
<%--                <option selected disabled>중분류 선택</option>--%>
<%--            </select>--%>

<%--            <select id="smallIndustrySelect" disabled>--%>
<%--                <option selected disabled>소분류 선택</option>--%>
<%--            </select>--%>

<%--            <div class="selected-categories">--%>
<%--                <div>대분류: <span id="selectedLarge"></span></div>--%>
<%--                <div>중분류: <span id="selectedMedium"></span></div>--%>
<%--                <div>소분류: <span id="selectedSmall"></span></div>--%>
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

<%--<script>--%>
<%--    var map, customOverlay, polygons = [];--%>
<%--    var isBoundaryLoaded = false;--%>
<%--    var marker = null;--%>
<%--    var infowindow = null;--%>
<%--    var overlayVisible = false;--%>
<%--    var searchPolygons = [];--%>

<%--    // 경계 데이터 로드 상태를 추적하는 변수--%>
<%--    var isEupMyeonDongLoaded = false;  // 읍면동 경계 데이터 로드 여부--%>
<%--    var isSiGunGuLoaded = false;  // 시군구 경계 데이터 로드 여부--%>
<%--    var isSiDoLoaded = false;   // 시도 경계 데이터 로드 여부--%>

<%--    var industryData = {--%>
<%--        "농업, 임업 및 어업": {--%>
<%--            "농업": ['작물 재배업', '축산업', '작물재배 및 축산 관련 서비스업', '작물재배 및 축산 복합농업', '수렵 및 관련 서비스업'],--%>
<%--            "임업": ['임업'],--%>
<%--            "어업": ['어로 어업', '양식어업 및 어업관련 서비스업']--%>
<%--        },--%>
<%--        "광업": {--%>
<%--            "석탄, 원유 및 천연가스 광업": ['석탄 광업', '원유 및 천연가스 채굴업'],--%>
<%--            "비금속광물 광업; 연료용 제외": ['기타 비금속광물 광업', '토사석 광업'],--%>
<%--            "금속 광업": ['철 광업', '비철금속 광업'],--%>
<%--            "광업 지원 서비스업": ['광업 지원 서비스업']--%>
<%--        },--%>
<%--        "제조업": {--%>
<%--            "식료품 제조업": ['도축, 육류 가공 및 저장 처리업', '수산물 가공 및 저장 처리업', '과실, 채소 가공 및 저장 처리업', '동물성 및 식물성 유지 제조업', '낙농제품 및 식용 빙과류 제조업', '곡물 가공품, 전분 및 전분제품 제조업', '동물용 사료 및 조제식품 제조업', '기타 식품 제조업'],--%>
<%--            "음료 제조업": ['알코올 음료 제조업', '비알코올 음료 및 얼음 제조업'],--%>
<%--            "담배 제조업": ['담배 제조업'],--%>
<%--            "섬유제품 제조업; 의복 제외": ['방적 및 가공사 제조업', '직물 직조 및 직물제품 제조업', '섬유제품 염색, 정리 및 마무리 가공업', '기타 섬유제품 제조업', '편조 원단 제조업'],--%>
<%--            "자동차 및 트레일러 제조업": ['자동차 신품 부품 제조업', '자동차용 엔진 및 자동차 제조업', '자동차 차체 및 트레일러 제조업', '자동차 재제조 부품 제조업'],--%>
<%--            "의복, 의복 액세서리 및 모피제품 제조업": ['편조의복 제조업', '의복 액세서리 제조업', '봉제의복 제조업', '모피제품 제조업'],--%>
<%--            "가죽, 가방 및 신발 제조업": ['가죽, 가방 및 유사 제품 제조업', '신발 및 신발 부분품 제조업'],--%>
<%--            "목재 및 나무제품 제조업; 가구 제외": ['제재 및 목재 가공업', '나무제품 제조업', '코르크 및 조물 제품 제조업'],--%>
<%--            "펄프, 종이 및 종이제품 제조업": ['펄프, 종이 및 판지 제조업', '골판지, 종이 상자 및 종이 용기 제조업', '기타 종이 및 판지 제품 제조업'],--%>
<%--            "인쇄 및 기록매체 복제업": ['인쇄 및 인쇄관련 산업', '기록매체 복제업'],--%>
<%--            "코크스, 연탄 및 석유정제품 제조업": ['코크스 및 연탄 제조업', '석유 정제품 제조업'],--%>
<%--            "화학 물질 및 화학제품 제조업; 의약품 제외": ['기초 화학물질 제조업', '비료, 농약 및 살균ㆍ살충제 제조업', '합성고무 및 플라스틱 물질 제조업', '기타 화학제품 제조업', '화학섬유 제조업'],--%>
<%--            "의료용 물질 및 의약품 제조업": ['의약품 제조업', '기초 의약 물질 및 생물학적 제제 제조업', '의료용품 및 기타 의약 관련제품 제조업'],--%>
<%--            "전자 부품, 컴퓨터, 영상, 음향 및 통신장비 제조업": ['마그네틱 및 광학 매체 제조업', '컴퓨터 및 주변 장치 제조업', '전자 부품 제조업', '반도체 제조업', '통신 및 방송장비 제조업', '영상 및 음향 기기 제조업'],--%>
<%--            "고무 및 플라스틱제품 제조업": ['고무제품 제조업', '플라스틱 제품 제조업'],--%>
<%--            "비금속 광물제품 제조업": ['유리 및 유리제품 제조업', '내화, 비내화 요업제품 제조업', '시멘트, 석회, 플라스터 및 그 제품 제조업', '기타 비금속 광물제품 제조업'],--%>
<%--            "1차 금속 제조업": ['1차 철강 제조업', '1차 비철금속 제조업', '금속 주조업'],--%>
<%--            "금속 가공제품 제조업; 기계 및 가구 제외": ['구조용 금속제품, 탱크 및 증기발생기 제조업', '기타 금속 가공제품 제조업', '무기 및 총포탄 제조업'],--%>
<%--            "기타 기계 및 장비 제조업": ['일반 목적용 기계 제조업', '특수 목적용 기계 제조업'],--%>
<%--            "전기장비 제조업": ['전기장비 제조업'],--%>
<%--            "운송장비 제조업": ['조선 및 보트 건조업', '철도 장비 제조업', '항공기 제조업'],--%>
<%--            "기타 제조업": ['가구 제조업', '기타 제조업']--%>
<%--        },--%>
<%--        "전문, 과학 및 기술 서비스업": {--%>
<%--            "연구개발업": ['인문 및 사회과학 연구개발업', '자연과학 및 공학 연구개발업'],--%>
<%--            "전문 서비스업": ['법무관련 서비스업', '회계 및 세무관련 서비스업', '시장 조사 및 여론 조사업', '회사 본부 및 경영 컨설팅 서비스업', '광고업', '기타 전문 서비스업'],--%>
<%--            "건축 기술, 엔지니어링 및 기타 과학기술 서비스업": ['기타 과학기술 서비스업', '건축 기술, 엔지니어링 및 관련 기술 서비스업'],--%>
<%--            "기타 전문, 과학 및 기술 서비스업": ['사진 촬영 및 처리업', '그 외 기타 전문, 과학 및 기술 서비스업', '전문 디자인업', '수의업']--%>
<%--        },--%>
<%--        "금융 및 보험업": {--%>
<%--            "금융업": ['은행 및 저축기관', '기타 금융업', '신탁업 및 집합 투자업'],--%>
<%--            "보험 및 연금업": ['보험업', '재보험업', '연금 및 공제업'],--%>
<%--            "금융 및 보험관련 서비스업": ['금융 지원 서비스업', '보험 및 연금관련 서비스업']--%>
<%--        },--%>
<%--        "부동산업": {--%>
<%--            "부동산업": ['부동산 임대 및 공급업', '부동산관련 서비스업']--%>
<%--        },--%>
<%--        "공공 행정, 국방 및 사회보장 행정": {--%>
<%--            "공공 행정, 국방 및 사회보장 행정": ['입법 및 일반 정부 행정', '사회 및 산업정책 행정', '외무 및 국방 행정', '사법 및 공공 질서 행정', '사회보장 행정']--%>
<%--        },--%>
<%--        "교육서비스업": {--%>
<%--            "교육 서비스업": ['기타 교육기관', '특수학교, 외국인학교 및 대안학교', '일반 교습학원', '초등 교육기관', '중등 교육기관', '고등 교육기관', '교육 지원 서비스업']--%>
<%--        },--%>
<%--        "보건업 및 사회복지 서비스업": {--%>
<%--            "보건업": ['병원', '의원', '기타 보건업', '공중 보건 의료업'],--%>
<%--            "사회복지 서비스업": ['거주 복지시설 운영업', '비거주 복지시설 운영업']--%>
<%--        },--%>
<%--        "예술, 스포츠 및 여가관련 서비스업": {--%>
<%--            "스포츠 및 오락관련 서비스업": ['유원지 및 기타 오락관련 서비스업', '스포츠 서비스업'],--%>
<%--            "창작, 예술 및 여가관련 서비스업": ['창작 및 예술관련 서비스업', '도서관, 사적지 및 유사 여가관련 서비스업']--%>
<%--        },--%>
<%--        "협회 및 단체, 수리 및 기타 개인 서비스업": {--%>
<%--            "기타 개인 서비스업": ['그 외 기타 개인 서비스업', '미용, 욕탕 및 유사 서비스업'],--%>
<%--            "개인 및 소비용품 수리업": ['컴퓨터 및 통신장비 수리업', '개인 및 가정용품 수리업', '자동차 및 모터사이클 수리업'],--%>
<%--            "협회 및 단체": ['산업 및 전문가 단체', '노동조합', '기타 협회 및 단체']--%>
<%--        },--%>
<%--        "가구 내 고용활동 및 달리 분류되지 않은 자가 소비 생산활동": {--%>
<%--            "가구 내 고용활동": ['가구 내 고용활동']--%>
<%--        },--%>
<%--        "국제 및 외국기관": {--%>
<%--            "국제 및 외국기관": ['국제 및 외국기관']--%>
<%--        }--%>
<%--    };--%>

<%--    var industrySelect = document.getElementById('industrySelect');--%>
<%--    var subIndustrySelect = document.getElementById('subIndustrySelect');--%>
<%--    var smallIndustrySelect = document.getElementById('smallIndustrySelect');--%>

<%--    // Populate 대분류 options--%>
<%--    for (var largeCategory in industryData) {--%>
<%--        var option = document.createElement('option');--%>
<%--        option.value = largeCategory;--%>
<%--        option.textContent = largeCategory;--%>
<%--        industrySelect.appendChild(option);--%>
<%--    }--%>

<%--    // 대분류 선택 시 중분류 옵션 추가--%>
<%--    industrySelect.addEventListener('change', function () {--%>
<%--        subIndustrySelect.innerHTML = '<option selected disabled>중분류 선택</option>';--%>
<%--        subIndustrySelect.disabled = false;--%>
<%--        smallIndustrySelect.innerHTML = '<option selected disabled>소분류 선택</option>';--%>
<%--        smallIndustrySelect.disabled = true;--%>

<%--        var selectedIndustry = this.value;--%>
<%--        var subCategories = industryData[selectedIndustry];--%>

<%--        for (var subIndustry in subCategories) {--%>
<%--            var option = document.createElement('option');--%>
<%--            option.value = subIndustry;--%>
<%--            option.textContent = subIndustry;--%>
<%--            subIndustrySelect.appendChild(option);--%>
<%--        }--%>

<%--        document.getElementById('selectedLarge').textContent = selectedIndustry;--%>
<%--        document.getElementById('selectedMedium').textContent = '';--%>
<%--        document.getElementById('selectedSmall').textContent = '';--%>
<%--    });--%>

<%--    // 중분류 선택 시 소분류 옵션 추가--%>
<%--    subIndustrySelect.addEventListener('change', function () {--%>
<%--        smallIndustrySelect.innerHTML = '<option selected disabled>소분류 선택</option>';--%>
<%--        smallIndustrySelect.disabled = false;--%>

<%--        var selectedIndustry = industrySelect.value;--%>
<%--        var selectedSubIndustry = this.value;--%>
<%--        var smallCategories = industryData[selectedIndustry][selectedSubIndustry];--%>

<%--        smallCategories.forEach(function (smallIndustry) {--%>
<%--            var option = document.createElement('option');--%>
<%--            option.value = smallIndustry;--%>
<%--            option.textContent = smallIndustry;--%>
<%--            smallIndustrySelect.appendChild(option);--%>
<%--        });--%>

<%--        document.getElementById('selectedMedium').textContent = selectedSubIndustry;--%>
<%--        document.getElementById('selectedSmall').textContent = '';--%>
<%--    });--%>

<%--    // 소분류 선택 시 선택된 항목 표시--%>
<%--    smallIndustrySelect.addEventListener('change', function () {--%>
<%--        var selectedSmallIndustry = this.value;--%>
<%--        document.getElementById('selectedSmall').textContent = selectedSmallIndustry;--%>
<%--    });--%>

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
<%--            url: "/resources/data/SeoulGu.geojson",  // 시군구 경계 데이터--%>
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
<%--            url: "/resources/data/SeoulDong.geojson",  // 읍면동 경계 데이터--%>
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
