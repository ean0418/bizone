package com.flex.bizone.member;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

@Component
public class EmailService {
    @Autowired
    private SqlSession ss;

    @Autowired
    private JavaMailSenderImpl mailSender;
    private int authNumber;

    public void makeAuthNumber() {
        authNumber = new Random().nextInt(888889) + 111111;
    }

    public void sendMail(String toMail, String title, String content) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
            String setFrom = "minjulv06101@gmail.com";
            helper.setFrom(setFrom);
            helper.setTo(toMail);
            helper.setSubject(title);
            helper.setText(content, true);
            mailSender.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public String joinEmail(String email) {
        makeAuthNumber();
        String title = "[Bizone] 회원가입 인증 이메일";
        String content = "인증번호는 <b>"+ authNumber + "</b> 입니다";
        sendMail(email,title,content);
        return Integer.toString(authNumber);
    }

    public Map<String, Object> idFind(Bizone_member bm) {
        makeAuthNumber();
        List<Bizone_member> idMap = ss.getMapper(MemberMapper.class).getIdByEmail(bm);
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("idCode", authNumber);
        try {
            returnMap.put("id", idMap.get(0).getBm_id());
        } catch (IndexOutOfBoundsException e) {
            returnMap.put("id", "해당 이메일로 등록된 id가 없습니다");
        }
        String setFrom = "minjulv06101@gmail.com";
        String title = "[Bizone] 아이디 찾기 코드";
        String content = "코드번호는 <b>"+ authNumber + "</b> 입니다";
        sendMail(bm.getBm_mail(), title, content);
        return returnMap;
    }

    private static String getPasswordUrl(HttpServletRequest req, String token) {
        String scheme = req.getScheme();
        int serverPort = req.getServerPort();
        String serverName = req.getServerName();
        String contextPath = "/pwChange.go?token=" + token;
        String baseUrl;
        if ((scheme.equals("http") && serverPort == 80) || (scheme.equals("https") && serverPort == 443)) {
            baseUrl = scheme + "://" + serverName + contextPath;
        } else {
            baseUrl = scheme + "://" + serverName + ":" + serverPort + contextPath;
        }
        return baseUrl;
    }

    public static Timestamp getExpiration() {
        // 현재 시간 가져오기
        LocalDateTime now = LocalDateTime.now();

        // 현재 시간에 10분을 더하기
        LocalDateTime tenMinutesLater = now.plusMinutes(10);

        // LocalDateTime을 Timestamp로 변환
        return Timestamp.valueOf(tenMinutesLater);
    }

    public Map<String, Object> checkIdExist(Bizone_member bm, HttpServletRequest req) {
        List<Bizone_member> member = ss.getMapper(MemberMapper.class).getMemberById(bm);
        Map<String, Object> returnMap = new HashMap<>();
        if (member.isEmpty()) {
            returnMap.put("founded", false);
        } else {
            returnMap.put("founded", true);
            String token = UUID.randomUUID().toString();
            System.out.println(token);
            Timestamp bpt_expiration = getExpiration();
            Bizone_pw_token bpt = new Bizone_pw_token(token, bpt_expiration);
            ss.getMapper(TokenMapper.class).makeNewToken(bpt);
            String baseUrl = getPasswordUrl(req, token);
            String title = "[Bizone] 비밀번호 변경";
            String content = "아래 비밀번호 변경을 누르면, 비밀" +
                    "번호 변경 탭으로 넘어갑니다.<br>" +
                    "<a href='"+ baseUrl+ "'>비밀번호 변경</a>";
            sendMail(member.get(0).getBm_mail(), title, content);
        }
        return returnMap;
    }

    public Map<String, Object> getCurrentPW(Bizone_member bm) {
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("bm_pw", ss.getMapper(MemberMapper.class).getMemberById(bm).get(0).getBm_pw());
        System.out.println(returnMap.get("bm_pw"));
        return returnMap;
    }

}
