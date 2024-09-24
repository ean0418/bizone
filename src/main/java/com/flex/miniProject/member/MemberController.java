package com.flex.miniProject.member;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UrlPathHelper;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.util.*;

@Controller
public class MemberController {

    @Autowired
    private MemberDAO mDAO;


    @RequestMapping(value = "/member.step1", method = RequestMethod.GET)
    public String showStep1(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/joinStep1.jsp");
        return "main/index"; // agreement step
    }


    @RequestMapping(value = "/step1", method = RequestMethod.POST)
    public String handleStep1() {
        return "redirect:/member/signup"; // signup로 리다이렉트
    }


    @RequestMapping(value = "/signup", method = RequestMethod.POST)
    public String member(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/signup.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.signup", method = RequestMethod.POST)
    public String signupMember(Bizone_member m, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.signupMember(req, m);
        req.setAttribute("contentPage", "../member/joinStep3.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.login.go", method = RequestMethod.GET)
    public String goMemberLogin(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/login.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.signup.go", method = RequestMethod.GET)
    public String goSignup(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/signup.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.id.check", method = RequestMethod.GET, produces = "application/json; charset=UTF-8")
    public @ResponseBody Members memberIdCheck(Bizone_member m) {
        return mDAO.memberIdCheck(m);
    }


    @RequestMapping(value = "/member.login", method = RequestMethod.POST)
    public String memberLogin(Bizone_member m, HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");

        // 로그인 처리
        mDAO.login(m, req);

        // 로그인 상태 확인 후 success.jsp로 이동 여부 결정
        if (mDAO.loginCheck(req)) {
            return "member/success";  // 로그인 성공 시 메인 페이지로 이동
        } else {
            return "main/index";  // 로그인 실패 시 로그인 페이지에 그대로 유지
        }
    }

    @RequestMapping(value = "/member.info.go", method = RequestMethod.GET)
    public String goMemberInfo(HttpServletRequest req) {
        req.setAttribute("contentPage", "../member/info.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.logout", method = RequestMethod.GET)
    public String memberLogout(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.logout(req);
        req.setAttribute("contentPage", "../main/mainpage.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.delete", method = RequestMethod.GET)
    public String memberDelete(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.delete(req);
        req.setAttribute("contentPage", "../main/mainpage.jsp");
        return "main/index";
    }

    @RequestMapping(value = "/member.update", method = RequestMethod.POST)
    public String memberUpdate(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.update(req);
        req.setAttribute("contentPage", "../member/info.jsp");
        return "main/index";
    }
}