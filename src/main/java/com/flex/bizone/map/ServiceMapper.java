package com.flex.bizone.map;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ServiceMapper {
    List<Bizone_service> getAllServices();  // 모든 서비스 코드를 가져오는 메소드
}
