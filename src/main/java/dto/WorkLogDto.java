package dto;

import java.sql.Timestamp;
import java.util.Date;

public class WorkLogDto {

	public WorkLogDto(){
		
	}
	 private int logId;          // 출퇴근 기록 고유번호
	    private String branchId;    // 지점 ID
	    private String userId;      // 직원 ID
	    private Date workDate;      // 근무 날짜
	    private Timestamp startTime;// 출근 시간
	    private Timestamp endTime;  // 퇴근 시간
		public int getLogId() {
			return logId;
		}
		public void setLogId(int logId) {
			this.logId = logId;
		}
		public String getBranchId() {
			return branchId;
		}
		public void setBranchId(String branchId) {
			this.branchId = branchId;
		}
		public String getUserId() {
			return userId;
		}
		public void setUserId(String userId) {
			this.userId = userId;
		}
		public Date getWorkDate() {
			return workDate;
		}
		public void setWorkDate(Date workDate) {
			this.workDate = workDate;
		}
		public Timestamp getStartTime() {
			return startTime;
		}
		public void setStartTime(Timestamp startTime) {
			this.startTime = startTime;
		}
		public Timestamp getEndTime() {
			return endTime;
		}
		public void setEndTime(Timestamp endTime) {
			this.endTime = endTime;
		}
	
		

	}
