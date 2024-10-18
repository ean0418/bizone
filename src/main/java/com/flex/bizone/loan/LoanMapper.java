package com.flex.bizone.loan;


import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LoanMapper {
    // 찜한 대출상품 추가
    void addFavorite(Bizone_favorites favorite);

    // 특정 사용자의 찜한 대출상품 목록 조회
    List<Bizone_favorites> getFavoritesByMemberId(String bm_id);

    // 찜한 대출상품 삭제
    void deleteFavoriteById(int bf_id);

    int isFavorite(Bizone_favorites favorite);

}
