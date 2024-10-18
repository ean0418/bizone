package com.flex.bizone.loan;

import lombok.Getter;
import lombok.Setter;

import java.security.Timestamp;

@Getter
@Setter
public class Bizone_favorites {
    private int bf_id;                 // 자동 증가 ID
    private String bf_bm_id;           // 회원 ID
    private String bf_product_name;    // 대출상품 이름
    private String bf_loan_limit;      // 대출 한도
    private String bf_interest_rate;   // 이자율
    private String bf_qualification;   // 자격 요건
    private Timestamp bf_created_date; // 찜한 날짜

    public Bizone_favorites() {
        // 기본 생성자
    }

    public Bizone_favorites(String bf_bm_id, String bf_product_name, String bf_loan_limit,
                            String bf_interest_rate, String bf_qualification) {
        this.bf_bm_id = bf_bm_id;
        this.bf_product_name = bf_product_name;
        this.bf_loan_limit = bf_loan_limit;
        this.bf_interest_rate = bf_interest_rate;
        this.bf_qualification = bf_qualification;
    }
}
