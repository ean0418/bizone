package com.flex.bizone.member;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.csrf.CsrfToken;
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
import java.security.Principal;
import java.sql.Date;
import java.util.*;

@RequestMapping("/member")
@Controller
public class MemberController {

    @Autowired
    private MemberDAO mDAO;

    @GetMapping("/step1")
    public String showStep1(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/joinStep1.jsp");
        return "index"; // agreement step
    }

    @PostMapping("/signup.do")
    public String signupMember(Bizone_member m, HttpServletRequest req, HttpServletResponse res) throws Exception {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        try {
            String kakao_id = (String) req.getSession().getAttribute("kakaoID");
            m.setBm_kakao_id(kakao_id);
            req.getSession().setAttribute("kakaoID", null);
        } catch (Exception ignored) {}
        m.setBm_role("USER");
        m.setBm_signupDate(new Date(System.currentTimeMillis()));
        mDAO.signupMember(req, m);
        req.setAttribute("contentPage", "member/joinStep3.jsp");
        return "index";
    }

    @GetMapping("/login")
    public String goMemberLogin(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/login.jsp");
        return "index";
    }

    @GetMapping("/signup")
    public String goSignup(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/signup.jsp");
        return "index";
    }

    @GetMapping(value = "/verifyId.check", produces = "application/json; charset=UTF-8")
    public @ResponseBody Map<String, Object> memberIdCheck(Bizone_member m) {
        System.out.println(m.getBm_id());
        return mDAO.memberIdCheck(m);
    }

    @GetMapping("/info")
    public String goMemberInfo(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/info.jsp");
        return "index";
    }

    @GetMapping("/delete")
    public String memberDelete(HttpServletRequest req, HttpServletResponse res, Principal principal, Authentication auth) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.delete(req, principal.getName(), res, auth);
        req.setAttribute("contentPage", "map/map.jsp");
        return "index";
    }

    @PostMapping("/update")
    public String memerUpdate(HttpServletRequest req, HttpServletResponse res, Principal principal) throws UnsupportedEncodingException {
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        mDAO.update(req, principal.getName());
        req.setAttribute("contentPage", "member/info.jsp");
        return "index";
    }

    @GetMapping("/kakao.login")
    public String loginpage_kakao_callback(HttpServletRequest request, HttpServletResponse response,
                                           HttpSession session, Model model) throws Exception {

        // URL Path 및 파라미터 처리
        UrlPathHelper urlPathHelper = new UrlPathHelper();
        String originalURL = urlPathHelper.getOriginatingRequestUri(request);
        Map<String, String[]> paramMap = request.getParameterMap();
        Iterator<String> keyData = paramMap.keySet().iterator();

        // CommonData 대신 HashMap 사용
        Map<String, String> dto = new HashMap<>();
        while (keyData.hasNext()) {
            String key = keyData.next();
            String[] value = paramMap.get(key);
            dto.put(key, value[0]);
        }

        // Access Token 요청
        String url = "https://kauth.kakao.com/oauth/token";
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        LinkedMultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("client_id", "412e7727ffd0b8900060854044814879");
        String redirect_url = "http://localhost/member/kakao.login";
        map.add("redirect_uri", redirect_url);
        map.add("grant_type", "JGu5TGA6vgs4o_623UC0EKUkFgzabCH8WBHPwEm-l0_1fOKcLa3m5wAAAAQKKcleAAABkg3I7-QFVMIyByjmyg");
        map.add("code", dto.get("code")); // 인가 코드 추가

        HttpEntity<LinkedMultiValueMap<String, String>> request2 = new HttpEntity<>(map, headers);
        Map<String, Object> response2 = restTemplate.postForObject(url, request2, Map.class);

        // Access Token 출력
        model.addAttribute("access_token", response2.get("access_token"));

        return "/member/kakao.login";
    }

    @GetMapping("/findID")
    public String idFind(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/idFind.jsp");
        return "index";
    }

    @RequestMapping(value = "/findPW", method = RequestMethod.GET)
    public String pwFind(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/pwFind.jsp");
        return "index";
    }

    @RequestMapping(value = "/changePW", method = RequestMethod.GET)
    public String pwChange(HttpServletRequest req) {
        req.setAttribute("contentPage", "member/pwChange.jsp");
        String bpt_token = req.getParameter("token");
        try {
            if (mDAO.checkToken(bpt_token)) {
                req.setAttribute("status", true);
            } else {
                req.setAttribute("status", false);
                req.setAttribute("message", "토큰 기한이 만료되었습니다");
            }
        } catch (IndexOutOfBoundsException e) {
            req.setAttribute("status", false);
            req.setAttribute("message", "잘못된 접근입니다");
        }
        return "index";
    }

    @RequestMapping(value = "/changePW.do", method = RequestMethod.POST)
    public String doChangePW(HttpServletRequest req, HttpServletResponse res, Bizone_member bm) throws UnsupportedEncodingException {
        res.setCharacterEncoding("utf-8");
        req.setCharacterEncoding("utf-8");
        String bm_id = ((Bizone_member) req.getSession().getAttribute("biz_mem")).getBm_id();
        System.out.println(bm_id);
        bm.setBm_id(bm_id);
        bm.setBm_pw(req.getParameter("bm_pw"));
        if (mDAO.pwChange(bm)) {
            req.setAttribute("contentPage", "member/pwChangeSuccess.jsp");
        } else {
            req.setAttribute("contentPage", "member/login.jsp");
        }
        return "index";
    }



}
