package com.flex.bizone.member;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
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

    public void sendMail(String setFrom, String toMail, String title, String content) {
        MimeMessage message = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
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
        String setFrom = "minjulv06101@gmail.com";
        String title = "[Bizone] 회원가입 인증 이메일";
        String content = "인증번호는 <b>"+ authNumber + "</b> 입니다";
        sendMail(setFrom,email,title,content);
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
        sendMail(setFrom, bm.getBm_mail(), title, content);
        return returnMap;
    }
}
