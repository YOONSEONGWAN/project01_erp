
CREATE TABLE placeOrder_branch (
    order_id NUMBER PRIMARY KEY,
    order_date DATE DEFAULT SYSDATE,
    manager VARCHAR2(20)
);

CREATE TABLE placeOrder_branch_detail (
    detail_id NUMBER PRIMARY KEY,
    order_id NUMBER,
    product VARCHAR2(100) NOT NULL,
    current_quantity NUMBER NOT NULL,
    request_quantity NUMBER NOT NULL,
    approval_status VARCHAR2(10),
    manager VARCHAR2(20)
);

CREATE TABLE placeOrder_head (
    order_id NUMBER PRIMARY KEY,
    order_date DATE DEFAULT SYSDATE,
    manager VARCHAR2(20)
);

CREATE SEQUENCE placeOrder_head_seq;

CREATE TABLE placeOrder_head_detail (
    detail_id NUMBER PRIMARY KEY,
   	order_id NUMBER,
    product VARCHAR2(100) NOT NULL,
    current_quantity NUMBER NOT NULL,
    request_quantity NUMBER NOT NULL,
    approval_status VARCHAR2(10), --승인 OR 반려
    manager VARCHAR2(20)
);

CREATE TABLE placeOrder (
    num NUMBER PRIMARY KEY,                      -- 고유 번호 (PK)
    product VARCHAR2(100) NOT NULL,              -- 상품명
    current_quantity NUMBER NOT NULL,            -- 현재 수량
    expiration_date DATE,                        -- 유통기한
    request_quantity NUMBER NOT NULL,            -- 신청 수량 
    approval_status VARCHAR2(10) DEFAULT '대기'  -- 승인 상태: 대기 / 승인 / 반려
);

CREATE TABLE hqBoard (
    num NUMBER PRIMARY KEY,         -- 글 번호
    writer VARCHAR2(100) NOT NULL,  -- 작성자
    title VARCHAR2(200) NOT NULL,   -- 글 제목
    content VARCHAR2(4000) NOT NULL,-- 글 내용
    viewCount NUMBER DEFAULT 0 NOT NULL,      -- 조회수
    createdAt VARCHAR2(50) DEFAULT SYSDATE NOT NULL -- 작성일자 (문자열로 저장)
);

CREATE SEQUENCE hqboard_seq; -- 본사 게시판 시퀀스

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

/*CREATE TABLE inandout (
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

CREATE SEQUENCE inandout_seq;*/

CREATE TABLE inbound_orders (
    in_order_id   NUMBER PRIMARY KEY,     -- 입고 고유 ID
    inventory_id  NUMBER NOT NULL,        -- 입고 위치 ID
    approval      VARCHAR2(10),           -- 승인 상태 ('대기', '승인', '반려' 등)
    in_date       DATE,                   -- 입고 날짜
    manager       VARCHAR2(100)           -- 담당자
);

create sequence inbound_seq;

CREATE TABLE outbound_orders (
    out_order_id  NUMBER PRIMARY KEY,     -- 출고 고유 ID
    inventory_id  NUMBER NOT NULL,        -- 출고 위치 ID
    approval      VARCHAR2(10),           -- 승인 상태 ('대기', '승인', '반려' 등)
    out_date      DATE,                   -- 출고 날짜
    manager       VARCHAR2(100)           -- 담당자
);

create sequence outbound_sequence;


CREATE TABLE users_p (
    num         NUMBER         NOT NULL,
    branch_id   VARCHAR2(20)   NOT NULL,
    user_id     VARCHAR2(20)   NOT NULL UNIQUE,
    password    VARCHAR2(100)  NOT NULL,
    user_name   VARCHAR2(20)   NOT NULL,
    location    VARCHAR2(100),
    phone       VARCHAR2(50),
    role        VARCHAR2(10),
    updated_at  DATE,
    created_at  DATE,
    CONSTRAINT pk_users_p PRIMARY KEY (num),
    CONSTRAINT fk_users_p_branch FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
        ON DELETE CASCADE
);

CREATE TABLE branches (
    num         NUMBER         PRIMARY KEY, 	-- 지점 고유 번호
    branch_id   VARCHAR2(20)   NOT NULL UNIQUE, -- 지점 아이디
    name        VARCHAR2(50)   NOT NULL, 		-- 지점 이름
    address     VARCHAR2(100)  NOT NULL,		-- 지점 주소
    phone       VARCHAR2(20)   NOT NULL, 		-- 지점 연락처
    created_at  DATE           NOT NULL, -- 등록일
    updated_at  DATE 							-- 수정일
);

CREATE SEQUENCE branches_seq;

CREATE TABLE work_log (
    id NUMBER PRIMARY KEY,                     -- 출퇴근 기록 고유번호
    user_id VARCHAR2(20),                      -- users2.user_id 참조
    work_date DATE DEFAULT SYSDATE NOT NULL,   -- 근무 날짜
    start_time DATE,                           -- 출근 시간
    end_time DATE,                             -- 퇴근 시간
    FOREIGN KEY (user_id) REFERENCES users2(user_id)
);

CREATE SEQUENCE work_log_seq;

