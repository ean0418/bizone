package com.flex.bizone.map;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Setter
@Getter
public class InterestAreaData {
    private String bm_id;      // 회원 ID
    private String ba_code;    // 행정동 코드
    private String bb_code;    // 업종 코드
    private String ba_name;    // 행정동 이름
    private String bb_name;    // 업종 이름
    private Timestamp bia_date; // 찜한 날짜
    private int bia_rank_index;
    private float bs_success_probability;

    public InterestAreaData() {
    }

    public InterestAreaData(String bm_id, String ba_code, String bb_code, String ba_name, String bb_name, Timestamp bia_date, int bia_rank_index, float bs_success_probability) {
        this.bm_id = bm_id;
        this.ba_code = ba_code;
        this.bb_code = bb_code;
        this.ba_name = ba_name;
        this.bb_name = bb_name;
        this.bia_date = bia_date;
        this.bia_rank_index = bia_rank_index;
        this.bs_success_probability = bs_success_probability;
    }

}
