package com.flex.bizone.admin;


import com.flex.bizone.member.Bizone_member;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class BMController {

    @Autowired
    private BMDAO bmDAO;


    @RequestMapping(value = "/admin/boardManagement", method = RequestMethod.GET)
    public String boardList(@RequestParam(defaultValue = "1") int page,
                            @RequestParam(defaultValue = "") String bb_bm_id,
                            HttpServletRequest req, Model model) {
        bmDAO.getAllBoards(page, bb_bm_id, req); // 게시글 목록을 요청
        model.addAttribute("boardList", req.getAttribute("boardList")); // boardList를 JSP로 전달
        model.addAttribute("page", req.getAttribute("page"));
        model.addAttribute("totalPages", req.getAttribute("totalPages"));
        model.addAttribute("bb_bm_id", bb_bm_id); // 검색 필터값 유지
        model.addAttribute("contentPage", "admin/BoardManagement.jsp");
        return "index";
    }

    // 회원 삭제
    @RequestMapping(value = "/admin/deleteBoard", method = RequestMethod.POST)
    public String deleteMember(int bb_no, HttpServletRequest req) {
        // 회원 삭제 처리
        bmDAO.deleteBoard(bb_no, req);

        // 이전 URL로 리다이렉트 (요청 URL 유지)
        String referer = req.getHeader("Referer");  // 이전 페이지의 URL을 가져옴
        return "redirect:" + referer;  // 삭제 후 원래 있던 페이지로 리다이렉트
    }
}
