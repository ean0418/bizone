package com.flex.bizone.loan;


import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/api/favorites")
public class FavoriteController {

    @Autowired
    private LoanDAO loanDAO;
    // 대출 상품 찜하기 기능
    @PostMapping("/add")
    @ResponseBody
    public String addFavoriteLoanProduct(HttpServletRequest req,
                                         @RequestParam String productName,
                                         @RequestParam String loanLimit,
                                         @RequestParam String interestRate,
                                         @RequestParam String qualification) {
        boolean result = loanDAO.addFavoriteLoanProduct(req, productName, loanLimit, interestRate, qualification);
        return result ? "찜 목록에 추가되었습니다." : (String) req.getAttribute("r");
    }

    // 찜 목록 조회 기능
    @GetMapping("/list")
    public List<HashMap<String, Object>> getFavorites(HttpServletRequest req, Model model) {
        List<HashMap<String, Object>> favorites = loanDAO.getFavorites(req);
        if (favorites == null) {
            model.addAttribute("r", req.getAttribute("r"));
        }
        return favorites;
    }

    // 찜 목록에서 상품 삭제 기능
    @PostMapping("/remove")
    @ResponseBody
    public String removeFavorite(HttpServletRequest req, @RequestParam String productName) {
        boolean result = loanDAO.removeFavorite(req, productName);
        return result ? "찜 목록에서 삭제되었습니다." : (String) req.getAttribute("r");
    }

    // 찜 여부 확인 기능
    @GetMapping("/isFavorite")
    @ResponseBody
    public String isFavorite(HttpServletRequest req, @RequestParam String productName) {
        boolean result = loanDAO.isFavorite(req, productName);
        return result ? "이미 찜한 상품입니다." : "찜하지 않은 상품입니다.";
    }
}

