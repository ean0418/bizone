package com.flex.miniProject.member;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class Kakao {
    // Rest api
    private static final String RestApiKey = "412e7727ffd0b8900060854044814879";

    private static final String Redirect_URL = "http://localhost/kakaologin";

    private static final String keyHost = "https://kauth.kakao.com";

    public static String getCode() {
        //https://kauth.kakao.com
        // /oauth/authorize?response_type=code&client_id=${REST_API_KEY}&redirect_uri=${REDIRECT_URI}
        String getcode = keyHost;
               getcode +=  "/oauth/authorize?response_type=code&client_id="+RestApiKey;
               getcode += "&redirect_uri="+Redirect_URL;
               getcode += "&response_type=code";
        return getcode;
    }
    public static String getAccessToken(String authorize_code) {
        String getAccesToken = "https://kauth.kakao.com/oauth/token?grant_type=authorization_code";
        getAccesToken += "&client_id="+RestApiKey;
        getAccesToken += "&redirect_uri="+Redirect_URL;
        getAccesToken += "&code=" +authorize_code;

        return getAccesToken;
    }

    public static String getHtml(String accestoken) {
        HttpURLConnection urlconn = null;
        String returnresult = null;
        try {
            URL url = new URL(accestoken);
            urlconn = (HttpURLConnection) url.openConnection();

            urlconn.setRequestProperty("Content-Type", "application/json;charset=URF-8");

            urlconn.setRequestMethod("POST");

            urlconn.setDoOutput(true);

            urlconn.connect();

            BufferedReader in = new BufferedReader(new InputStreamReader(urlconn.getInputStream(), "UTF-8"));

            StringBuffer sb = new StringBuffer();

            String result = null;

            while ((result=in.readLine()) != null) {
                sb.append(result);
                sb.append("\n");
            }
            returnresult = sb.toString();
        }catch (MalformedURLException e) {


            e.printStackTrace();
        } catch (IOException e) {

            e.printStackTrace();
        }

        return returnresult;
    }
    public static Map<String,String> JsonStringMap(String data) {
        Map<String,String> map = new HashMap<String, String>();

        ObjectMapper mapper = new ObjectMapper();

        try {
            // JSON 문자열을 Map으로 변환
            map = mapper.readValue(data, new TypeReference<HashMap<String,String>>() {

            });
        } catch (JsonParseException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return map;
    }
}
