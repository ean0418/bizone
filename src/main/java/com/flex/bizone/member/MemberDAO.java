package com.flex.bizone.member;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Repository;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class MemberDAO {

    @Autowired
    private SqlSession ss;

    @Autowired
    private PasswordEncoder passwordEncoder;



    private String getAccessToken(String code) throws IOException {
// HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

// HTTP Body 생성
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type", "authorization_code");
        body.add("client_id", "카카오developer에서 받은 restApiKey");
        body.add("redirect_uri", "http://서버IP/user/kakao/callback");
        body.add("code", code);

// HTTP 요청 보내기
        HttpEntity<MultiValueMap<String, String>> kakaoTokenRequest = new HttpEntity<>(body, headers);
        RestTemplate rt = new RestTemplate();
        ResponseEntity<String> response = rt.exchange(
                "https://kauth.kakao.com/oauth/token",
                HttpMethod.POST,
                kakaoTokenRequest,
                String.class
        );

// HTTP 응답 (JSON) -> 액세스 토큰 파싱
        String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);
        return jsonNode.get("access_token").asText();
    }


    public void signupMember(HttpServletRequest req, Bizone_member m) {
        try {

            req.setCharacterEncoding("utf-8");
            String bm_addr1 = req.getParameter("bm_addr1");
            String bm_addr2 = req.getParameter("bm_addr2");
            String bm_addr3 = req.getParameter("bm_addr3");
            String bm_address = bm_addr1 + " " + bm_addr2 + " " + bm_addr3;
            m.setBm_address(bm_address);
            // 현재 날짜를 bm_signupDate에 설정
            m.setBm_signupDate(new Date(System.currentTimeMillis()));

            // 회원 역할 설정
            m.setBm_role("USER");

            String hashedPw = passwordEncoder.encode(m.getBm_pw());
            m.setBm_pw(hashedPw);
            ss.getMapper(MemberMapper.class).signupMember(m);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public Map<String, Object> memberIdCheck(Bizone_member m) {
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", false);
        try {
            Bizone_member bm = ss.getMapper(MemberMapper.class).getMemberById(m).get(0);
            returnMap.put("status", true);
            returnMap.put("bm_id", bm.getBm_id());
        } catch (IndexOutOfBoundsException ignored) {
            return returnMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return returnMap;
    }

    public Bizone_member findByUsername(String username) {
        Bizone_member m = new Bizone_member();
        m.setBm_id(username);
        System.out.println("in dao" + username);
        try {
            return ss.getMapper(MemberMapper.class).getMemberById(m).get(0);
        } catch (IndexOutOfBoundsException iooe) {
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void delete(HttpServletRequest req, String bm_id, HttpServletResponse res, Authentication authentication) {
        try {
            Bizone_member m = new Bizone_member();
            m.setBm_id(bm_id);
            if (ss.getMapper(MemberMapper.class).deleteMember(m) == 1) {
                req.setAttribute("r", "탈퇴 성공");
                new SecurityContextLogoutHandler().logout(req, res, authentication);
            } else {
                req.setAttribute("r", "이미 탈퇴처리 됨");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "탈퇴 실패(DB서버)");
        }
    }

    public void update(HttpServletRequest req, String bm_id) {
        Bizone_member inputM = new Bizone_member();
        inputM.setBm_id(bm_id);
        try {
            Bizone_member m = ss.getMapper(MemberMapper.class).getMemberById(inputM).get(0);
            m.setBm_pw(req.getParameter("bm_pw"));
            m.setBm_name(req.getParameter("bm_name"));
            m.setBm_name(req.getParameter("bm_nickname"));
            m.setBm_phoneNum(req.getParameter("bm_phoneNum"));
            m.setBm_mail(req.getParameter("bm_mail"));


            m.setBm_address(req.getParameter("bm_address"));

            if (ss.getMapper(MemberMapper.class).updateMember(m) == 1) {
                req.setAttribute("r", "정보 수정 성공");
            } else {
                req.setAttribute("r", "정보 수정 실패");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "정보 수정 실패");

        }


    }

    public boolean checkToken(String bpt_token) throws IndexOutOfBoundsException {
        Bizone_pw_token bpt = new Bizone_pw_token();
        bpt.setBpt_token(bpt_token);
        List<Bizone_pw_token> tokens = ss.getMapper(TokenMapper.class).getFullTokenByToken(bpt);
        Timestamp exp = tokens.get(0).getBpt_expiration();
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return now.before(exp);
    }

    public boolean pwChange(Bizone_member bm) {
        try {
            ss.getMapper(MemberMapper.class).changePW(bm);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}




