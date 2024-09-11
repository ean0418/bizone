<%--
  Created by IntelliJ IDEA.
  User: sdedu
  Date: 24. 9. 10.
  Time: 오전 11:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>상권분석</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=695af2d9d27326c791e215b580236791&libraries=services,clusterer"></script>
    <style>
        /*body {*/
        /*    margin: 0;*/
        /*    display: flex;*/
        /*}*/
        #sidebar {
            width: 20%;
            background-color: #f4f4f4;
            padding: 20px;
            box-shadow: 2px 0px 5px rgba(0, 0, 0, 0.1);
            box-sizing: border-box;
            font-family: Arial, sans-serif;
            height: 100vh; /* 전체 페이지 높이 설정 */
            display: flex;
            justify-content: center; /* 수평 가운데 정렬 */
            align-items: center; /* 수직 가운데 정렬 */
        }
        #sidebar div {
            width: 100%; /* 내부 내용이 드롭박스 크기를 따라 확장 */
        }
        #mapContainer {
            width: 80%;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        #map {
            width: 80%;
            height: 80%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
        }
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            appearance: none;
            background-color: white;
            margin-bottom: 20px;
        }
        select:focus {
            outline: none;
            border-color: #0066cc;
        }

        .overlaybox {
            position: relative;
            display: inline-block;
            background: #284a6e no-repeat;
            padding: 10px;
            border-radius: 10px;
            color: #fff;
        }
    </style>
    <script>
        var map = null,
            customOverlay = new kakao.maps.CustomOverlay({}),
            kkoMap = {
                initKko: function (o) {
                    var e = o.mapId,
                        t = document.getElementById(e),
                        a = {
                            center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울시 중심
                            level: 11, // 초기 확대 레벨 설정
                        };
                    map = new kakao.maps.Map(t, a);

                    // GeoJSON 파일을 로드하여 지도에 다각형 표시
                    $.getJSON("/resources/data/HangJeongDong_ver20230701.geojson", function (o) {
                        let e = $(o.features);
                        e.each(function () {
                            kkoMap.getPolycode($(this)[0]);
                        });
                    });
                },
                getPolycode: function (o) {
                    var e = [],
                        t = o.geometry;
                    if ("Polygon" == t.type) {
                        var a = t.coordinates[0],
                            n = { name: o.properties.adm_nm, path: [] };
                        for (var s in a)
                            e.push({ x: p[s][1], y: p[s][0] }),
                                n.path.push(new kakao.maps.LatLng(a[s][1], a[s][0]));
                        kkoMap.setPolygon(n, e);
                    } else if ("MultiPolygon" == t.type)
                        for (var s in t.coordinates) {
                            var p = t.coordinates[s],
                                n = { name: o.properties.adm_nm, path: [] };
                            for (var r in p[0])
                                e.push({ x: p[0][r][1], y: p[0][r][0] }),
                                    n.path.push(new kakao.maps.LatLng(p[0][r][1], p[0][r][0]));
                            kkoMap.setPolygon(n, e);
                        }
                },
                setPolygon: function (o, e) {
                    var t = new kakao.maps.Polygon({
                        name: o.name,
                        path: o.path,
                        strokeWeight: 2,
                        strokeColor: "#004c80",
                        strokeOpacity: 0.8,
                        fillColor: "#fff",
                        fillOpacity: 0.7,
                    });

                    // 마우스 오버시 색상 변경 및 오버레이 표시
                    kakao.maps.event.addListener(t, "mouseover", function (a) {
                        t.setOptions({ fillColor: "#09f" }),
                            customOverlay.setPosition(kkoMap.centroid(e)),
                            customOverlay.setContent(
                                "<div class='overlaybox'>" + o.name + "</div>"
                            ),
                            customOverlay.setMap(map);
                    });

                    // 마우스 아웃시 색상 복구 및 오버레이 숨기기
                    kakao.maps.event.addListener(t, "mouseout", function () {
                        t.setOptions({ fillColor: "#fff" }), customOverlay.setMap(null);
                    });

                    // 행정동 클릭시 지도 확대
                    kakao.maps.event.addListener(t, "click", function () {
                        map.setLevel(8);  // 클릭 시 확대 레벨 설정
                        map.setCenter(kkoMap.centroid(e)); // 클릭한 영역을 중심으로 설정
                    });

                    t.setMap(map);
                },
                centroid: function (o) {
                    var e, t, a, n, s, p, r, i, l;
                    for (e = 0, r = i = l = 0, t = (a = o.length) - 1; e < a; t = e++)
                        (n = o[e]),
                            (s = o[t]),
                            (p = n.y * s.x - s.y * n.x),
                            (i += (n.x + s.x) * p),
                            (l += (n.y + s.y) * p),
                            (r += 3 * p);
                    return new kakao.maps.LatLng(i / r, l / r);
                },
            };

        $(function () {
            kkoMap.initKko({ mapId: "map" });
        });
    </script>
</head>
<body id="mainPage">
<!-- 좌측에 드롭다운을 배치한 사이드바 -->
<div id="sidebar">
    <div>
        <h4>서울시 특정 구 이동</h4>
        <label for="locationSelect">클릭해서 변경</label>
        <select id="locationSelect">
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

        <div class="function-option">
            <h4>어떤 기능을 넣을까요?</h4>
            <label for="functionSelectLunch">점심 메뉴 추천</label>
            <select id="functionSelectLunch">
                <option value="1">한식</option>
                <option value="2">중식</option>
                <option value="3">일식</option>
                <option value="4">아시안</option>
                <option value="5">양식</option>
                <option value="6">기타</option>
            </select>
            <label for="functionSelectDinner">저녁 메뉴 추천</label>
            <select id="functionSelectDinner">
                <option value="1">한식</option>
                <option value="2">중식</option>
                <option value="3">일식</option>
                <option value="4">아시안</option>
                <option value="5">양식</option>
                <option value="6">기타</option>
            </select>
        </div>

        <div class="function-option">
            <h4>메인프로젝트에 넣으면 좋겠죠?</h4>
            <label for="functionSelectLoan">대출</label>
            <select id="functionSelectLoan">
                <option value="1">1금융권</option>
                <option value="2">2금융권</option>
                <option value="3">3금융권</option>
            </select>
        </div>
    </div>
</div>

<!-- 중앙에 지도가 표시되는 부분 -->
<div id="mapContainer">
    <div id="map"></div>
</div>

<script>
    // 드롭다운 박스에서 선택한 값에 따라 지도 중심 및 확대 수준 변경
    $("#locationSelect").on("change", function () {
        var coords = $(this).val().split(',');
        var latLng = new kakao.maps.LatLng(coords[0], coords[1]);
        map.setCenter(latLng);
        map.setLevel(6); // 구 선택 시 더 확대된 지도 레벨 설정
    });
</script>
</body>
</html>