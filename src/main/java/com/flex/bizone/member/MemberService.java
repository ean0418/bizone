package com.flex.bizone.member;

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
        System.out.println("### MemberService 생성자 호출됨. memberDAO: " + memberDAO);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("username : " + username);
        Bizone_member m = memberDAO.findByUsername(username);
        System.out.println("Role : " + m.getBm_role());
        if (m.getBm_role().equals("ADMIN")){
            return User.withUsername(m.getBm_id())
                    .password(m.getBm_pw())
                    .roles(m.getBm_role())
                    .build();
        } else if (m.getBm_role().equals("USER")) {
            return User.withUsername(m.getBm_id())
                    .password(m.getBm_pw())
                    .roles(m.getBm_role())
                    .build();
        } else {
            throw new UsernameNotFoundException("해당 사용자를 찾을 수 없습니다: " + username);
        }
    }
}
