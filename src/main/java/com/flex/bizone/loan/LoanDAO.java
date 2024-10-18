package com.flex.bizone.loan;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.util.List;

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
        int count = ss.getMapper(LoanMapper.class).isFavorite(
                new Bizone_favorites(bm_id, productName, null, null, null)
        );
        return count > 0;
    }


}
