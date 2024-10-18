package com.flex.bizone.security;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final HttpSession httpSession;

    public CustomOAuth2UserService(HttpSession httpSession) {
        this.httpSession = httpSession;
    }

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        System.out.println("CustomOAuth2UserService.loadUser 호출됨");
        OAuth2User oauth2User = super.loadUser(userRequest);

        // Kakao에서 제공하는 사용자 정보 파싱
        Map<String, Object> attributes = oauth2User.getAttributes();
        Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");

        if (kakaoAccount == null) {
            throw new OAuth2AuthenticationException(new OAuth2Error("Kakao 계정 정보가 존재하지 않습니다."));
        }

        Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
        if (profile == null) {
            throw new OAuth2AuthenticationException(new OAuth2Error("Kakao 프로필 정보가 존재하지 않습니다."));
        }

        // 필요한 정보 추출
        String nickname = (String) profile.get("nickname");
        String profileImage = (String) profile.get("profile_image_url");

        System.out.println("Nickname : " + nickname);
        System.out.println("ProfileImage : " + profileImage);
        // 필요한 경우 사용자 엔티티 저장 또는 업데이트 로직 추가

        // 사용자 정보를 담은 새로운 OAuth2User 객체 반환
        Map<String, Object> updatedAttributes = new HashMap<>(attributes);
        updatedAttributes.put("nickname", nickname);
        updatedAttributes.put("profile_image_url", profileImage);

        // 권한 설정 (여러 권한 추가 가능)
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));

        // 추가 권한
        authorities.add(new SimpleGrantedAuthority("ROLE_KAKAO"));

        return new DefaultOAuth2User(
                authorities,
                updatedAttributes,
                "id"
        );
    }
}