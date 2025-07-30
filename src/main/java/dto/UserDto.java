package dto;

public class UserDto {
	private String userId;
	private String userName;
	private String password;
	private String branchId;
	private String myLocation;
	private String phoneNum;
	private String grade;
	private String profileImage;
	private String updatedAt;
	private String registratedAt;

	// getter, setter
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getBranchId() {
		return branchId;
	}

	public void setBranchId(String branchId) {
		this.branchId = branchId;
	}

	public String getMyLocation() {
		return myLocation;
	}

	public void setMyLocation(String myLocation) {
		this.myLocation = myLocation;
	}

	public String getPhoneNum() {
		return phoneNum;
	}

	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}

	public String getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(String updatedAt) {
		this.updatedAt = updatedAt;
	}

	public String getRegistratedAt() {
		return registratedAt;
	}

	public void setRegistratedAt(String registratedAt) {
		this.registratedAt = registratedAt;
	}

}
