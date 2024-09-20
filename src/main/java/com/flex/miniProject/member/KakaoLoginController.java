package com.flex.miniProject.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
public class KakaoLoginController {
    Kakao kakao = new Kakao();
    @RequestMapping(value = "/kakaoGetCode", method = RequestMethod.GET)
    public  String kakao() {

        System.out.println("kakao.getCode() : "+kakao.getCode());
        return "redirect:"+kakao.getCode();
    }
    @RequestMapping(value="kakaologin", method = RequestMethod.GET)
    public String kakaoLogin
            (
             @RequestParam("code") String code
            ) throws Exception{
        System.out.println("code : " + code);

        String data = (String)kakao.getHtml((kakao.getAccessToken(code)));
        System.out.println("data : "+data);

        Map<String, String> map = kakao.JsonStringMap(data);
        System.out.println("map : "+map);

        return "kakaologin";
    }

}
