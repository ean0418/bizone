package com.flex.bizone.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

@Component
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler {


    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        // 인증 성공 후 추가 작업 수행
        System.out.println("Authentication 성공: " + authentication.getName());

        // 예: 홈 페이지로 리디렉션
        if (authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_KAKAO"))) {
            response.sendRedirect("/member/fillIn");
        } else {
            response.sendRedirect("/");
        }
    }
}