CREATE TABLE sales (
sales_id NUMBER PRIMARY KEY,
branch VARCHAR2(20),
created_at DATE DEFAULT SYSDATE,
totalamount NUMBER
);

CREATE SEQUENCE sales_seq;

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

CREATE TABLE users2 (
    user_id        VARCHAR2(20) PRIMARY KEY,
    password       VARCHAR2(100) NOT NULL,
    user_name      VARCHAR2(50),
    myLocation     VARCHAR2(20),
    phoneNum       VARCHAR2(20),
    grade          VARCHAR2(20) DEFAULT 'ROLE_USER',
    profileImage   VARCHAR2(100),
    registeredAt   DATE DEFAULT SYSDATE NOT NULL,
    updatedAt      DATE DEFAULT SYSDATE NOT NULL,
    branch_id      NUMBER NOT NULL,

    -- FK 제약조건 명시
    CONSTRAINT fk_users2_branch
      FOREIGN KEY (branch_id)
      REFERENCES branches(branch_id)
);

create sequence users2_seq;

CREATE TABLE branches(
branch_id NUMBER PRIMARY KEY, -- 지점 고유 번호
name VARCHAR2(50), -- 지점명
address VARCHAR2(100), -- 지점 주소

);

CREATE SEQUENCE branches_seq;