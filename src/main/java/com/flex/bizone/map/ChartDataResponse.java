package com.flex.bizone.map;

public class ChartDataResponse {
    private double avgMonthlySalesScore;
    private double totalWorkplacePopulationScore;
    private double attractionCountScore;
    private double totalExpenditureScore;
    private double avgRentFeeScore;
    private double otherScoresTotal;
    private double successProbability;

    // Getter와 Setter 메서드
    public double getAvgMonthlySalesScore() {
        return avgMonthlySalesScore;
    }

    public void setAvgMonthlySalesScore(double avgMonthlySalesScore) {
        this.avgMonthlySalesScore = avgMonthlySalesScore;
    }

    public double getTotalWorkplacePopulationScore() {
        return totalWorkplacePopulationScore;
    }

    public void setTotalWorkplacePopulationScore(double totalWorkplacePopulationScore) {
        this.totalWorkplacePopulationScore = totalWorkplacePopulationScore;
    }

    public double getAttractionCountScore() {
        return attractionCountScore;
    }

    public void setAttractionCountScore(double attractionCountScore) {
        this.attractionCountScore = attractionCountScore;
    }

    public double getTotalExpenditureScore() {
        return totalExpenditureScore;
    }

    public void setTotalExpenditureScore(double totalExpenditureScore) {
        this.totalExpenditureScore = totalExpenditureScore;
    }

    public double getAvgRentFeeScore() {
        return avgRentFeeScore;
    }

    public void setAvgRentFeeScore(double avgRentFeeScore) {
        this.avgRentFeeScore = avgRentFeeScore;
    }

    public double getOtherScoresTotal() {
        return otherScoresTotal;
    }

    public void setOtherScoresTotal(double otherScoresTotal) {
        this.otherScoresTotal = otherScoresTotal;
    }

    public double getSuccessProbability() {
        return successProbability;
    }

    public void setSuccessProbability(double successProbability) {
        this.successProbability = successProbability;
    }
}
