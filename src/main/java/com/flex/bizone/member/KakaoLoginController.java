package com.flex.bizone.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
public class KakaoLoginController {
    Kakao kakao = new Kakao();

    @RequestMapping(value = "/kakaoGetCode", method = RequestMethod.GET)
    public String kakao() {

        System.out.println("kakao.getCode() : " + kakao.getCode());
        return "redirect:" + kakao.getCode();
    }

    @RequestMapping(value = "kakaologin", method = RequestMethod.GET)
    public String kakaoLogin
            (
             @RequestParam("code") String code
            ) throws Exception {
        System.out.println("code : " + code);

        String data = (String) kakao.getHtml((kakao.getAccessToken(code)));
        System.out.println("data : " + data);

        Map<String, String> map = kakao.JsonStringMap(data);
        System.out.println("map : "+map);

        if (map.isEmpty()) {
            System.out.println("Map is empty or failed to parse.");
        } else {
            System.out.println("map : " + map); // 변환된 map 출력
            System.out.println("access_token :" + map.get("access_token"));
            System.out.println("refresh_token : " + map.get("refresh_token"));
            System.out.println("scope :" + map.get("scope"));
            System.out.println("token_type : " + map.get("token_type"));
            System.out.println("expires_in : " + map.get("expires_in"));

            String list = kakao.getAllList((String) map.get("access_token"));
            System.out.println("list : " + list);

            Map<String, String> getAllListMap = kakao.JsonStringMap(list);
            System.out.println("getAllListMap :" + getAllListMap);
            System.out.println("nickName : " + getAllListMap.get("nickName").toString());
            System.out.println("profileImageURL :" + (String) getAllListMap.get("profileImageURL"));
            System.out.println("thumbnailURL :" + (String) getAllListMap.get("thumbnailURL"));
        }
        return "kakaologin";
    }

}
