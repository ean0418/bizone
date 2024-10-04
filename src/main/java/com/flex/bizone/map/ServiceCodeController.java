package com.flex.bizone.map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ServiceCodeController {

    @Autowired
    private ServiceCodeMapper serviceCodeMapper;  // MyBatis DAO(Mapper) 주입

    @GetMapping("/services/all")
    @ResponseBody
    public List<ServiceCode> getAllServices() {
        return serviceCodeMapper.getAllServices();  // DB에서 서비스 코드 가져오기
    }
}
