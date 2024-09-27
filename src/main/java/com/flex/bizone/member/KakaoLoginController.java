package com.flex.bizone.member;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

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

        System.out.println("kakao.getCode() : " + kakao.getCode());
        return "redirect:" + kakao.getCode();
    }

    @RequestMapping(value = "/kakaologin", method = RequestMethod.GET)
    public String kakaoLogin(@RequestParam("code") String code, HttpSession session) throws Exception {
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

        // 사용자 정보를 세션에 저장
        session.setAttribute("bk_nickname", userInfo.getBk_nickname());
        session.setAttribute("bk_profile_image_url", userInfo.getBk_profile_image_url());


        return "member/signup";
    }

}
