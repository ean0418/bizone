package com.flex.bizone.security;

import com.flex.bizone.member.Bizone_member;
import com.flex.bizone.member.MemberMapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RestController;

import java.util.Objects;

@RestController
public class AuthController {

    @Autowired
    private SqlSession ss;

    @GetMapping("/api/auth/status")
    @ResponseBody
    public String authStatus() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !Objects.equals(authentication.getName(), "anonymousUser")) {
            boolean isKakao = SecurityUtils.hasRole("KAKAO");
            if (isKakao) {
                Bizone_member m = new Bizone_member();
                m.setBm_kakao_id(authentication.getName());
                String realID = ss.getMapper(MemberMapper.class).getMemberByKakaoID(m).get(0).getBm_id();
                return "{\"loggedIn\": true, \"username\": \"" + authentication.getName() + "\", \"isKakaoLogin\": \""+ isKakao +"\", \"realID\": \"" + realID + "\"}";
            } else {
                return "{\"loggedIn\": true, \"username\": \"" + authentication.getName() + "\", \"isKakaoLogin\": \""+ isKakao +"\"}";
            }
        } else {
            return "{\"loggedIn\": false}";
        }
    }
}
