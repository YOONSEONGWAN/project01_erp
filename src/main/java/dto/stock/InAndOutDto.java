package dto.stock;

public class InAndOutDto {
	private int orderId;         
    private int inventoryId;   
    private boolean isInOrder;
    private boolean isOutOrder;
    private String inApproval;
    private String outApproval;
    private String in_date;
    private String out_date;
    private String manager;
    
    
    
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public int getInventoryId() {
		return inventoryId;
	}
	public void setInventoryId(int inventoryId) {
		this.inventoryId = inventoryId;
	}
	public boolean isInOrder() {
		return isInOrder;
	}
	public void setInOrder(boolean isInOrder) {
		this.isInOrder = isInOrder;
	}
	public boolean isOutOrder() {
		return isOutOrder;
	}
	public void setOutOrder(boolean isOutorder) {
		this.isOutOrder = isOutorder;
	}
	
	public String getIn_date() {
		return in_date;
	}
	public void setIn_date(String in_date) {
		this.in_date = in_date;
	}
	public String getOut_date() {
		return out_date;
	}
	public void setOut_date(String out_date) {
		this.out_date = out_date;
	}
	public String getManager() {
		return manager;
	}
	public void setManager(String manager) {
		this.manager = manager;
	}
	public String getInApproval() {
		return inApproval;
	}
	public void setInApproval(String inApproval) {
		this.inApproval = inApproval;
	}
	public String getOutApproval() {
		return outApproval;
	}
	public void setOutApproval(String outApproval) {
		this.outApproval = outApproval;
	}
    
    
	
    
    
    
}
