package dto;

import java.sql.Date;

public class StockRequestDto {
	  private int orderId;            // 발주 고유번호 (PK)
	    private int branchNum;          // branch_stock PK (FK)
	    private String branchId;        // 지점 아이디
	    private int inventoryId;        // 식재료 고유번호
	    private String product;         // 식재료명
	    private int currentQuantity;    // 현재 재고
	    private int requestQuantity;    // 발주 요청 수량
	    private String status;          // 상태 (ex: 대기, 승인 등)
	    private Date requestedAt;       // 신청일
	    private Date updatedAt;         // 수정일
	    private String isPlaceOrder;    // 요청 상태 (승인/거절 등)
	    private String field;           // 비고/메모(필요시)

	    // 기본 생성자
	    public StockRequestDto() {}

		public int getOrderId() {
			return orderId;
		}

		public void setOrderId(int orderId) {
			this.orderId = orderId;
		}

		public int getBranchNum() {
			return branchNum;
		}

		public void setBranchNum(int branchNum) {
			this.branchNum = branchNum;
		}

		public String getBranchId() {
			return branchId;
		}

		public void setBranchId(String branchId) {
			this.branchId = branchId;
		}

		public int getInventoryId() {
			return inventoryId;
		}

		public void setInventoryId(int inventoryId) {
			this.inventoryId = inventoryId;
		}

		public String getProduct() {
			return product;
		}

		public void setProduct(String product) {
			this.product = product;
		}

		public int getCurrentQuantity() {
			return currentQuantity;
		}

		public void setCurrentQuantity(int currentQuantity) {
			this.currentQuantity = currentQuantity;
		}

		public int getRequestQuantity() {
			return requestQuantity;
		}

		public void setRequestQuantity(int requestQuantity) {
			this.requestQuantity = requestQuantity;
		}

		public String getStatus() {
			return status;
		}

		public void setStatus(String status) {
			this.status = status;
		}

		public Date getRequestedAt() {
			return requestedAt;
		}

		public void setRequestedAt(Date requestedAt) {
			this.requestedAt = requestedAt;
		}

		public Date getUpdatedAt() {
			return updatedAt;
		}

		public void setUpdatedAt(Date updatedAt) {
			this.updatedAt = updatedAt;
		}

		public String getIsPlaceOrder() {
			return isPlaceOrder;
		}

		public void setIsPlaceOrder(String isPlaceOrder) {
			this.isPlaceOrder = isPlaceOrder;
		}

		public String getField() {
			return field;
		}

		public void setField(String field) {
			this.field = field;
		}

		
	    
	    
	    
}
