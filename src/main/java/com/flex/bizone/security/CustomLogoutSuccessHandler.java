package com.flex.bizone.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        // 도메인과 경로를 명시하여 쿠키 삭제
        Cookie cookie = new Cookie("JSESSIONID", null);
        cookie.setPath("/"); // 경로 설정
        cookie.setDomain("localhost"); // 쿠키가 설정된 도메인 명시
        cookie.setMaxAge(0); // 즉시 만료
        response.addCookie(cookie);

        // 로그아웃 후 처리 (리다이렉트 등)
        response.sendRedirect("/");
    }
}