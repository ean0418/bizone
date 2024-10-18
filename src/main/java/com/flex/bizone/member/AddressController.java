package com.flex.bizone.member;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class AddressController {

    private final String apiUrl = "https://www.juso.go.kr/addrlink/addrLinkApi.do";
    private final String apiKey = "devU01TX0FVVEgyMDI0MTAxNzExMDc1ODExNTE2NDY=";  // 발급받은 API 키

    @GetMapping("/searchAddress")
    public ResponseEntity<String> searchAddress(@RequestParam String keyword) {
        RestTemplate restTemplate = new RestTemplate();
        String requestUrl = apiUrl + "?confmKey=" + apiKey + "&currentPage=1&countPerPage=10&keyword=" + keyword + "&resultType=json";

        ResponseEntity<String> response = restTemplate.getForEntity(requestUrl, String.class);

        if (response.getStatusCode() == HttpStatus.OK) {
            return response;
        } else {
            return new ResponseEntity<>("API 요청에 실패했습니다.", HttpStatus.BAD_REQUEST);
        }
    }
}

