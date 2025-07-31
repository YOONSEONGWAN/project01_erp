package dto;

public class IngredientDto {
	
	public IngredientDto() {}
	
	
	private int inventoryId;      // 식재료(재고) 고유번호
    private String product;       // 식재료명
    private int currentQuantity;  // 현재 재고 수량
    private String branchId;      // (필요시) 지점 아이디
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
	public String getBranchId() {
		return branchId;
	}
	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}
	    
	    
	
	    
	    
	    
	    
	    
	    
	    
}
