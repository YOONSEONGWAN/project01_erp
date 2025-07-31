package dto;

import java.util.Date;

public class IngredientDto {
	
	public IngredientDto() {}
	
	
	  private int branchNum;           // branch_stock 테이블 PK (고유번호)
	    private String branchId;         // 지점 ID (FK)
	    private int inventoryId;         // 식재료(재고) 고유번호 (FK)
	    private String product;          // 식재료명
	    private int currentQuantity;     // 현재 재고 수량
	    private Date updatedAt;          // 마지막 추가 날짜
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
		public Date getUpdatedAt() {
			return updatedAt;
		}
		public void setUpdatedAt(Date updatedAt) {
			this.updatedAt = updatedAt;
		}
	
	    
	    
	    
	    
	    
	    
}
