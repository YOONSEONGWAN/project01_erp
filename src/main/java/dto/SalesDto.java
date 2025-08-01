package dto;

public class SalesDto {
	private int sales_id;         
	private int branch_id;      
	private String branch_name;   
	private String created_at;    
	private int totalamount;      


	private String period;              
	private int totalSales;             
	private int averageSales;           
	private String maxSalesDate;        
	private String minSalesDate;
	private int maxSalesAmount;        
	private int minSalesAmount;
	private int dayCount;               
	private int averageSalesPerDay;
	
	private int rank;

    private String topBranchName;
    private int topBranchSales;
	public int getSales_id() {
		return sales_id;
	}
	public void setSales_id(int sales_id) {
		this.sales_id = sales_id;
	}
	public int getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(int branch_id) {
		this.branch_id = branch_id;
	}
	public String getBranch_name() {
		return branch_name;
	}
	public void setBranch_name(String branch_name) {
		this.branch_name = branch_name;
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
	public String getMinSalesDate() {
		return minSalesDate;
	}
	public void setMinSalesDate(String minSalesDate) {
		this.minSalesDate = minSalesDate;
	}
	public int getMaxSalesAmount() {
		return maxSalesAmount;
	}
	public void setMaxSalesAmount(int maxSalesAmount) {
		this.maxSalesAmount = maxSalesAmount;
	}
	public int getMinSalesAmount() {
		return minSalesAmount;
	}
	public void setMinSalesAmount(int minSalesAmount) {
		this.minSalesAmount = minSalesAmount;
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
	public int getRank() {
		return rank;
	}
	public void setRank(int rank) {
		this.rank = rank;
	}
	public String getTopBranchName() {
		return topBranchName;
	}
	public void setTopBranchName(String topBranchName) {
		this.topBranchName = topBranchName;
	}
	public int getTopBranchSales() {
		return topBranchSales;
	}
	public void setTopBranchSales(int topBranchSales) {
		this.topBranchSales = topBranchSales;
	}
    
    
    
}