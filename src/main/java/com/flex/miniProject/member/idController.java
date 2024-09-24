package com.flex.miniProject.member;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
public class idController {

    @Autowired
    private MemberDAO memberDAO;

    @RequestMapping(value = "/member.id.check", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Boolean> checkIdDuplication(@RequestParam("bm_id") String bm_id) {
        boolean exists = memberDAO.checkIfIdExists(bm_id);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists); // 존재하면 true, 없으면 false 반환
        return response;
    }
}
