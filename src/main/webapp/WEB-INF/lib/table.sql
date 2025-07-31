CREATE TABLE branch_stock (
    branch_id        VARCHAR2(20)   NOT NULL,
    inventory_id     NUMBER         NOT NULL,
    product          VARCHAR2(100)  NOT NULL,
    current_quantity NUMBER         NOT NULL,
    updatedat        DATE           NULL,
    -- PK & FK 정의
    CONSTRAINT pk_branch_stock PRIMARY KEY (branch_id, inventory_id)
    -- branch_id, inventory_id 조합이 유일
);
CREATE SEQUENCE branch_stock_seq;

CREATE TABLE stock_request (
    order_id         NUMBER         NOT NULL PRIMARY KEY,
    branch_id        VARCHAR2(20)   NOT NULL,
    inventory_id     NUMBER         NOT NULL,
    product          VARCHAR2(100)  NOT NULL,
    current_quantity NUMBER         NOT NULL,
    request_quantity NUMBER         NOT NULL,
    status           VARCHAR2(20)   NULL,
    requestedat      DATE           NULL,
    updatedat        DATE           NULL,
    isPlaceOrder     VARCHAR2(10)   NULL,
    Field            VARCHAR2(1000) NULL,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (branch_id, inventory_id) REFERENCES branch_stock(branch_id, inventory_id)
);

CREATE SEQUENCE stock_request_seq;



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
password VARCHAR2(100), -- 비밀번호

branchLocation VARCHAR2(100), -- 지점 주소(ex) 역삼점)
myLocation VARCHAR2(100), -- 개인 주소
branchNum VARCHAR2(20), -- 지점 전화번호
phoneNum VARCHAR2(20), -- 개인 전화번호
grade VARCHAR2(20), --계급
profileImage VARCHAR2(100) -- 프로필 이미지-- 수정 날짜-- 가입 날짜
updatedAt DATE Default sysdate, 
registratedAt DATE 
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

CREATE TABLE work_log (
  log_id    NUMBER        NOT NULL PRIMARY KEY,
  branch_id VARCHAR2(20)  NOT NULL,        -- FK: branches.branch_id
  user_id   VARCHAR2(20)  NOT NULL,        -- FK: users_p.user_id
  work_date DATE          NOT NULL,
  start_time DATE         NOT NULL,
  end_time   DATE,                         -- VARCHAR2(100)보단 DATE 권장!
  -- FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  -- FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE SEQUENCE work_log_seq;