Create table users2(
num NUMBER PRIMARY KEY, --회원 고유 번호
name VARCHAR2(20), -- 이름
password VARCHAR2(20), -- 비밀번호
branchLocation VARCHAR2(20), -- 지점 주소(ex) 역삼점)
myLocation VARCHAR2(20), -- 개인 주소
branchNum VARCHAR2(20) -- 지점 전화번호
phoneNum VARCHAR2(20), -- 개인 전화번호
grade VARCHAR2(20), --계급
profileImage VARCHAR2(100) -- 프로필 이미지
updatedAt DATE Default sysdate, -- 수정 날짜
registratedAt DATE -- 가입 날짜
);

create sequence users2_seq;

CREATE TABLE branches(
branch_id NUMBER PRIMARY KEY, -- 지점 고유 번호
name VARCHAR2(50), -- 지점 이름
address VARCHAR2(100), -- 지점 주소
phone VARCHAR2(20), -- 지점 연락처
manager_id NUMBER, -- 지점장 고유번호
status VARCHAR2(20), -- 운영 상태
memo VARCHAR2(200), -- 기타 특이사항
created_at DATE DEFAULT SYSDATE, -- 등록일
updated_at DATE DEFAULT SYSDATE, -- 수정일
CONSTRAINT branches_manager_fk FOREIGN KEY (manager_id) REFERENCES users2(num)
);

CREATE SEQUENCE branches_seq;