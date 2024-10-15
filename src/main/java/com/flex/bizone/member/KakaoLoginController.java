package com.flex.bizone.member;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
public class KakaoLoginController {

    @Autowired
    Kakao kakao;

    @Autowired
    private HttpSession session;

    @RequestMapping(value = "/kakaoGetCode", method = RequestMethod.GET)
    public String kakao() {

        System.out.println("kakao.getCode() : " + Kakao.getCode());
        return "redirect:" + Kakao.getCode();
    }

    @RequestMapping(value = "/kakaologin", method = RequestMethod.GET)
    public String kakaoLogin(@RequestParam("code") String code, HttpServletRequest req) throws Exception {
        System.out.println("code : " + code);

        // 액세스 토큰 가져오기
        String accessToken = kakao.getAccessToken(code);
        System.out.println("accessToken : " + accessToken);

        if (accessToken == null || accessToken.isEmpty()) {
            System.out.println("Failed to get access token");
            return "member/success"; // 액세스 토큰을 받지 못하면 에러 페이지로 리턴
        }

        // 사용자 정보 가져오기
        KakaoVO userInfo = kakao.getUserInfo(accessToken);

        if (userInfo == null) {
            System.out.println("Failed to get user info");
            return "member/success"; // 사용자 정보를 가져오지 못하면 에러 페이지로 리턴
        }

        Bizone_member m = new Bizone_member();
        m.setBm_kakao_id(userInfo.getBk_id());

        try {
            Bizone_member bm = kakao.isKakaoUser(m);
            req.getSession().setAttribute("loginMember", bm);
            req.getSession().setMaxInactiveInterval(600);
        } catch (IndexOutOfBoundsException ignored) {
            req.getSession().setAttribute("kakaoID", m.getBm_kakao_id());
            req.setAttribute("contentPage", "member/route.jsp");
            return "index";
        }

        req.setAttribute("contentPage", "main/main.jsp");
        return "index";
    }

}
