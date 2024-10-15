package com.flex.bizone.loan;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.flex.bizone.member.Bizone_member;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

@Service
public class LoanDAO {

    @Autowired
    private SqlSession ss;

    // 대출 API로 불러온 정보를 찜 목록에 추가하는 기능
    public boolean addFavoriteLoanProduct(HttpServletRequest req, String productName, String loanLimit, String interestRate, String qualification) {
        Bizone_member loginMember = (Bizone_member) req.getSession().getAttribute("loginMember");
        if (loginMember == null) {
            req.setAttribute("r", "로그인이 필요합니다.");
            return false;
        }

        try {
            HashMap<String, String> paramMap = new HashMap<>();
            paramMap.put("bm_id", loginMember.getBm_id());
            paramMap.put("productName", productName);
            paramMap.put("loanLimit", loanLimit);
            paramMap.put("interestRate", interestRate);
            paramMap.put("qualification", qualification);
            ss.insert("FavoriteMapper.insertFavoriteLoanProduct", paramMap);
            req.setAttribute("r", "찜 목록에 대출 상품이 추가되었습니다.");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "찜 목록 추가에 실패했습니다.");
            return false;
        }
    }

    // 찜 목록 조회 기능
    public List<HashMap<String, Object>> getFavorites(HttpServletRequest req) {
        Bizone_member loginMember = (Bizone_member) req.getSession().getAttribute("loginMember");
        if (loginMember == null) {
            req.setAttribute("r", "로그인이 필요합니다.");
            return null;
        }

        try {
            List<HashMap<String, Object>> favorites = ss.selectList("FavoriteMapper.getFavoritesByMemberId", loginMember.getBm_id());
            return favorites;
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "찜 목록 조회에 실패했습니다.");
            return null;
        }
    }

    // 찜 목록에서 상품 삭제 기능
    public boolean removeFavorite(HttpServletRequest req, String productName) {
        Bizone_member loginMember = (Bizone_member) req.getSession().getAttribute("loginMember");
        if (loginMember == null) {
            req.setAttribute("r", "로그인이 필요합니다.");
            return false;
        }

        try {
            HashMap<String, String> paramMap = new HashMap<>();
            paramMap.put("bm_id", loginMember.getBm_id());
            paramMap.put("productName", productName);
            ss.delete("FavoriteMapper.deleteFavoriteLoanProduct", paramMap);
            req.setAttribute("r", "찜 목록에서 대출 상품이 삭제되었습니다.");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "찜 목록 삭제에 실패했습니다.");
            return false;
        }
    }

    // 찜 목록에 이미 추가되어 있는지 확인하는 기능
    public boolean isFavorite(HttpServletRequest req, String productName) {
        Bizone_member loginMember = (Bizone_member) req.getSession().getAttribute("loginMember");
        if (loginMember == null) {
            req.setAttribute("r", "로그인이 필요합니다.");
            return false;
        }

        try {
            HashMap<String, String> paramMap = new HashMap<>();
            paramMap.put("bm_id", loginMember.getBm_id());
            paramMap.put("productName", productName);
            Integer count = ss.selectOne("FavoriteMapper.isFavoriteLoanProduct", paramMap);
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "찜 상태 확인에 실패했습니다.");
            return false;
        }
    }
}

