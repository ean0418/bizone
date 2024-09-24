package com.flex.miniProject.member;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.codec.Charsets;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

@Service
public class Kakao {
    // Rest api
    private static final String RestApiKey = "412e7727ffd0b8900060854044814879";
    private static final String Redirect_URL = "http://localhost/kakaologin";
    private static final String keyHost = "https://kauth.kakao.com";

    public static String getCode() {
        String getcode = keyHost + "/oauth/authorize?response_type=code&client_id=" + RestApiKey;
        getcode += "&redirect_uri=" + Redirect_URL;
        getcode += "&response_type=code";
        return getcode;
    }

    public static String getAccessToken(String authorize_code) {
        String getAccesToken = "https://kauth.kakao.com/oauth/token?grant_type=authorization_code";
        getAccesToken += "&client_id=" + RestApiKey;
        getAccesToken += "&redirect_uri=" + Redirect_URL;
        getAccesToken += "&code=" + authorize_code;
        return getAccesToken;
    }

    public static String getHtml(String accessToken) {
        HttpURLConnection urlconn = null;
        String returnresult = null;
        try {
            URL url = new URL(accessToken);
            urlconn = (HttpURLConnection) url.openConnection();

            urlconn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            urlconn.setRequestMethod("POST");
            urlconn.setDoOutput(true);
            urlconn.connect();

            // UTF-8로 데이터 읽기
            BufferedReader in = new BufferedReader(new InputStreamReader(urlconn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String result = null;

            while ((result = in.readLine()) != null) {
                sb.append(result).append("\n");
            }
            returnresult = sb.toString();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return returnresult;
    }

    public static Map<String, String> JsonStringMap(String data) {
        Map<String, String> map = new HashMap<String, String>();
        ObjectMapper mapper = new ObjectMapper();

        try {
            // JSON 문자열을 UTF-8로 Map으로 변환
            map = mapper.readValue(data.getBytes(StandardCharsets.UTF_8), new TypeReference<HashMap<String, String>>() {});
        } catch (JsonParseException e) {
            e.printStackTrace();
            System.out.println("Error parsing JSON: Invalid JSON format");
        } catch (JsonMappingException e) {
            e.printStackTrace();
            System.out.println("Error mapping JSON to Map");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("IO Exception while reading JSON");
        }

        if (map.isEmpty()) {
            System.out.println("JSON Map is empty");
        } else {
            System.out.println("JSON Map: " + map);
        }

        return map;
    }

    public static String getAllList(String access_token) {
        HttpURLConnection urlconn = null;
        String returnresult = null;
        try {
            URL url = new URL("https://kapi.kakao.com/v1/api/talk/profile?access_token=" + access_token);
            urlconn = (HttpURLConnection) url.openConnection();
            urlconn.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
            urlconn.setDoOutput(true);
            urlconn.connect();

            // UTF-8로 데이터 읽기
            BufferedReader in = new BufferedReader(new InputStreamReader(urlconn.getInputStream(), "UTF-8"));
            StringBuffer sb = new StringBuffer();

            String result;

            while ((result = in.readLine()) != null) {
                sb.append(result).append("\n");
            }
            returnresult = sb.toString();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return returnresult;
    }
}
