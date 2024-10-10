package com.flex.bizone.map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.text.DecimalFormat;
import java.util.List;

@RestController
@RequestMapping("/api/bizone")  // 공통 경로 설정
public class BusinessController {

    @Autowired
    private BusinessMapper serviceMapper;  // MyBatis DAO(Mapper) 주입

    @GetMapping("/services/all")
    public List<Bizone_business> getAllServices() {
        return serviceMapper.getAllServices();  // DB에서 서비스 코드 가져오기
    }

    @GetMapping("/getChartDataForDetail")
    public ChartDataResponse getChartDataForDetail(@RequestParam("admin_code") String adminCode,
                                                   @RequestParam("service_code") String serviceCode) {
        ChartDataResponse response = new ChartDataResponse();

        // 차트에 필요한 점수 데이터 조회
        response.setAvgMonthlySalesScore(serviceMapper.getAvgMonthlySalesScore(serviceCode, adminCode));
        response.setTotalWorkplacePopulationScore(serviceMapper.getTotalWorkplacePopulationScore(adminCode));
        response.setAttractionCountScore(serviceMapper.getAttractionCountScore(adminCode));
        response.setTotalExpenditureScore(serviceMapper.getTotalExpenditureScore(adminCode));
        response.setAvgRentFeeScore(serviceMapper.getAvgRentFeeScore(adminCode));

        // 기타 점수 설정
        response.setOtherScoresTotal(serviceMapper.getOtherScoresTotal(serviceCode, adminCode));

        // 성공 확률 데이터 설정
        float successProbability = serviceMapper.getSuccessProbability(serviceCode, adminCode);

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
        detailedResponse.setTotalResidentPopulation(serviceMapper.getTotalResidentPopulation(adminCode));
        detailedResponse.setTotalWorkplacePopulation(serviceMapper.getTotalWorkplacePopulation(adminCode));
        detailedResponse.setAvgMonthlyIncome(serviceMapper.getAvgMonthlyIncome(adminCode));
        detailedResponse.setTotalExpenditure(serviceMapper.getTotalExpenditure(adminCode));
        detailedResponse.setTotalFloatingPopulation(serviceMapper.getTotalFloatingPopulation(adminCode));
        detailedResponse.setAttractionCount(serviceMapper.getAttractionCount(adminCode));
        detailedResponse.setAvgRentFee(serviceMapper.getAvgRentFee(adminCode));

        return detailedResponse;
    }

    @GetMapping("/getRegionName")
    public ResponseEntity<String> getRegionName(@RequestParam("admin_code") String adminCode) {
        String regionName = serviceMapper.getBaNameByCode(adminCode);
        return ResponseEntity.ok(regionName != null ? regionName : "정보 없음");
    }

}

//package com.flex.bizone.map;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.text.DecimalFormat;
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/bizone")  // 공통 경로 설정
//public class BusinessController {
//
//    @Autowired
//    private BusinessMapper serviceMapper;  // MyBatis DAO(Mapper) 주입
//
//    @GetMapping("/services/all")
//    public List<Bizone_business> getAllServices() {
//        return serviceMapper.getAllServices();  // DB에서 서비스 코드 가져오기
//    }
//
//    @GetMapping("/getChartDataForDetail")
//    public ChartDataResponse getChartDataForDetail(@RequestParam("admin_code") String adminCode,
//                                                   @RequestParam("service_code") String serviceCode) {
//        ChartDataResponse response = new ChartDataResponse();
//
//        // 차트에 필요한 점수 데이터 조회
//        response.setAvgMonthlySalesScore(serviceMapper.getAvgMonthlySalesScore(serviceCode, adminCode));
//        response.setTotalWorkplacePopulationScore(serviceMapper.getTotalWorkplacePopulationScore(adminCode));
//        response.setAttractionCountScore(serviceMapper.getAttractionCountScore(adminCode));
//        response.setTotalExpenditureScore(serviceMapper.getTotalExpenditureScore(adminCode));
//        response.setAvgRentFeeScore(serviceMapper.getAvgRentFeeScore(adminCode));
//
//        // 기타 점수 설정
//        response.setOtherScoresTotal(serviceMapper.getOtherScoresTotal(serviceCode, adminCode));
//
//        // 성공 확률 데이터 설정
//        float successProbability = serviceMapper.getSuccessProbability(serviceCode, adminCode);
//
//        // 성공 확률을 소수점 두 자리로 포맷팅
//        DecimalFormat df = new DecimalFormat("#.##");
//        response.setSuccessProbability(Float.parseFloat(df.format(successProbability)));
//
//        return response;
//    }
//
//}
