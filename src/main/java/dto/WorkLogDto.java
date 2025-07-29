package dto;

import java.sql.Timestamp;
import java.util.Date;

public class WorkLogDto {

	   private int logId;
	    private int userNum;
	    private Timestamp checkInTime;
	    private Timestamp checkOutTime;
	    private Date workDate;
	    
	    
	    
	    
		public int getLogId() {
			return logId;
		}
		public void setLogId(int logId) {
			this.logId = logId;
		}
		public int getUserNum() {
			return userNum;
		}
		public void setUserNum(int userNum) {
			this.userNum = userNum;
		}
		public Timestamp getCheckInTime() {
			return checkInTime;
		}
		public void setCheckInTime(Timestamp checkInTime) {
			this.checkInTime = checkInTime;
		}
		public Timestamp getCheckOutTime() {
			return checkOutTime;
		}
		public void setCheckOutTime(Timestamp checkOutTime) {
			this.checkOutTime = checkOutTime;
		}
		public Date getWorkDate() {
			return workDate;
		}
		public void setWorkDate(Date workDate) {
			this.workDate = workDate;
		}
	    
	    
	    
	    
	    
}
