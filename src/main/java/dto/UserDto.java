package dto;

public class UserDto {               
	private String userId;
	private String password;
	private String userName;
	private String myLocation;
	private String phoneNum;
	private String grade;
	private String profileImage;
	private String registeredAt;
	private String updatedAt;
	
	//setter, getter
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
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
	public String getRegisteredAt() {
		return registeredAt;
	}
	public void setRegisteredAt(String registeredAt) {
		this.registeredAt = registeredAt;
	}
	public String getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(String updatedAt) {
		this.updatedAt = updatedAt;
	}


}
