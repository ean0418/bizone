package com.flex.bizone.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.GrantedAuthority;

public class SecurityUtils {

    // 사용자가 특정 역할을 가지고 있는지 확인하는 메서드
    public static boolean hasRole(String role) {
        // 현재 인증 정보를 가져옴
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 인증된 사용자가 없는 경우 false 반환
        if (authentication == null || authentication.getAuthorities() == null) {
            return false;
        }

        // 사용자가 가진 권한을 순회하며 주어진 역할이 있는지 확인
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            if (authority.getAuthority().contains(role)) {
                return true;
            }
        }

        return false;
    }
}