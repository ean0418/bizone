package com.flex.bizone.member;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TokenMapper {
    public abstract int makeNewToken(Bizone_pw_token bpt);
    public abstract List<Bizone_pw_token> getFullTokenByToken(Bizone_pw_token bpt);
}
