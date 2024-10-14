package com.flex.bizone.admin;

import com.flex.bizone.member.Bizone_member;
import com.flex.bizone.member.MemberDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.List;

@Controller
public class AdminController {

    @Autowired
    private AdminDAO aDAO;

    // 회원 전체 조회
    @RequestMapping(value = "/memberManagement", method = RequestMethod.GET)
    public String getAllMembers(Bizone_member m, Model model) {
        List<Bizone_member> members = aDAO.getAllMembers(m); // 모든 회원 조회
        model.addAttribute("members", members); // 조회된 회원 목록을 model에 담아서 JSP로 전달
        return "admin/MemberManagement"; // JSP 페이지로 이동
    }

    // 회원 조회
    @RequestMapping(value = "/searchMember", method = RequestMethod.GET)
    public String searchMember(Bizone_member m, Model model) {
        // bm_id로 회원 검색
        List<Bizone_member> members = aDAO.searchMember(m);

        // 디버깅: 모델에 추가된 회원 목록 출력
        System.out.println("모델에 추가된 회원 목록: " + members);
        model.addAttribute("members", members);
        return "admin/MemberManagement"; // 검색 결과를 보여줄 페이지
    }


    // 회원 삭제
    @RequestMapping(value = "/deleteMember", method = RequestMethod.POST)
    public String deleteMember(Bizone_member m, HttpServletRequest req) {
        // 회원 삭제 처리
        aDAO.deleteMember(m);

        // 이전 URL로 리다이렉트 (요청 URL 유지)
        String referer = req.getHeader("Referer");  // 이전 페이지의 URL을 가져옴
        return "redirect:" + referer;  // 삭제 후 원래 있던 페이지로 리다이렉트
    }


}
