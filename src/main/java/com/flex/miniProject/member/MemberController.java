package com.flex.miniProject.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
public class MemberController {
    @RequestMapping(value = "/member", method= RequestMethod.GET)
    public String member(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/member.jsp");
        return "index";
    }
}
