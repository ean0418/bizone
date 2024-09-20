<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>상권분석</title>
    <meta charset="UTF-8">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <style>
        body {
            margin: 0;
            display: flex;
            flex-direction: column;
        }

        .content {
            display: flex;
            height: calc(100vh - 100px);
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
            background-color: rgba(255, 255, 255, 0.8);
            margin: 20px;
            box-shadow: 2px 0px 5px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
            font-family: Arial, sans-serif;
            z-index: 100;
            height: calc(100vh - 140px);
            position: absolute;
            border-radius: 5px;
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

        .header {
            height: 100px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
        }

        .overlaybox {
            background-color: #fff;
            padding: 5px 10px;
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        #selectedArea {
            margin-top: 10px;
        }

        button {
            margin-bottom: 20px;
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f0f0f0;
            font-size: 16px;
            cursor: pointer;
        }

        #sample5_address {
            width: calc(100% - 110px);
            padding: 10px;
            margin-right: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        #search_button {
            width: 100px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f0f0f0;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>상권분석</h1>
</div>

<div class="content">
    <div id="sidebar">
        <div id="sidebar-content">
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
            <button id="toggleEupMyeonDongBoundaries">읍면동 경계 표시/숨기기</button>
            <div id="eupMyeonDongSelectedArea" style="display: none;"></div>

            <button id="toggleSiGunGuBoundaries">시군구 경계 표시/숨기기</button>
            <div id="siGunGuSelectedArea" style="display: none;"></div>

            <input type="text" id="sample5_address" placeholder="주소">
            <input type="button" id="search_button" onclick="sample5_execDaumPostcode()" value="주소 검색"><br>
        </div>
    </div>
    <div id="mapContainer">
        <div id="map"></div>
    </div>
</div>

<script>
    var map, customOverlay, polygons = [];
    var isEupMyeonDongLoaded = false;
    var isSiGunGuLoaded = false;
    var geoJsonData = null;
    var marker = null;
    var infowindow = null;

    function initKakaoMap() {
        console.log("Initializing Kakao Map");
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 9,
        };
        map = new kakao.maps.Map(container, options);
        customOverlay = new kakao.maps.CustomOverlay({});

        // 서울시 구 선택 시 해당 구로 지도 이동
        $("#locationSelect").on("change", function () {
            if (map) {
                var coords = $(this).val().split(',');
                var latLng = new kakao.maps.LatLng(coords[0], coords[1]);
                map.setCenter(latLng);
                map.setLevel(6);
            }
        });

        loadGeoJsonData();
    }

    function loadGeoJsonData() {
        console.log("Loading GeoJSON data");
        $.ajax({
            url: "/resources/data/HangJeongDong_ver20230701.geojson",
            dataType: "json",
            success: function(data) {
                console.log("GeoJSON data loaded successfully");
                geoJsonData = data;
                initializeButtons();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("Error loading GeoJSON data:", textStatus, errorThrown);
            }
        });
    }

    function initializeButtons() {
        console.log("Initializing buttons");

        $("#toggleEupMyeonDongBoundaries").on("click", function () {
            if (isEupMyeonDongLoaded) {
                kkoMap.removePolygons();
                isEupMyeonDongLoaded = false;
                $("#eupMyeonDongSelectedArea").hide();
            } else {
                if (geoJsonData) {
                    kkoMap.loadGeoJson(geoJsonData, "읍면동");
                    map.relayout();
                    isEupMyeonDongLoaded = true;
                    $("#eupMyeonDongSelectedArea").show().text("선택된 읍면동: 없음");
                } else {
                    console.error("GeoJSON data not loaded");
                }
            }
        });

        $("#toggleSiGunGuBoundaries").on("click", function () {
            if (isSiGunGuLoaded) {
                kkoMap.removePolygons();
                isSiGunGuLoaded = false;
                $("#siGunGuSelectedArea").hide();
            } else {
                if (geoJsonData) {
                    kkoMap.loadGeoJson(geoJsonData, "시군구");
                    map.relayout();
                    isSiGunGuLoaded = true;
                    $("#siGunGuSelectedArea").show().text("선택된 시군구: 없음");
                } else {
                    console.error("GeoJSON data not loaded");
                }
            }
        });
    }

    var kkoMap = {
        loadGeoJson: function (geoJsonData, type) {
            console.log("Loading GeoJSON data for", type);

            let filteredData;
            let fillColor;
            let strokeColor;
            if (type === "읍면동") {
                filteredData = geoJsonData.features.filter(function (feature) {
                    return feature.properties.adm_cd && (feature.properties.adm_cd.length === 7 || feature.properties.adm_cd.length === 8);
                });
                fillColor = "rgba(30, 144, 255, 0.1)";
                strokeColor = "#104486";
            } else if (type === "시군구") {
                filteredData = geoJsonData.features.filter(function (feature) {
                    return feature.properties.sgg && feature.properties.sgg.length === 5;
                });
                fillColor = "rgba(30, 144, 255, 0.1)";
                strokeColor = "#163599";
            }

            if (type === "읍면동") {
                filteredData.forEach(function (feature) {
                    kkoMap.setPolygon(kkoMap.getPolygonData(feature), fillColor, strokeColor, "읍면동");
                });
            } else if (type === "시군구") {
                let groupedData = {};
                filteredData.forEach(function (feature) {
                    let sgg = feature.properties.sgg;
                    if (!groupedData[sgg]) {
                        groupedData[sgg] = {
                            name: feature.properties.sggnm,
                            path: []
                        };
                    }
                    feature.geometry.coordinates.forEach(function (coords) {
                        groupedData[sgg].path.push(coords[0].map(function (coord) {
                            return new kakao.maps.LatLng(coord[1], coord[0]);
                        }));
                    });
                });

                Object.keys(groupedData).forEach(function (sgg) {
                    kkoMap.setPolygon(groupedData[sgg], fillColor, strokeColor, "시군구");
                });
            }

            console.log("Finished loading GeoJSON data for", type);
        },

        getPolygonData: function (feature) {
            var path = [];
            feature.geometry.coordinates.forEach(function (coords) {
                path.push(coords[0].map(function (coord) {
                    return new kakao.maps.LatLng(coord[1], coord[0]);
                }));
            });
            return {
                name: feature.properties.adm_nm,
                path: path
            };
        },

        setPolygon: function (area, fillColor, strokeColor, type) {
            console.log("Setting polygon for: " + area.name);

            var polygon = new kakao.maps.Polygon({
                path: area.path,
                strokeWeight: 1.5,
                strokeColor: strokeColor,
                strokeOpacity: 0.8,
                fillColor: fillColor,
                fillOpacity: 0.1,
            });

            kakao.maps.event.addListener(polygon, "mouseover", function () {
                polygon.setOptions({ fillColor: type === "읍면동" ? "#0D94E8" : "#0031FD" });
                customOverlay.setPosition(kkoMap.centroid(area.path[0]));
                customOverlay.setContent("<div class='overlaybox'>" + area.name + "</div>");
                customOverlay.setMap(map);
            });

            kakao.maps.event.addListener(polygon, "mouseout", function () {
                polygon.setOptions({ fillColor: fillColor });
                customOverlay.setMap(null);
            });

            kakao.maps.event.addListener(polygon, "click", function () {
                if (type === "읍면동") {
                    $("#eupMyeonDongSelectedArea").text("선택된 읍면동: " + area.name);
                } else if (type === "시군구") {
                    $("#siGunGuSelectedArea").text("선택된 시군구: " + area.name);
                }
                map.setLevel(8);
                map.setCenter(kkoMap.centroid(area.path[0]));
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

        removePolygons: function () {
            console.log("Removing polygons");
            polygons.forEach(function (polygon) {
                polygon.setMap(null);
            });
            polygons = [];
            console.log("Polygons removed successfully");
        }
    };

    function sample5_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.address; // 최종 주소 변수

                // 주소 정보를 해당 필드에 넣는다.
                document.getElementById("sample5_address").value = addr;

                // 주소로 좌표를 검색
                var geocoder = new kakao.maps.services.Geocoder();
                geocoder.addressSearch(addr, function(results, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var result = results[0]; // 첫번째 결과값을 활용

                        // 해당 주소에 대한 좌표를 받아서
                        var coords = new kakao.maps.LatLng(result.y, result.x);

                        // 지도를 보여준다.
                        document.getElementById('mapContainer').style.display = "block";
                        map.relayout();

                        // 지도 중심을 변경한다.
                        map.setCenter(coords);
                        map.setLevel(3);  // 지도 확대

                        // 검색할 때 마커가 이미 존재하면 지우고 새로 생성
                        if (marker) {
                            marker.setMap(null);  // 기존 마커를 제거
                        }
                        if (infowindow) {
                            infowindow.close();  // 기존 인포윈도우 제거
                        }

                        // 마커를 결과값으로 받은 위치로 옮긴다.
                        marker = new kakao.maps.Marker({
                            position: coords,
                            map: map
                        });

                        // 인포윈도우에 표시될 내용
                        var iwContent = '<div style="padding:5px;">' + addr + '<br><a href="https://map.kakao.com/link/map/' + addr + ',' + result.y + ',' + result.x + '" target="_blank"><img src="/resources/image/kakaomap.png" alt="카카오맵" style="width:44px; height:18px; margin-top:5px;"></a></div>';

                        // 인포윈도우를 생성
                        infowindow = new kakao.maps.InfoWindow({
                            content: iwContent,  // 인포윈도우에 들어갈 내용
                            removable: true      // 인포윈도우 닫기 버튼을 추가
                        });

                        // 마커 위에 인포윈도우를 표시
                        infowindow.open(map, marker);
                    }
                });
            }
        }).open();
    }

    kakao.maps.load(function() {
        console.log("Kakao Maps API loaded");
        initKakaoMap();
    });
</script>
</body>
</html>
