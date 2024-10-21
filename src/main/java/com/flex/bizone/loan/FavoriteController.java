package com.flex.bizone.loan;

import com.flex.bizone.member.Bizone_member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class FavoriteController {

    @Autowired
    private LoanDAO loanDAO;

    @PostMapping("/addFavorite")
    public String addFavorite(@RequestParam String productName,
                              @RequestParam String loanLimit,
                              @RequestParam String interestRate,
                              @RequestParam String qualification,
                              @RequestParam(value = "IRT_CTG", required = false) String irtCtg,
                              @RequestParam(value = "USGE", required = false) String usge,
                              @RequestParam(value = "INST_CTG", required = false) String instCtg,
                              @RequestParam(value = "RSD_AREA_PAMT_EQLT_ISTM", required = false) String rsdAreaPamtEqltIstm,
                              @RequestParam(value = "TGT_FLTR", required = false) String tgtFltr,
                              Principal principal, HttpServletRequest req) throws UnsupportedEncodingException {

        String bm_id = principal.getName(); // 현재 로그인된 사용자 ID 가져오기

        // Bizone_favorites 객체 생성 후 찜한 상품 정보 설정
        Bizone_favorites favorite = new Bizone_favorites();
        favorite.setBf_bm_id(bm_id);
        favorite.setBf_product_name(productName);
        favorite.setBf_loan_limit(loanLimit);
        favorite.setBf_interest_rate(interestRate);
        favorite.setBf_qualification(qualification);

        // DAO를 통해 찜한 상품 저장
        loanDAO.addFavorite(favorite, req);

        // 파라미터들을 맵에 저장
        Map<String, String> queryParams = new HashMap<>();
        queryParams.put("IRT_CTG", irtCtg);
        queryParams.put("USGE", usge);
        queryParams.put("INST_CTG", instCtg);
        queryParams.put("RSD_AREA_PAMT_EQLT_ISTM", rsdAreaPamtEqltIstm);
        queryParams.put("TGT_FLTR", tgtFltr);

        // 조회 파라미터들을 포함하여 리다이렉트 URL 생성
        StringBuilder redirectUrl = new StringBuilder("redirect:/loan-products?pageNo=1&numOfRows=10");

        // Map을 순회하면서 null 또는 빈 값이 아닌 파라미터를 URL에 추가
        queryParams.forEach((key, value) -> {
            if (value != null && !value.isEmpty()) {
                try {
                    redirectUrl.append("&").append(key).append("=").append(URLEncoder.encode(value, StandardCharsets.UTF_8.toString()));
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
            }
        });

        // 생성된 URL로 리다이렉트
        return redirectUrl.toString();
    }

    // 찜한 대출상품 삭제 요청
    @PostMapping("/deleteFavorite")
    public String deleteFavorite(@RequestParam int bf_id) {
        loanDAO.deleteFavoriteById(bf_id);
        return "redirect:/favorite";  // 삭제 후 찜 목록으로
    }

    @GetMapping("/favorite")
    public String showFavorites(Model model, Principal principal) {
        String bm_id = principal.getName(); // 현재 로그인된 사용자의 ID 가져오기
        List<Bizone_favorites> favorites = loanDAO.getFavoritesByMemberId(bm_id);

        // 찜한 목록이 비어있을 경우 처리
        if (favorites == null || favorites.isEmpty()) {
            model.addAttribute("message", "찜한 대출 상품이 없습니다.");
        } else {
            model.addAttribute("favorites", favorites);
        }
        model.addAttribute("contentPage", "loan/favorite.jsp");
        return "index"; // JSP 파일 이름
    }
}

