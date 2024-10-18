package com.flex.bizone.map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface InterestAreaMapper {

    // 찜 추가
    void insertFavorite(InterestAreaData interestAreaData);

    // 찜 목록 조회
    List<InterestAreaData> selectFavoritesByMemberId(@Param("bm_id") String bm_id);

    // 찜 삭제
    void deleteFavorite(@Param("bm_id") String bm_id,
                        @Param("ba_code") String ba_code,
                        @Param("bb_code") String bb_code);
}
