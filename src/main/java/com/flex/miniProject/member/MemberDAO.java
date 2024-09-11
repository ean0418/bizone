package com.flex.miniProject.member;
import org.apache.ibatis.session.SqlSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Service
public class MemberDAO {

    @Autowired
    private SqlSession ss;

    public void signupMember(Bizone_member m) {
        try {
            System.out.println(m);
            System.out.println(m.getBm_id());
            ss.getMapper(MemberMapper.class).signupMember(m);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public Members memberIdCheck(Bizone_member m) {
        return new Members(ss.getMapper(MemberMapper.class).getMemberById(m));
    }

    public void login(Bizone_member m, HttpServletRequest req) {
        try {
            List<Bizone_member> members = ss.getMapper(MemberMapper.class).getMemberById(m);
            if (members.size() != 0) {
                Bizone_member dbM = members.get(0);


                if (dbM.getBm_pw().equals(m.getBm_pw())) {
                    req.setAttribute("r", "로그인 성공");
                    req.getSession().setAttribute("loginMember", dbM);
                    req.getSession().setMaxInactiveInterval(600);

                } else {
                    req.setAttribute("r", "로그인 실패(PW 오류");
                }
            } else {
                req.setAttribute("r", "로그인 실패(ID 없음)");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("r", "로그인 실패(DB서버)");
        }
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
            m.setBm_id(req.getParameter("bm_id"));
            m.setBm_pw(req.getParameter("bm_pw"));
            m.setBm_name(req.getParameter("bm_name"));
            m.setBm_name(req.getParameter("bm_nickname"));
            m.setBm_phoneNum(req.getParameter("bm_phoneNum"));
//            m.setBm_birthday(sdf.parse(req.getParameter("bm_birthday")));
            m.setBm_mail(req.getParameter("bm_mail"));

            String bm_addr1 = req.getParameter("bm_addr1");
            String bm_addr2 = req.getParameter("bm_addr2");
            String bm_addr3 = req.getParameter("bm_addr3");
            String bm_address = bm_addr2 + "!" + bm_addr3 + "!" + bm_addr1;
            m.setBm_address(bm_address);

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

    }}
