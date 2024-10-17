<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>파워랭킹</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .rank-table {
            margin-top: 30px;
        }
        .table-header {
            background-color: #101E4E;
            color: white;
        }
        .table-row {
            text-align: center;
        }
        .rank-item {
            display: flex;
            justify-content: space-between;
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        .rank-item-header {
            background-color: #101E4E;
            color: white;
            font-weight: bold;
            padding: 10px;
        }
        .input-group input {
            flex: 1; /* 입력창이 가능한 넓게 차지하게 설정 */
        }
        .input-group button {
            flex: 0 0 auto; /* 버튼은 기본 크기로 유지 */
        }
        #searchResults {
            position: absolute;
            width: 100%;
            max-width: 600px; /* 검색창 너비와 맞춤 */
            overflow-y: auto;
            border: 1px solid #ddd;
            background: white;
            z-index: 1000;
            left: 50%; /* 가운데 정렬 */
            transform: translateX(-50%); /* 가운데 정렬을 위한 X축 이동 */
        }
        .search-result-item {
            padding: 10px;
            cursor: pointer;
        }
        .search-result-item:hover {
            background-color: #f0f0f0;
        }
        .container.rank-table {
            text-align: center; /* 부모 요소에 대해 가운데 정렬 */
        }

        .input-group {
            display: inline-flex; /* inline-block에서 inline-flex로 변경 */
            width: 100%;
            max-width: 600px; /* 원하는 최대 너비로 설정 */
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <script>
        $(document).ready(function () {
            var businessData = [];

            // 데이터 로드
            $.ajax({
                url: '/api/bizone/services/all',  // API 엔드포인트
                method: 'GET',
                success: function (data) {
                    businessData = data;  // 가져온 데이터를 businessData에 저장
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching business data:", error);
                }
            });

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
                const searchQuery = $('#serviceSearch').val().toLowerCase();

                if (searchQuery.length < 2) {
                    return false; // 두 글자 미만일 때는 검색하지 않음
                }

                if (isChosungInput(searchQuery)) {
                    // 초성 검색 처리
                    const searchQueryChosung = getChosung(searchQuery);
                    const businessNameChosung = getChosung(item.bb_name.toLowerCase());

                    // 입력된 초성이 포함되고, 정확한 초성 순서로 일치하는 항목만 반환
                    return businessNameChosung.includes(searchQueryChosung);
                } else {
                    // 일반 텍스트 검색 처리
                    return item.bb_name.toLowerCase().includes(searchQuery);
                }
            }

            // 검색어 입력 시 자동완성 결과 표시
            $('#serviceSearch').on('input', function () {
                const searchQuery = $(this).val().toLowerCase();

                if (searchQuery.length >= 2) {
                    const filteredResults = businessData.filter(filterFunc);
                    displayResults(filteredResults);
                } else {
                    $('#searchResults').empty();  // 두 글자 미만일 때는 검색 결과를 비움
                }
            });

            // 검색 결과를 화면에 표시
            function displayResults(filteredResults) {
                $('#searchResults').empty();
                if (filteredResults.length === 0) {
                    $('#searchResults').append('<div class="text-muted p-2">검색 결과가 없습니다.</div>');
                    return;
                }

                filteredResults.forEach(function (item) {
                    const listItem = $('<div class="search-result-item" data-code="' + item.bb_code + '">' + item.bb_name + ' (' + item.bb_code + ')</div>');

                    listItem.on('click', function () {
                        $('#serviceSearch').val(item.bb_name + ' (' + item.bb_code + ')');
                        $('#searchResults').empty(); // 결과 창 닫기
                    });

                    $('#searchResults').append(listItem);
                });
            }

            // 선택된 업종을 표시하고 검색 결과 초기화
            $(document).on('mousedown', '.search-result-item', function () {
                var serviceName = $(this).text();
                var serviceCode = $(this).data('code');
                $('#serviceSearch').val(serviceName);
                $('#searchResults').empty();
                $('#serviceSearch').data('selectedCode', serviceCode);
            });

            // 검색 버튼 클릭 시 해당 업종의 지역별 성공 확률 조회
            $('#searchButton').click(function () {
                var serviceCode = $('#serviceSearch').data('selectedCode');
                if (serviceCode) {
                    $.ajax({
                        url: '/api/bizone/rank',
                        type: 'GET',
                        data: { serviceCode: serviceCode },
                        success: function (data) {
                            var rankContainer = $('#rankContainer');
                            rankContainer.empty();
                            if (data.rankList && data.rankList.length > 0) {
                                var header = '<div class="rank-item-header d-flex">' +
                                    '<div class="col">순위</div>' +
                                    '<div class="col">지역명</div>' +
                                    '<div class="col">성공 확률</div>' +
                                    '</div>';
                                rankContainer.append(header);
                                $.each(data.rankList, function (index, rank) {
                                    var row = '<div class="rank-item d-flex">' +
                                        '<div class="col">' + (index + 1) + '</div>' +
                                        '<div class="col">' + rank.ba_name + '</div>' +
                                        '<div class="col">' + rank.bs_success_probability.toFixed(2) + '%</div>' +
                                        '</div>';
                                    rankContainer.append(row);
                                });
                            } else {
                                rankContainer.append('<div class="alert alert-warning text-center" role="alert">선택한 업종에 대한 데이터가 없습니다.</div>');
                            }
                        },
                        error: function () {
                            alert('데이터를 가져오는 도중 오류가 발생했습니다.');
                        }
                    });
                } else {
                    alert('올바른 업종을 선택해 주세요.');
                }
            });

            // 키보드 입력 시 자동완성 + 빈 입력란 처리
            $('#serviceSearch').on('input', function () {
                const searchQuery = $(this).val().toLowerCase();

                if (!searchQuery) {
                    $('#searchResults').empty();
                    return;
                }

                const filteredResults = businessData.filter(filterFunc);
                displayResults(filteredResults);
            });
        });
    </script>
</head>
<body>
<div class="container rank-table">
    <h2 class="text-center">선택한 업종에 대한 지역별 파워랭킹</h2>
    <div class="mb-4 position-relative">
        <div class="input-group">
            <input type="text" id="serviceSearch" class="form-control" placeholder="업종을 검색하세요">
            <button class="btn btn-primary" type="button" id="searchButton">검색</button>
        </div>
        <div id="searchResults" class="mt-2">
            <!-- 검색 결과 표시 -->
        </div>
    </div>
    <div id="rankContainer"></div>
</div>

<!-- Bootstrap JS 및 jQuery 추가 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
