package dto;

public class SalesDto {
	private int sales_id;
	private String branch;
	private String created_at;
	private int totalamount;
	
	private String period;
	private int totalSales;
	
	private int averageSales;

	private String maxSalesDate;
	private int maxSalesAmount;
	
	private int dayCount;
	private int averageSalesPerDay;
	
	
	public int getSales_id() {
		return sales_id;
	}
	public void setSales_id(int sales_id) {
		this.sales_id = sales_id;
	}
	public String getBranch() {
		return branch;
	}
	public void setBranch(String branch) {
		this.branch = branch;
	}
	public String getCreated_at() {
		return created_at;
	}
	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
	public int getTotalamount() {
		return totalamount;
	}
	public void setTotalamount(int totalamount) {
		this.totalamount = totalamount;
	}
	public String getPeriod() {
		return period;
	}
	public void setPeriod(String period) {
		this.period = period;
	}
	public int getTotalSales() {
		return totalSales;
	}
	public void setTotalSales(int totalSales) {
		this.totalSales = totalSales;
	}
	public int getAverageSales() {
		return averageSales;
	}
	public void setAverageSales(int averageSales) {
		this.averageSales = averageSales;
	}
	public String getMaxSalesDate() {
		return maxSalesDate;
	}
	public void setMaxSalesDate(String maxSalesDate) {
		this.maxSalesDate = maxSalesDate;
	}
	public int getMaxSalesAmount() {
		return maxSalesAmount;
	}
	public void setMaxSalesAmount(int maxSalesAmount) {
		this.maxSalesAmount = maxSalesAmount;
	}
	public int getDayCount() {
		return dayCount;
	}
	public void setDayCount(int dayCount) {
		this.dayCount = dayCount;
	}
	public int getAverageSalesPerDay() {
		return averageSalesPerDay;
	}
	public void setAverageSalesPerDay(int averageSalesPerDay) {
		this.averageSalesPerDay = averageSalesPerDay;
	}
	
	
}
