package com.flex.bizone.map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface BusinessMapper {
    // 모든 서비스 가져오기
    List<Bizone_business> getAllServices();

    // 평균 월매출 점수 가져오기
    float getAvgMonthlySalesScore(@Param("service_code") String serviceCode, @Param("admin_code") String adminCode);

    // 총 직장인구 점수 가져오기
    float getTotalWorkplacePopulationScore(@Param("admin_code") String adminCode);

    // 집객시설 수 점수 가져오기
    float getAttractionCountScore(@Param("admin_code") String adminCode);

    // 총 지출 금액 점수 가져오기
    float getTotalExpenditureScore(@Param("admin_code") String adminCode);

    // 평균 임대료 점수 가져오기
    float getAvgRentFeeScore(@Param("admin_code") String adminCode);

    // 기타 점수 합계 계산
    float getOtherScoresTotal(@Param("service_code") String serviceCode, @Param("admin_code") String adminCode);

    // 성공 확률 가져오기
    float getSuccessProbability(@Param("service_code") String serviceCode, @Param("admin_code") String adminCode);

    // 차트 데이터 가져오기
    Map<String, Object> getChartDataForDetail(@Param("service_code") String serviceCode, @Param("admin_code") String adminCode);

    // 상세 데이터 가져오기
    float getTotalResidentPopulation(@Param("admin_code") String adminCode);
    float getTotalWorkplacePopulation(@Param("admin_code") String adminCode);
    float getAvgMonthlyIncome(@Param("admin_code") String adminCode);
    float getTotalExpenditure(@Param("admin_code") String adminCode);
    float getTotalFloatingPopulation(@Param("admin_code") String adminCode);
    float getAttractionCount(@Param("admin_code") String adminCode);
    float getAvgRentFee(@Param("admin_code") String adminCode);
}
