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
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
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
            String bm_addr1 = req.getParameter("bm_addr1");
            String bm_addr2 = req.getParameter("bm_addr2");
            String bm_addr3 = req.getParameter("bm_addr3");
            String bm_address = bm_addr1 + " " + bm_addr2 + " " + bm_addr3;
            m.setBm_address(bm_address);

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
        try {
            return ss.getMapper(MemberMapper.class).getMemberById(m).get(0);
        } catch (IndexOutOfBoundsException iooe) {
            return null;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public void login(Bizone_member m, HttpServletRequest req) {
        try {
            // 데이터베이스에서 ID로 회원 조회
            List<Bizone_member> members = ss.getMapper(MemberMapper.class).getMemberById(m);
            System.out.println(req.getSession().getAttribute("kakaoID"));
            try {
                String kakao_id = (String) req.getSession().getAttribute("kakaoID");
                m.setBm_kakao_id(kakao_id);
                ss.getMapper(MemberMapper.class).connectKakao(m);
                req.getSession().setAttribute("kakaoID", null);
            } catch (Exception ignored) {}
            if (members.size() != 0) {
                Bizone_member dbM = members.get(0);

                // 비밀번호 일치 여부 확인
                if (dbM.getBm_pw().equals(m.getBm_pw())) {
                    req.setAttribute("r", "로그인 성공");
                    req.getSession().setAttribute("loginMember", dbM);
                    req.getSession().setMaxInactiveInterval(600); // 세션 유지 시간 설정
                    // 로그인 성공 시 success.jsp로 이동
                    req.setAttribute("contentPage", "main/main.jsp");
                } else {
                    // 비밀번호 오류 시
                    req.setAttribute("r", "로그인 실패(PW 오류)");
                    req.setAttribute("contentPage", "member/login.jsp");
                }
            } else {
                // ID가 없는 경우
                req.setAttribute("r", "로그인 실패(ID 없음)");
                req.setAttribute("contentPage", "member/login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "로그인 실패(DB서버)");
            req.setAttribute("contentPage", "member/login.jsp");
        }
    }

    public boolean loginCheck(HttpServletRequest req) {
        Bizone_member m = (Bizone_member) req.getSession().getAttribute("loginMember");
        if (m != null) {
            // 로그인 성공 + 상태 유지시
            req.setAttribute("lp", "main/main.jsp");
            return true;
        }
        // 로그인상태가 아니거나 + 로그인 실패시
        req.setAttribute("lp", "member/login.jsp");
        return false;
    }

    public void logout(HttpServletRequest req) {
        try {
            req.getSession().setAttribute("loginMember", null);
            req.setAttribute("r", "로그아웃 성공");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "로그아웃 성공");
        }
    }

    public void delete(HttpServletRequest req) {
        try {
            Bizone_member m = (Bizone_member) req.getSession().getAttribute("loginMember");
            if (ss.getMapper(MemberMapper.class).deleteMember(m) == 1) {
                req.setAttribute("r", "탈퇴 성공");
                req.getSession().setAttribute("loginMember", null);


            } else {
                req.setAttribute("r", "이미 탈퇴처리 됨");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "탈퇴 실패(DB서버)");
        }
    }

    public void update(HttpServletRequest req) {

        Bizone_member m = (Bizone_member) req.getSession().getAttribute("loginMember");


        try {
            m.setBm_pw(req.getParameter("bm_pw"));
            m.setBm_name(req.getParameter("bm_name"));
            m.setBm_name(req.getParameter("bm_nickname"));
            m.setBm_phoneNum(req.getParameter("bm_phoneNum"));
            m.setBm_mail(req.getParameter("bm_mail"));


            m.setBm_address(req.getParameter("bm_address"));

            if (ss.getMapper(MemberMapper.class).updateMember(m) == 1) {
                req.setAttribute("r", "정보 수정 성공");

                req.getSession().setAttribute("loginMember", m);
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




