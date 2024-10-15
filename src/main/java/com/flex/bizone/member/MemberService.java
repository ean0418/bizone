package com.flex.bizone.member;

import org.apache.ibatis.jdbc.Null;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Service
public class MemberService implements UserDetailsService {

    @Autowired
    private final MemberDAO memberDAO;

    // 생성자를 통한 의존성 주입
    public MemberService(MemberDAO memberDAO) {
        this.memberDAO = memberDAO;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("username : " + username);
        try {
            Bizone_member m = memberDAO.findByUsername(username);
            System.out.println("Role : " + m.getBm_role());
            return User.withUsername(m.getBm_id()).password(m.getBm_pw()).roles(m.getBm_role()).build();
        } catch (NullPointerException ignored) {
            System.out.println("존재하지 않는 유저");
            throw new RuntimeException("존재하지 않는 유저");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
