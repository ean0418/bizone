package com.flex.bizone.member;

import com.fasterxml.jackson.databind.JsonNode;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;
import com.fasterxml.jackson.core.JsonParseException;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.codec.Charsets;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;


import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
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

    @Autowired
    private SqlSession ss;

    @PostConstruct
    public void init() {
        // SqlSession이 초기화된 후 사용
        System.out.println("SqlSession is initialized: " + (ss != null));
    }

    public static String getCode() {
        String getcode = keyHost + "/oauth/authorize?response_type=code&client_id=" + RestApiKey;
        getcode += "&redirect_uri=" + Redirect_URL;
        getcode += "&response_type=code";
        return getcode;
    }

    public String getAccessToken(String authorize_code) {
        String accessToken = "";
        String refreshToken = "";
        String requestURL = "https://kauth.kakao.com/oauth/token";
        try {
            URL url = new URL(requestURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

            // POST 요청 파라미터 구성
            StringBuilder postData = new StringBuilder();
            postData.append("grant_type=authorization_code");
            postData.append("&client_id=").append(RestApiKey);
            postData.append("&redirect_uri=").append(Redirect_URL);
            postData.append("&code=").append(authorize_code);

            // OutputStream으로 데이터 전송
            OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());
            writer.write(postData.toString());
            writer.flush();

            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);
            System.out.println("Before try SqlSession is initialized: " + (ss != null));
            // 응답 코드가 200일 때만 성공적으로 토큰을 받음
            if (responseCode == 200) {
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String line;
                StringBuilder result = new StringBuilder();

                while ((line = br.readLine()) != null) {
                    result.append(line);
                }

                System.out.println("response body: " + result.toString());

                // JSON 파싱
                ObjectMapper mapper = new ObjectMapper();
                JsonNode jsonNode = mapper.readTree(result.toString());
                accessToken = jsonNode.get("access_token").asText();
                refreshToken = jsonNode.get("refresh_token").asText();

                System.out.println("access_token: " + accessToken);
                System.out.println("refresh_token: " + refreshToken);
            } else {
                System.out.println("Failed to get access token. Response code: " + responseCode);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        return accessToken;
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
            map = mapper.readValue(data.getBytes(StandardCharsets.UTF_8), new TypeReference<HashMap<String, String>>() {
            });
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


    public KakaoVO getUserInfo(String access_Token) {
        KakaoVO userInfo = new KakaoVO();
        String requestURL = "https://kapi.kakao.com/v2/user/me";

        try {
            // URL 연결 및 요청 설정
            URL url = new URL(requestURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + access_Token);

            int responseCode = conn.getResponseCode();
            System.out.println("responseCode: " + responseCode);

            if (responseCode == 200) {
                // 응답 본문 읽기
                BufferedReader buffer = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String line;
                StringBuilder result = new StringBuilder();
                while ((line = buffer.readLine()) != null) {
                    result.append(line);
                }

                System.out.println("response body: " + result.toString());

                // JSON 파싱
                JsonElement element = JsonParser.parseString(result.toString());
                JsonObject properties = element.getAsJsonObject().get("properties").getAsJsonObject();
                System.out.println("properties: " + properties);
                JsonObject kakaoAccount = element.getAsJsonObject().get("kakao_account").getAsJsonObject();
                JsonObject profile = kakaoAccount.get("profile").getAsJsonObject();

                // 필요한 정보 추출
                String bk_nickName = properties.has("nickname") ? properties.get("nickname").getAsString() : null;
                String bk_profile_image_url = properties.has("profile_image") ? properties.get("profile_image").getAsString() : null;
                String bk_id = element.getAsJsonObject().get("id").getAsString();
                System.out.println("nickname: " + bk_nickName);
                System.out.println("profile: " + bk_profile_image_url);
                if (bk_nickName == null || bk_profile_image_url == null) {
                    System.out.println("Failed to extract required user info from JSON response.");
                    return null; // 필요한 값이 없을 경우 null 반환
                }

                // 추출한 값을 Map에 저장
                userInfo.setBk_id(bk_id);
                userInfo.setBk_nickname(bk_nickName);
                userInfo.setBk_profile_image_url(bk_profile_image_url);
                Timestamp bk_created_at = new Timestamp(System.currentTimeMillis());
                userInfo.setBk_created_at(bk_created_at);
                System.out.println(userInfo);

            } else {
                System.out.println("Failed to get user info. Response code: " + responseCode);
                return null; // 200 응답이 아닌 경우 null 반환
            }

        } catch (IOException e) {
            e.printStackTrace();
            return null; // 예외 발생 시 null 반환
        }
        // 카카오 사용자 정보가 DB에 존재하는지 확인
        try {
            List<KakaoVO> result = ss.getMapper(KakaoMapper.class).findKakao(userInfo);
            if (ss == null) {
                System.out.println("MemberRepository is null");
            }
            System.out.println("User Info from DB: " + result);
            return result.get(0);
        } catch (IndexOutOfBoundsException e) {
            if (ss == null) {
                System.out.println("MemberRepository is null");
            }

//            e.printStackTrace();
            System.out.println("User Info: " + userInfo);
            try {
                ss.getMapper(KakaoMapper.class).kakaoInsert(userInfo);
                return ss.getMapper(KakaoMapper.class).findKakao(userInfo).get(0);
            } catch (IndexOutOfBoundsException iooe) {
//                iooe.printStackTrace();
            }
            return null;
        }


//        if (result == null) {
//            // 저장되지 않은 사용자 정보인 경우 DB에 저장
//; // 저장된 사용자 정보 반환
//        } else {
//            return result; // 기존 사용자 정보 반환
//        }
    }
}
