package com.flex.bizone.security;

import com.flex.bizone.member.MemberDAO;
import com.flex.bizone.member.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
@ComponentScan(basePackages = "com.flex.bizone")
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private final MemberService memberService;

    @Autowired
    @Lazy
    public SecurityConfig(MemberService memberService) {
        this.memberService = memberService;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        // 사용자 정의 서비스와 패스워드 인코더 설정
        auth.userDetailsService(memberService).passwordEncoder(passwordEncoder());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
//                .authorizeRequests()
//                .antMatchers("/**", "/member.**", "/member.signup.go", "/").permitAll() // 접근 허용 경로 설정
//                .anyRequest().authenticated() // 그 외의 모든 요청은 인증 필요
                .authorizeRequests()
                    .antMatchers("/admin/**").hasRole("ADMIN")
                    .antMatchers("/member/logout", "/board/insert.go", "/board/update.go", "/board/delete", "/api/bizone/getChartDataForDetail**", "/loan-products", "/member/info").authenticated()
                    .anyRequest().permitAll()
                    .and()
                .formLogin()
                    .loginPage("/member/login") // 사용자 정의 로그인 페이지
                    .defaultSuccessUrl("/", true) // 로그인 성공 후 리디렉션 경로
                    .permitAll()
                    .and()
                .logout()
                    .logoutUrl("/member/logout")
                    .logoutSuccessUrl("/") // 로그아웃 성공 후 경로
                    .permitAll()
                    .and()
                .csrf().disable();
    }



    // PasswordEncoder 설정 (Spring Security 5 이상에서는 필수)
    @SuppressWarnings("deprecation")
    @Bean
    public PasswordEncoder passwordEncoder() {
        return NoOpPasswordEncoder.getInstance(); // 인코딩 없음 사용
    }
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder(); // BCryptPasswordEncoder 사용
//    }
}