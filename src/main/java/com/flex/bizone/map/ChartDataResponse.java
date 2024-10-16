package com.flex.bizone.map;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ChartDataResponse {
    private double avgMonthlySalesScore;
    private double totalWorkplacePopulationScore;
    private double attractionCountScore;
    private double totalExpenditureScore;
    private double avgRentFeeScore;
    private double otherScoresTotal;
    private double successProbability;
}
