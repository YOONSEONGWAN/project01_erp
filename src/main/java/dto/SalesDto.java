package dto;

public class SalesDto {
	private int sales_id;         // 매출 고유 ID
	private String branch_id;        // 지점 ID (외래키)
	private String branch_name;   // 지점 이름 (JOIN해서 얻은 값)
	private String created_at;    // 매출 발생 일자
	private int totalamount;      // 매출 총액

	// 통계용 필드들
	private String period;              // "2025-W30" 또는 "2025-07" 형태
	private int totalSales;             // 해당 기간의 총 매출
	private int averageSales;           // 평균 매출
	private String maxSalesDate;        // 최고 매출 발생일
	private String minSalesDate;
	private int maxSalesAmount;         // 최고 매출액
	private int minSalesAmount;
	private int dayCount;               // 해당 기간 날짜 수
	private int averageSalesPerDay;
	public int getSales_id() {
		return sales_id;
	}
	public void setSales_id(int sales_id) {
		this.sales_id = sales_id;
	}
	public String getBranch_id() {
		return branch_id;
	}
	public void setBranch_id(String branch_id) {
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
	
	
	
	
}
