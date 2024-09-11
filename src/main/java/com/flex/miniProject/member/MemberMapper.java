package com.flex.miniProject.member;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MemberMapper {
    public abstract int signupMember(Bizone_member m);
    public abstract List<Bizone_member> getMemberById(Bizone_member m);
    public abstract int deleteMember(Bizone_member m);
    public abstract int updateMember(Bizone_member m);
}
