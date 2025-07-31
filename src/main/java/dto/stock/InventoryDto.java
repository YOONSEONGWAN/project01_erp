package dto.stock;

public class InventoryDto {
	private int num;
	private int branch_id;
    private String product;
    private int quantity;
    private boolean isDisposal;
    private boolean isPlaceOrder;
    private String isApproval;
    
    
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(int branch_id) {
		this.branch_id = branch_id;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public boolean isDisposal() {
		return isDisposal;
	}
	public void setDisposal(boolean isDisposal) {
		this.isDisposal = isDisposal;
	}
	public boolean isPlaceOrder() {
		return isPlaceOrder;
	}
	public void setPlaceOrder(boolean isPlaceOrder) {
		this.isPlaceOrder = isPlaceOrder;
	}
	public String getIsApproval() {
		return isApproval;
	}
	public void setIsApproval(String isApproval) {
		this.isApproval = isApproval;
	}
   
    
    
    
    
	
	
	
	
    
   
    
    
}
