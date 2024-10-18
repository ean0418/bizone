package com.flex.bizone.security;

import com.flex.bizone.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.OAuth2LoginAuthenticationFilter;
import org.springframework.security.oauth2.core.AuthorizationGrantType;
import org.springframework.security.oauth2.core.ClientAuthenticationMethod;

@Configuration
@EnableWebSecurity
@ComponentScan(basePackages = "com.flex.bizone")
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private final MemberService memberService;
    private final CustomOAuth2UserService customOAuth2UserService;
    private final CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;
    private final CustomLogoutSuccessHandler customLogoutSuccessHandler;


    @Autowired
    @Lazy
    public SecurityConfig(MemberService memberService, CustomOAuth2UserService customOAuth2UserService,
                          CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler, CustomLogoutSuccessHandler customLogoutSuccessHandler) {
        this.memberService = memberService;
        this.customOAuth2UserService = customOAuth2UserService;
        this.customAuthenticationSuccessHandler = customAuthenticationSuccessHandler;
        this.customLogoutSuccessHandler = customLogoutSuccessHandler;
    }


    @Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }


    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        // 사용자 정의 서비스와 패스워드 인코더 설정
        auth.userDetailsService(memberService).passwordEncoder(passwordEncoder());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .csrf()
//                    .disable() // 테스트를 위해 잠시 사용중
                    .ignoringAntMatchers("/api/**", "/loan-products")
                    .and()
                .authorizeRequests()
                    .antMatchers("/admin/**").hasAuthority("ADMIN")
                    .antMatchers("/member/logout", "/board/insert.go", "/board/update.go", "/board/delete", "/api/bizone/getChartDataForDetail**", "/loan-products", "/member/info").authenticated()
                    .anyRequest().permitAll()
                    .and()
                .formLogin()
                    .loginPage("/member/login") // 사용자 정의 로그인 페이지
                    .defaultSuccessUrl("/") // 로그인 성공 후 리디렉션 경로
                    .failureUrl("/member/login")  // 로그인 실패 시 경로
                    .permitAll()
                    .and()
                .oauth2Login()
                    .loginPage("/member/login")  // 사용자 정의 로그인 페이지
                    .userInfoEndpoint()
                        .userService(customOAuth2UserService)  // 사용자 정보 서비스 설정
                        .and()
                    .successHandler(customAuthenticationSuccessHandler)
                    .failureUrl("/member/login")  // 로그인 실패 시 경로
                    .permitAll()
                    .and()
                .logout()
                    .logoutUrl("/member/logout")
                    .logoutSuccessHandler(customLogoutSuccessHandler)
                    .invalidateHttpSession(true)  // Invalidate session on logout
                    .deleteCookies("JSESSIONID")
                    .permitAll();


    }


    @Bean
    public ClientRegistrationRepository clientRegistrationRepository() {
        return new InMemoryClientRegistrationRepository(kakaoClientRegistration());
    }


    private ClientRegistration kakaoClientRegistration() {
        return ClientRegistration.withRegistrationId("kakao")
                .clientId("412e7727ffd0b8900060854044814879") // 실제 client-id로 교체
                .clientAuthenticationMethod(ClientAuthenticationMethod.BASIC) // 명시적으로 설정
                .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
                .redirectUriTemplate("http://localhost/login/oauth2/code/kakao") // 고정된 Redirect URI 사용
                .scope("profile_nickname", "profile_image") // 필요한 스코프 추가
                .clientAuthenticationMethod(ClientAuthenticationMethod.POST)
                .authorizationUri("https://kauth.kakao.com/oauth/authorize")
                .tokenUri("https://kauth.kakao.com/oauth/token")
                .userInfoUri("https://kapi.kakao.com/v2/user/me")
                .userNameAttributeName("id")
                .clientName("Kakao")
                .build();
    }

    // PasswordEncoder 설정 (Spring Security 5 이상에서는 필수)
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12); // BCryptPasswordEncoder 사용
    }
}