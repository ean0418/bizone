package com.flex.bizone.map;

public class ChartDataResponse {
    private int avgMonthlySalesScore;
    private int totalWorkplacePopulationScore;
    private int attractionCountScore;
    private int totalExpenditureScore;
    private int avgRentFeeScore;
    private int otherScoresTotal;
    private int successProbability;

    // Getter와 Setter 메서드
    public int getAvgMonthlySalesScore() {
        return avgMonthlySalesScore;
    }

    public void setAvgMonthlySalesScore(int avgMonthlySalesScore) {
        this.avgMonthlySalesScore = avgMonthlySalesScore;
    }

    public int getTotalWorkplacePopulationScore() {
        return totalWorkplacePopulationScore;
    }

    public void setTotalWorkplacePopulationScore(int totalWorkplacePopulationScore) {
        this.totalWorkplacePopulationScore = totalWorkplacePopulationScore;
    }

    public int getAttractionCountScore() {
        return attractionCountScore;
    }

    public void setAttractionCountScore(int attractionCountScore) {
        this.attractionCountScore = attractionCountScore;
    }

    public int getTotalExpenditureScore() {
        return totalExpenditureScore;
    }

    public void setTotalExpenditureScore(int totalExpenditureScore) {
        this.totalExpenditureScore = totalExpenditureScore;
    }

    public int getAvgRentFeeScore() {
        return avgRentFeeScore;
    }

    public void setAvgRentFeeScore(int avgRentFeeScore) {
        this.avgRentFeeScore = avgRentFeeScore;
    }

    public int getOtherScoresTotal() {
        return otherScoresTotal;
    }

    public void setOtherScoresTotal(int otherScoresTotal) {
        this.otherScoresTotal = otherScoresTotal;
    }

    public int getSuccessProbability() {
        return successProbability;
    }

    public void setSuccessProbability(int successProbability) {
        this.successProbability = successProbability;
    }
}
