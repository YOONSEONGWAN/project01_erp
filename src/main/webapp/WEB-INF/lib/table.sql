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
    user_id         VARCHAR2(20) PRIMARY KEY,  		-- 사용자 ID (실제 로그인용 ID)
    user_name       VARCHAR2(20),              		-- 이름 (사람 이름)
    password        VARCHAR2(100) NOT NULL,         -- 비밀번호
    branch_id       NUMBER,              			-- 지점 ID (FK로 사용)
    myLocation      VARCHAR2(100),             		-- 개인 주소
    phoneNum        VARCHAR2(20),              		-- 개인 전화번호
    grade           VARCHAR2(20) DEFAULT 'ROLE_USER' NOT NULL,  -- 계급 (ex: 본사, 지점장, 직원)
    profileImage    VARCHAR2(100),             		-- 프로필 이미지 경로
    updatedAt       DATE DEFAULT SYSDATE,     		-- 수정일
    registeredAt   DATE DEFAULT SYSDATE,            -- 가입일
    CONSTRAINT users2_branch_fk
        FOREIGN KEY (branch_id)
        REFERENCES branches (branch_id)
        ON DELETE CASCADE
);

CREATE TABLE branches (
    branch_id       NUMBER PRIMARY KEY,  -- 지점 ID
	branch_name     VARCHAR2(50),        -- 지점명
    branchLocation  VARCHAR2(100),       -- 지점 주소
    branchPhone     VARCHAR2(20)         -- 지점 전화번호
);

CREATE SEQUENCE branches_seq;
