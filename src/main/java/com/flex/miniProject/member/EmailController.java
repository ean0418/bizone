package com.flex.miniProject.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class EmailController {


    @Autowired
    private EmailService eServices;

    @RequestMapping(value = "/email.send", method = RequestMethod.POST)
    public Map<String,Object> sendEmail(@RequestBody Map<String,Object> inputMap) {
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("code", eServices.joinEmail((String) inputMap.get("email")));
        return returnMap;
    }
}
