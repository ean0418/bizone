package com.flex.bizone.loan;

import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class LoanProductController {

    @GetMapping("/loan-products")
    public String getLoanProducts(
            @RequestParam(value = "IRT_CTG", required = false) String irtCtg,
            @RequestParam(value = "USGE", required = false) String usge,
            @RequestParam(value = "INST_CTG", required = false) String instCtg,
            @RequestParam(value = "RSD_AREA_PAMT_EQLT_ISTM", required = false) String rsdAreaPamtEqltIstm,
            @RequestParam(value = "TGT_FLTR", required = false) String tgtFltr,
            @RequestParam(value = "pageNo", defaultValue = "1") int pageNo,
            @RequestParam(value = "numOfRows", defaultValue = "10") int numOfRows,
            Model model, HttpServletRequest req) {

        // API 호출 URL 구성
        String apiUrl = "https://apis.data.go.kr/B553701/LoanProductSearchingInfo/LoanProductSearchingInfo/getLoanProductSearchingInfo";
        String serviceKey = "KXIrRVbtDNFBWxGmRv9lOsyI1M6sliCnAzV8GtqYLdn+kWmu0mtjpRtqWyRdKM27O/zbuY27RYOSXbgAtii7fw==";

        StringBuilder urlBuilder = new StringBuilder(apiUrl + "?serviceKey=" + serviceKey + "&pageNo=1&numOfRows=500");

        // 다중 선택된 값들을 ','로 구분해서 API에 전달
        if (irtCtg != null && !irtCtg.isEmpty()) urlBuilder.append("&IRT_CTG=").append(String.join(", ", irtCtg));
        if (usge != null && !usge.isEmpty()) urlBuilder.append("&USGE=").append(String.join(", ", usge));
        if (instCtg != null && !instCtg.isEmpty()) urlBuilder.append("&INST_CTG=").append(String.join(", ", instCtg));
        if (rsdAreaPamtEqltIstm != null && !rsdAreaPamtEqltIstm.isEmpty()) urlBuilder.append("&RSD_AREA_PAMT_EQLT_ISTM=").append(String.join(", ", rsdAreaPamtEqltIstm));
        if (tgtFltr != null && !tgtFltr.isEmpty()) urlBuilder.append("&TGT_FLTR=").append(String.join(", ", tgtFltr));
        // RestTemplate 생성 및 UTF-8 설정 추가
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));

        // API 호출 및 응답 받기
        ResponseEntity<String> response = restTemplate.getForEntity(urlBuilder.toString(), String.class);
        String xmlData = response.getBody();

        List<Map<String, String>> loanProducts = new ArrayList<>();

        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlData)));

            XPath xPath = XPathFactory.newInstance().newXPath();
            XPathExpression expr = xPath.compile("/response/body/items/item");

            // 여러 상품을 처리하기 위한 NodeList
            org.w3c.dom.NodeList itemList = (org.w3c.dom.NodeList) expr.evaluate(doc, javax.xml.xpath.XPathConstants.NODESET);

            for (int i = 0; i < itemList.getLength(); i++) {
                org.w3c.dom.Node itemNode = itemList.item(i);

                // 각 상품의 필드들을 추출
                String productName = xPath.evaluate("finprdnm", itemNode);
                String loanLimit = xPath.evaluate("lnlmt", itemNode);
                String interestRate = xPath.evaluate("irt", itemNode);
                String qualification = xPath.evaluate("suprtgtdtlcond", itemNode);

                // 각 상품 정보를 Map에 저장
                Map<String, String> productData = new HashMap<>();
                productData.put("productName", productName);
                productData.put("loanLimit", loanLimit);
                productData.put("interestRate", interestRate);
                productData.put("qualification", qualification);

                // 리스트에 추가
                loanProducts.add(productData);
            }

            // 디버깅을 위한 출력
            System.out.println("Parsed loan products: " + loanProducts);
            System.out.println(xmlData);


            // 총 데이터 수
            int totalCount = loanProducts.size(); // 총 데이터 1000개

            // 데이터가 없을 때 처리
            if (totalCount == 0) {
                model.addAttribute("noDataMessage", "조건에 해당하는 대출 상품이 없습니다.");
            }
            // 총 페이지 수 계산 (10개씩 보여줌)
            int totalPages = (int) Math.ceil((double) totalCount / numOfRows);

            // 현재 페이지에서 보여줄 데이터 범위 계산
            int startIndex = (pageNo - 1) * numOfRows;
            int endIndex = Math.min(startIndex + numOfRows, totalCount); // 끝 범위 계산

            // startIndex가 총 데이터 수를 넘지 않도록 검증
            if (startIndex >= totalCount) {
                startIndex = totalCount - numOfRows;
                startIndex = Math.max(startIndex, 0); // 음수 방지
            }

            // 현재 페이지에 해당하는 데이터만 잘라서 가져옴
            List<Map<String, String>> paginatedProducts = loanProducts.subList(startIndex, endIndex);

            // JSP로 전달할 값 설정
            model.addAttribute("loanProducts", paginatedProducts);
            model.addAttribute("currentPage", pageNo);
            model.addAttribute("numOfRows", numOfRows);
            model.addAttribute("totalPages", totalPages);


            model.addAttribute("irtCtg", irtCtg);
            model.addAttribute("usge", usge);
            model.addAttribute("instCtg", instCtg);
            model.addAttribute("rsdAreaPamtEqltIstm", rsdAreaPamtEqltIstm);
            model.addAttribute("tgtFltr", tgtFltr);

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", "데이터를 처리하는 중 오류가 발생했습니다.");
        }

        // contentPage를 설정하여 loanProducts.jsp를 메인 레이아웃에 포함
        model.addAttribute("contentPage", "loan/loanProducts.jsp");
        return "index";
    }
}
