package com.flex.bizone.admin;

import com.flex.bizone.member.Bizone_member;
import com.flex.bizone.member.MemberMapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MMDAO {

    @Autowired
    private SqlSession ss;


    public List<Bizone_member> searchMember(Bizone_member m) {
        // 데이터베이스에서 ID로 회원 조회
        List<Bizone_member> members = ss.getMapper(MemberMapper.class).searchMembers(m);

        // 조회된 회원 리스트 출력 (콘솔 출력)
        System.out.println("검색된 회원 목록: " + members);

        return members; // 회원 목록 반환
    }

    public void deleteMember(Bizone_member m) {

        int members = ss.getMapper(MemberMapper.class).deleteMember(m);
    }

    // 모든 회원 조회
    public List<Bizone_member> getAllMembers(Bizone_member m) {
        List<Bizone_member> members = ss.getMapper(MemberMapper.class).getAllMembers(m);

        return members;
    }

    }
