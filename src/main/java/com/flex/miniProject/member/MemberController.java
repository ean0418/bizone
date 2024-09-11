package com.flex.miniProject.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class MemberController {

    @Autowired
    private MemberDAO mDAO;

    @RequestMapping(value = "/member", method= RequestMethod.GET)
    public String member(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/signup.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.signup", method = RequestMethod.GET)
    public String doSignup(Bizone_member m, HttpServletRequest req, HttpServletResponse res) throws Exception {
        System.out.println(m);
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        System.out.println(m.getBm_id());
        mDAO.signupMember(m);
        req.setAttribute("contentPage", "../member/success.jsp");
        return "main/main";
    }
}
