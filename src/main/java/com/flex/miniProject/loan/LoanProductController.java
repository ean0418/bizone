package com.flex.miniProject.loan;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
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
        String serviceKey = "YOUR_SERVICE_KEY";

        RestTemplate restTemplate = new RestTemplate();
        String url = apiUrl + "?serviceKey=" + serviceKey + "&IRT_CTG=" + irtCtg + "&USGE=" + usge
                + "&INST_CTG=" + instCtg + "&RSD_AREA_PAMT_EQLT_ISTM=" + rsdAreaPamtEqltIstm + "&TGT_FLTR=" + tgtFltr;

        String loanProducts = restTemplate.getForObject(url, String.class);

        model.addAttribute("loanProducts", loanProducts);
        return "loanProducts";  // JSP 파일 이름
    }
}

