package com.flex.bizone.map;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RankResponse {
    private int rank_index; // 순위
    private String ba_name;  // 지역명
    private String ba_code; // 지역코드
    private double bs_success_probability;  // 총 점수

    public RankResponse() {

    }

    public RankResponse(int rank_index, String ba_name, String ba_code, double bs_success_probability) {
        this.rank_index = rank_index;
        this.ba_name = ba_name;
        this.ba_code = ba_code;
        this.bs_success_probability = bs_success_probability;
    }
}