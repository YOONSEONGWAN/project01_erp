package dto.stock;

public class PlaceOrderBranchDto {
	private int order_id;
	private String order_date;
	private String manager;
	
	public int getOrder_id() {
		return order_id;
	}
	public void setOrder_id(int order_id) {
		this.order_id = order_id;
	}
	public String getDate() {
		return order_date;
	}
	public void setDate(String order_date) {
		this.order_date = order_date;
	}
	public String getManager() {
		return manager;
	}
	public void setManager(String manager) {
		this.manager = manager;
	}
}
