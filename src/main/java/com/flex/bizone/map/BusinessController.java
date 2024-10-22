package com.flex.bizone.map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bizone")  // 공통 경로 설정
public class BusinessController {

    @Autowired
    private SqlSession ss;  // MyBatis DAO(Mapper) 주입

    @GetMapping("/services/all")
    public List<Bizone_business> getAllServices() {
        return ss.getMapper(BusinessMapper.class).getAllServices();  // DB에서 서비스 코드 가져오기
    }

    @GetMapping("/getChartDataForDetail")
    public ChartDataResponse getChartDataForDetail(@RequestParam("admin_code") String adminCode,
                                                   @RequestParam("service_code") String serviceCode) {
        ChartDataResponse response = new ChartDataResponse();

        // 차트에 필요한 점수 데이터 조회
        response.setAvgMonthlySalesScore(ss.getMapper(BusinessMapper.class).getAvgMonthlySalesScore(serviceCode, adminCode));
        response.setTotalWorkplacePopulationScore(ss.getMapper(BusinessMapper.class).getTotalWorkplacePopulationScore(adminCode));
        response.setAttractionCountScore(ss.getMapper(BusinessMapper.class).getAttractionCountScore(adminCode));
        response.setTotalExpenditureScore(ss.getMapper(BusinessMapper.class).getTotalExpenditureScore(adminCode));
        response.setAvgRentFeeScore(ss.getMapper(BusinessMapper.class).getAvgRentFeeScore(adminCode));

        // 기타 점수 설정
        response.setOtherScoresTotal(ss.getMapper(BusinessMapper.class).getOtherScoresTotal(serviceCode, adminCode));

        // 성공 확률 데이터 설정
        float successProbability = ss.getMapper(BusinessMapper.class).getSuccessProbability(serviceCode, adminCode);

        // 성공 확률을 소수점 두 자리로 포맷팅
        DecimalFormat df = new DecimalFormat("#.##");
        response.setSuccessProbability(Float.parseFloat(df.format(successProbability)));

        return response;
    }

    @GetMapping("/getDetailData")
    public DetailedDataResponse getDetailData(@RequestParam("admin_code") String adminCode,
                                              @RequestParam("service_code") String serviceCode) {
        DetailedDataResponse detailedResponse = new DetailedDataResponse();

        // 상세 데이터를 가져와 설정 (_score가 아닌 원본 데이터)
        detailedResponse.setTotalResidentPopulation(ss.getMapper(BusinessMapper.class).getTotalResidentPopulation(adminCode));
        detailedResponse.setTotalWorkplacePopulation(ss.getMapper(BusinessMapper.class).getTotalWorkplacePopulation(adminCode));
        detailedResponse.setAvgMonthlyIncome(ss.getMapper(BusinessMapper.class).getAvgMonthlyIncome(adminCode));
        detailedResponse.setTotalExpenditure(ss.getMapper(BusinessMapper.class).getTotalExpenditure(adminCode));
        detailedResponse.setTotalFloatingPopulation(ss.getMapper(BusinessMapper.class).getTotalFloatingPopulation(adminCode));
        detailedResponse.setAttractionCount(ss.getMapper(BusinessMapper.class).getAttractionCount(adminCode));
        detailedResponse.setAvgRentFee(ss.getMapper(BusinessMapper.class).getAvgRentFee(adminCode));

        return detailedResponse;
    }

    @GetMapping("/getRegionName")
    public String getRegionName(@RequestParam("admin_code") String adminCode) {
        Bizone_admin ba = new Bizone_admin();
        ba.setBa_code(adminCode);
        Bizone_admin regionName = ss.getMapper(BusinessMapper.class).getBaNameByCode(ba);
        try {
            System.out.println(regionName.getBa_name());
            return regionName.getBa_name();
        } catch (NullPointerException ignored) {
        }
        return null;
    }


    @GetMapping("/rank")
    public ResponseEntity<Map<String, Object>> getRankPage(@RequestParam(value = "serviceCode", required = false) String serviceCode) {
        Map<String, Object> response = new HashMap<>();

        // 모든 업종 목록 가져오기
        List<Bizone_business> serviceList = ss.getMapper(BusinessMapper.class).getAllServices();
        response.put("serviceList", serviceList);

        // 선택된 업종의 지역별 성공 확률 가져오기
        if (serviceCode != null) {
            List<RankResponse> rankList = ss.getMapper(BusinessMapper.class).getRankByServiceCode(serviceCode);
            response.put("rankList", rankList);
        }

        return ResponseEntity.ok(response);
    }

}