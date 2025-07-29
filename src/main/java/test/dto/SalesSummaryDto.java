package test.dto;

public class SalesSummaryDto {
    private String branch;
    private int totalAmount;

    public SalesSummaryDto() {
    }

    public SalesSummaryDto(String branch, int totalAmount) {
        this.branch = branch;
        this.totalAmount = totalAmount;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }
}
