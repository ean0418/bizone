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
import java.security.Principal;
import java.util.List;

@Controller
public class FavoriteController {

    @Autowired
    private LoanDAO loanDAO;
    // 찜한 상품 추가 요청
    @PostMapping("/addFavorite")
    public String addFavorite(@RequestParam String productName, @RequestParam String loanLimit,
                              @RequestParam String interestRate, @RequestParam String qualification,
                              Principal principal, HttpServletRequest req) throws UnsupportedEncodingException {

        // Principal을 통해 로그인된 사용자의 ID 가져오기
        String bm_id = principal.getName();  // Spring Security에서 기본적으로 사용자 이름을 가져옴

        // Bizone_favorites 객체 생성 및 필드 설정
        Bizone_favorites favorite = new Bizone_favorites();
        favorite.setBf_bm_id(bm_id);  // 로그인된 사용자의 ID 설정
        favorite.setBf_product_name(productName);
        favorite.setBf_loan_limit(loanLimit);
        favorite.setBf_interest_rate(interestRate);
        favorite.setBf_qualification(qualification);

        // 찜 추가
        loanDAO.addFavorite(favorite, req);

        return "redirect:/loan-products";  // 추가 후 다시 목록으로 이동
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

