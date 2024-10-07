package com.flex.bizone.map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BusinessMapper {
    List<Bizone_business> getAllServices();

    // 평균 월매출 점수 가져오기
    int getAvgMonthlySalesScore(@Param("service_code") String serviceCode, @Param("admin_code") String adminCode);

    // 총 직장인구 점수 가져오기
    int getTotalWorkplacePopulationScore(@Param("admin_code") String adminCode);

    // 집객시설 수 점수 가져오기
    int getAttractionCountScore(@Param("admin_code") String adminCode);

    // 총 지출 금액 점수 가져오기
    int getTotalExpenditureScore(@Param("admin_code") String adminCode);

    // 평균 임대료 점수 가져오기
    int getAvgRentFeeScore(@Param("admin_code") String adminCode);

    // 기타 점수 합계 계산
    int getOtherScoresTotal(@Param("service_code") String serviceCode, @Param("admin_code") String adminCode);

    // 성공 확률 가져오기
    int getSuccessProbability(@Param("service_code") String serviceCode, @Param("admin_code") String adminCode);
}
