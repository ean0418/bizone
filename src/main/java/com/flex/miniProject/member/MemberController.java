package com.flex.miniProject.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MemberController {

    @Autowired
    private MemberDAO mDAO;

    @RequestMapping(value = "/member", method= RequestMethod.GET)
    public String member(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/signup.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.signup", method = RequestMethod.POST)
    public String doSignup(@RequestParam(value = "bm_id", required = false) String id, Bizone_member m, HttpServletRequest req) {
        System.out.println(m.getBm_id());
        System.out.println(id);
        mDAO.signup(m, req);
        System.out.println(m.getBm_id());
        req.setAttribute("contentPage", "../member/success.jsp");
        return "main/main";
    }
}
