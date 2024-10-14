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
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
        .rank-table {
            margin-top: 30px;
        }
        .table-header {
            background-color: hotpink;
            color: white;
        }
        .table-row {
            text-align: center;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
    <script>
        $(document).ready(function () {
            // 검색창에서 업종 입력 시 자동완성 및 검색 기능
            $('#serviceSearch').on('input', function () {
                var query = $(this).val();
                if (query.length > 1) {
                    $.ajax({
                        url: '/api/bizone/services/all',
                        type: 'GET',
                        data: { keyword: query },
                        success: function (data) {
                            var datalist = $('#serviceList');
                            datalist.empty();
                            $.each(data, function (index, service) {
                                var option = $('<option>').val(service.bb_name).data('code', service.bb_code);
                                datalist.append(option);
                            });
                        },
                        error: function () {
                            alert('데이터를 가져오는 도중 오류가 발생했습니다.');
                        }
                    });
                }
            });

            // 검색 버튼 클릭 시 해당 업종의 지역별 성공 확률 조회
            $('#searchButton').click(function () {
                var selectedService = $('#serviceSearch').val();
                var serviceCode = $('#serviceList option[value="' + selectedService + '"]').data('code');
                if (serviceCode) {
                    $.ajax({
                        url: '/api/bizone/rank',
                        type: 'GET',
                        data: { serviceCode: serviceCode },
                        success: function (data) {
                            var tbody = $('tbody');
                            tbody.empty();
                            if (data.rankList && data.rankList.length > 0) {
                                $.each(data.rankList, function (index, rank) {
                                    var row = '<tr class="table-row">' +
                                        '<th scope="row">' + (index + 1) + '</th>' +
                                        '<td>' + rank.ba_name + '</td>' +
                                        '<td>' + rank.bs_success_probability.toFixed(2) + '%</td>' +
                                        '</tr>';
                                    tbody.append(row);
                                });
                            } else {
                                tbody.append('<div class="alert alert-warning text-center" role="alert">선택한 업종에 대한 데이터가 없습니다.</div>');
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
        });
    </script>
</head>
<body>
<div class="container rank-table">
    <h2 class="text-center">업종별 지역파워랭킹</h2>
    <div class="mb-4">
        <div class="input-group">
            <input type="text" id="serviceSearch" class="form-control" placeholder="업종을 검색하세요" list="serviceList">
            <datalist id="serviceList"></datalist>
            <button class="btn btn-primary" type="button" id="searchButton">검색</button>
        </div>
    </div>
    <table class="table table-hover">
        <thead class="table-header">
        <tr>
            <th scope="col">순위</th>
            <th scope="col">지역명</th>
            <th scope="col">성공 확률</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${not empty rankList}">
            <c:forEach var="rank" items="${rankList}" varStatus="status">
                <tr class="table-row">
                    <th scope="row">${status.index + 1}</th>
                    <td>${rank.ba_name}</td>
                    <td><fmt:formatNumber value="${rank.bs_success_probability}" pattern="#.##" />%</td>
                </tr>
            </c:forEach>
        </c:if>
        </tbody>
    </table>
</div>

<!-- Bootstrap JS 및 jQuery 추가 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>