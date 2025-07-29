package test.dto;

public class SalesDto {
    private int salesId;
    private String branch;
    private String createdAt; // 문자열로 처리
    private int totalAmount;

    public SalesDto() {
    }

    public SalesDto(int salesId, String branch, String createdAt, int totalAmount) {
        this.salesId = salesId;
        this.branch = branch;
        this.createdAt = createdAt;
        this.totalAmount = totalAmount;
    }

    public int getSalesId() {
        return salesId;
    }

    public void setSalesId(int salesId) {
        this.salesId = salesId;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }
}
