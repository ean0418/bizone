package com.flex.miniProject.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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

    @RequestMapping(value = "/member.signup", method= RequestMethod.POST)
    public String doSignup(bizone_member m, HttpServletRequest req) {
        mDAO.signup(m, req);
        req.setAttribute("contentPage", "../member/success.jsp");
        return "main/main";
    }
}
