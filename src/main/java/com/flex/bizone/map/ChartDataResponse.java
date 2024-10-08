package com.flex.bizone.map;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ChartDataResponse {
    // Getter와 Setter 메서드
    private double avgMonthlySalesScore;
    private double totalWorkplacePopulationScore;
    private double attractionCountScore;
    private double totalExpenditureScore;
    private double avgRentFeeScore;
    private double otherScoresTotal;
    private double successProbability;
}
