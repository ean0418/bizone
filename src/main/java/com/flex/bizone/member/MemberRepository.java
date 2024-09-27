package com.flex.bizone.member;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;

@Repository
public class MemberRepository {

    // mapper를 호출하기 위한 클래스 주입.
    @Autowired
    private SqlSession sql;

    public static final String Mapper = "com.flex.miniProject.member.KakaoMapper";
    // 정보 저장
    public void kakaoInsert(KakaoVO userInfo) {
        System.out.println("userInfo: " + userInfo.getBk_nickname());
        if (sql == null) {
            System.out.println("SqlSessionTemplate is null");
        } else {
            sql.insert(Mapper + ".kakaoInsert", userInfo);
        }
    }

    // 정보 확인
    public KakaoVO findKakao(KakaoVO userInfo) {
        return sql.selectOne(Mapper + ".findKakao", userInfo);
    }
}

