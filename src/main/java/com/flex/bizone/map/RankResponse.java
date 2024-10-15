package com.flex.bizone.map;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RankResponse {
    private String ba_name;  // 지역명
    private double bs_success_probability;  // 총 점수

    public RankResponse() {
    }

    public RankResponse(String ba_name, double bs_success_probability) {
        this.ba_name = ba_name;
        this.bs_success_probability = bs_success_probability;
    }
}