package com.flex.miniProject.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.util.Random;

@Component
public class EmailService {
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
}
