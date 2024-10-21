package com.flex.bizone.loan;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

@Repository
@Service
public class LoanDAO {

    @Autowired
    private final SqlSession ss;

    public LoanDAO(SqlSession ss) {
        this.ss = ss;
    }



    // 찜한 대출상품 추가
    public void addFavorite(Bizone_favorites favorite, HttpServletRequest req) throws UnsupportedEncodingException {
        req.setCharacterEncoding("utf-8");
        ss.getMapper(LoanMapper.class).addFavorite(favorite);
    }

    // 특정 사용자의 찜한 대출상품 목록 조회
    public List<Bizone_favorites> getFavoritesByMemberId(String bm_id) {
        return ss.getMapper(LoanMapper.class).getFavoritesByMemberId(bm_id);
    }

    // 찜한 대출상품 삭제
    public void deleteFavoriteById(int bf_id) {
        ss.getMapper(LoanMapper.class).deleteFavoriteById(bf_id);
    }

    // 특정 사용자가 해당 상품을 찜했는지 확인
    public boolean isFavorite(String bm_id, String productName) {
        // Bizone_favorites 객체에 필요한 필드만 설정하여 생성
        Bizone_favorites favorite = new Bizone_favorites();
        favorite.setBf_bm_id(bm_id);
        favorite.setBf_product_name(productName);

        // LoanMapper를 통해 해당 상품이 찜된 상태인지 확인
        int count = ss.getMapper(LoanMapper.class).isFavorite(favorite);

        // count가 0보다 크면 true, 그렇지 않으면 false를 반환
        return count > 0;
    }


}
