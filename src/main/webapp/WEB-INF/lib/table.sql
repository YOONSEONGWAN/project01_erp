CREATE TABLE Inventory (
	num NUMBER PRIMARY KEY,
    inventory_id NUMBER NOT NULL, -- 본사창고:1, 지점 창고: 2,3,...
    product VARCHAR2(100) NOT NULL, --닭, 기름, 양념, 콜라, 감자튀김 
    quantity NUMBER NOT NULL, -- 품목별 수량
    expirationDate DATE NOT NULL, -- 유통기한
    isDisposal VARCHAR2(10) DEFAULT 'NO', --폐기 여부
    isPlaceOrder VARCHAR2(10) DEFAULT 'NO',
    is_approval VARCHAR2(20) DEFAULT '대기'
);

CREATE SEQUENCE inventory_seq;

CREATE TABLE inandout (
    order_id NUMBER PRIMARY KEY,          -- 주문 고유 ID
    inventory_id NUMBER NOT NULL,         -- 재고위치 ID
    is_in_order VARCHAR2(10),             -- 입고 여부 ('YES'/'NO' 등)
    is_out_order VARCHAR2(10),            -- 출고 여부 ('YES'/'NO' 등)
    in_Approval VARCHAR2(10),             -- 승인 상태 ('대기', '승인', '반려' 등)
    out_Approval Varchar2(10),
    in_date DATE,                         -- 입고 날짜
    out_date DATE,                        -- 출고 날짜
    manager VARCHAR2(100)                 -- 담당자
);


CREATE SEQUENCE inandout_seq;

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