package test.dto;

public class BranchSalesSummaryDto {
    private String branch;         // 지점 ID (지점별 요약용)
    private String branchName;     // 지점명 (지점별 요약용)
    private String salesDate;      // 날짜 (일자별 요약용)
    private int totalAmount;       // 매출 합계

    public String getBranch() {
        return branch;
    }
    public void setBranch(String branch) {
        this.branch = branch;
    }

    public String getBranchName() {
        return branchName;
    }
    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getSalesDate() {
        return salesDate;
    }
    public void setSalesDate(String salesDate) {
        this.salesDate = salesDate;
    }

    public int getTotalAmount() {
        return totalAmount;
    }
    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }
}