package com.flex.miniProject.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;

@Controller
public class MemberController {

    @Autowired
    private MemberDAO mDAO;

    @RequestMapping(value = "/signup", method= RequestMethod.GET)
    public String member(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/signup.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.signup", method = RequestMethod.POST)
    public String signupMember(Bizone_member m, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.signupMember(req, m);
        req.setAttribute("contentPage", "../member/success.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.login.go", method = RequestMethod.GET)
    public String goMemberLogin(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/login.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.signup.go", method = RequestMethod.GET)
    public String goSignup(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/signup.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.id.check", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public @ResponseBody Members memberIdCheck(Bizone_member m) {
        return mDAO.memberIdCheck(m);
    }

    @RequestMapping(value = "/member.login", method = RequestMethod.POST)
    public String memberLogin(Bizone_member m, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.login(m, req);
        req.setAttribute("contentPage", "../main/mainpage.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.info.go", method = RequestMethod.GET)
    public String goMemberInfo(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/info.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.logout", method = RequestMethod.GET)
    public String memberLogout(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.logout(req);
        req.setAttribute("contentPage", "../main/mainpage.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.delete", method = RequestMethod.GET)
    public String memberDelete(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.delete(req);
        req.setAttribute("contentPage", "../main/mainpage.jsp");
        return "main/main";
    }

    @RequestMapping(value = "/member.update", method = RequestMethod.POST)
    public String memberUpdate(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.update(req);
        req.setAttribute("contentPage", "../member/info.jsp");
        return "main/main";
    }
}
