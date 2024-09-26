package com.flex.miniProject.loan;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.StringReader;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathExpression;
import org.xml.sax.InputSource;

@Controller
public class LoanProductController {
    @GetMapping("/loan-products")
    public String getLoanProducts(
            @RequestParam(value = "IRT_CTG", required = false) String irtCtg,
            @RequestParam(value = "USGE", required = false) String usge,
            @RequestParam(value = "INST_CTG", required = false) String instCtg,
            @RequestParam(value = "RSD_AREA_PAMT_EQLT_ISTM", required = false) String rsdAreaPamtEqltIstm,
            @RequestParam(value = "TGT_FLTR", required = false) String tgtFltr,
            Model model) {

        String apiUrl = "http://apis.data.go.kr/B553701/LoanProductSearchingInfo/LoanProductSearchingInfo/getLoanProductSearchingInfo";
        String serviceKey = "KXIrRVbtDNFBWxGmRv9lOsyI1M6sliCnAzV8GtqYLdn+kWmu0mtjpRtqWyRdKM27O/zbuY27RYOSXbgAtii7fw==";

        StringBuilder urlBuilder = new StringBuilder(apiUrl + "?serviceKey=" + serviceKey);
        if (irtCtg != null && !irtCtg.isEmpty()) urlBuilder.append("&IRT_CTG=").append(irtCtg);
        if (usge != null && !usge.isEmpty()) urlBuilder.append("&USGE=").append(usge);
        if (instCtg != null && !instCtg.isEmpty()) urlBuilder.append("&INST_CTG=").append(instCtg);
        if (rsdAreaPamtEqltIstm != null && !rsdAreaPamtEqltIstm.isEmpty()) urlBuilder.append("&RSD_AREA_PAMT_EQLT_ISTM=").append(rsdAreaPamtEqltIstm);
        if (tgtFltr != null && !tgtFltr.isEmpty()) urlBuilder.append("&TGT_FLTR=").append(tgtFltr);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(urlBuilder.toString(), String.class);

        // XML 파싱
        String xmlData = response.getBody();
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlData)));
            XPath xPath = XPathFactory.newInstance().newXPath();

            // 필요한 값들을 XPath로 추출
            XPathExpression productNameExpr = xPath.compile("/response/body/items/item/finprdnm");
            XPathExpression loanLimitExpr = xPath.compile("/response/body/items/item/lnlmt");
            XPathExpression interestRateExpr = xPath.compile("/response/body/items/item/irt");
            XPathExpression qualificationExpr = xPath.compile("/response/body/items/item/suprtgtdtlcond");

            String productName = productNameExpr.evaluate(doc);
            String loanLimit = loanLimitExpr.evaluate(doc);
            String interestRate = interestRateExpr.evaluate(doc);
            String qualification = qualificationExpr.evaluate(doc);

            // JSP에 전달할 데이터 추가
            model.addAttribute("productName", productName);
            model.addAttribute("loanLimit", loanLimit);
            model.addAttribute("interestRate", interestRate);
            model.addAttribute("qualification", qualification);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "loan/loanProducts";  // JSP 파일 경로
    }
}
