package test.dto;

public class SalesDto {
    private int salesId;         // 매출 고유 번호
    private String branchId;     // 지점 아이디
    private String createdAt;    // 매출 발생일 (문자열 타입)
    private int totalAmount;     // 해당일 전체 매출
	
    
    public int getSalesId() {
		return salesId;
	}
	public void setSalesId(int salesId) {
		this.salesId = salesId;
	}
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
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