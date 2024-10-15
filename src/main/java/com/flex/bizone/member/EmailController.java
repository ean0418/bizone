package com.flex.bizone.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

@RestController
public class EmailController {


    @Autowired
    private EmailService eServices;

    @RequestMapping(value = "/api/email.send", method = RequestMethod.POST)
    public Map<String,Object> sendEmail(HttpServletRequest req, HttpServletResponse res, @RequestBody Map<String, Object> inputMap) throws UnsupportedEncodingException {
        req.setCharacterEncoding("utf-8");
        res.setCharacterEncoding("utf-8");
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("code", eServices.joinEmail((String) inputMap.get("email")));
        return returnMap;
    }

    @RequestMapping(value = "/idFind.send", method = RequestMethod.POST)
    public Map<String, Object> sendIdFind(HttpServletRequest req, HttpServletResponse res, @RequestBody Map<String, Object> inputMap) throws UnsupportedEncodingException {
        req.setCharacterEncoding("utf-8");
        res.setCharacterEncoding("utf-8");
        Bizone_member bm = new Bizone_member();
        bm.setBm_mail((String) inputMap.get("email"));
        return eServices.idFind(bm);
    }

    @RequestMapping(value = "/api/idExist.do", method = RequestMethod.POST)
    public Map<String, Object> checkIdExist(HttpServletRequest req, HttpServletResponse res,
                                            @RequestBody Map<String, Object> inputMap) throws UnsupportedEncodingException {
        req.setCharacterEncoding("utf-8");
        res.setCharacterEncoding("utf-8");
        Bizone_member bm = new Bizone_member();
        bm.setBm_id((String) inputMap.get("bm_id"));
        req.getSession().setAttribute("biz_mem", bm);
        return eServices.checkIdExist(bm, req);
    }

    @RequestMapping(value = "/api/getCurrentPW.do", method = RequestMethod.POST)
    public Map<String, Object> getCurrentPW(HttpServletRequest req, HttpServletResponse res,
                                            @RequestBody Map<String, Object> inputMap) throws UnsupportedEncodingException {
        req.setCharacterEncoding("utf-8");
        res.setCharacterEncoding("utf-8");
        Bizone_member bm = new Bizone_member();
        bm.setBm_id((String) inputMap.get("bm_id"));
        return eServices.getCurrentPW(bm);
    }
}
