package dto.stock;

public class InventoryDto {
	private int num;
	private int inventory_id;
    private String product;
    private int quantity;
    private String expirationDate;
    private boolean isDisposal;
    private boolean isPlaceOrder;
    private String isApproval;
   
    
    
    
    
	
	public String getIsApproval() {
		return isApproval;
	}
	public void setIsApproval(String isApproval) {
		this.isApproval = isApproval;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public int getInventory_id() {
		return inventory_id;
	}
	public void setInventory_id(int inventory_id) {
		this.inventory_id = inventory_id;
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
	public String getExpirationDate() {
		return expirationDate;
	}
	public void setExpirationDate(String expirationDate) {
		this.expirationDate = expirationDate;
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
	
	
    
   
    
    
}
