package com.flex.bizone.map;

import org.springframework.beans.factory.annotation.Autowired;
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
}

//package com.flex.bizone.map;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RestController;
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
//        response.setSuccessProbability(serviceMapper.getSuccessProbability(serviceCode, adminCode));
//
//        return response;
//    }
//}

//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import java.util.List;
//
//@Controller
//public class BusinessController {
//
//    @Autowired
//    private BusinessMapper serviceMapper;  // MyBatis DAO(Mapper) 주입
//
//    @GetMapping("/services/all")
//    @ResponseBody
//    public List<Bizone_business> getAllServices() {
//        return serviceMapper.getAllServices();  // DB에서 서비스 코드 가져오기
//    }
//}
