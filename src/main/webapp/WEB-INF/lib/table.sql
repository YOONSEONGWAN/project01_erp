
-- 1. users_p (부모: FK 참조 대상 없음)
CREATE TABLE users_p (
  num           NUMBER          NOT NULL,
  branch_id     VARCHAR2(20)  UNIQUE  NOT NULL, -- PK 해제하고 branches table의 branch_id 참조해야함
  user_id       VARCHAR2(20) UNIQUE   NOT NULL,
  password      VARCHAR2(100)   NOT NULL,
  user_name     VARCHAR2(20)    NOT NULL,
  location      VARCHAR2(100),
  phone         VARCHAR2(50),
  profile_image VARCHAR2(255),
  role          VARCHAR2(10),
  updated_at    DATE,
  created_at    DATE,
  CONSTRAINT PK_USERS_P PRIMARY KEY (num),
  CONSTRAINT fk_users_p_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 2. branches (부모: users_p)
CREATE TABLE branches (
  num        NUMBER        NOT NULL,
  branch_id  VARCHAR2(20)  NOT NULL UNIQUE,
  name       VARCHAR2(50)  NOT NULL,
  address    VARCHAR2(100) NOT NULL,
  phone      VARCHAR2(20)  NOT NULL,
  status     VARCHAR2(20)  DEFAULT '운영중',
  created_at DATE          DEFAULT SYSDATE,
  updated_at DATE,
  CONSTRAINT PK_BRANCHES      PRIMARY KEY (num),
);

-- 3. Inventory (부모: 없음 or 나중에 stock_request 에서 참조)
CREATE TABLE Inventory (
  num 		NUMBER        NOT NULL,
  branch_id    NUMBER        NOT NULL,
  product      VARCHAR2(100) NOT NULL,
  quantity     NUMBER        NOT NULL,
  isDisposal   VARCHAR2(10)  DEFAULT 'NO',
  isPlaceOrder VARCHAR2(10)  DEFAULT 'NO',
  is_approval  VARCHAR2(20)  DEFAULT '대기',
  CONSTRAINT PK_INVENTORY PRIMARY KEY (num)
);

-- 4. stock_request (부모: branches, Inventory)
CREATE TABLE stock_request (
  order_id         NUMBER        NOT NULL,
  branch_id        VARCHAR2(20)  NOT NULL,
  branch_num	   NUMBER		 NOT NULL,
  inventory_id     NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  status           VARCHAR2(20),
  requestedat      DATE,
  updatedat        DATE,
  request_status   VARCHAR2(10),
  CONSTRAINT PK_STOCK_REQUEST PRIMARY KEY (order_id),
  CONSTRAINT FK_SR_BRANCH     FOREIGN KEY (branch_id)    REFERENCES branches(branch_id),
  CONSTRAINT fk_SR_branch_num FOREIGN KEY (branch_num)   REFERENCES branch_stock(branch_num),
  CONSTRAINT FK_SR_INVENTORY  FOREIGN KEY (inventory_id) REFERENCES Inventory(num)
);

-- 5. placeOrder_head (부모: Inventory)
CREATE TABLE placeOrder_head (
  order_id      NUMBER        NOT NULL,
  inventory_num NUMBER        NOT NULL,
  order_date    DATE,
  manager       VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_HEAD           PRIMARY KEY (order_id),
  CONSTRAINT FK_PLACEORDER_HEAD_INVENTORY FOREIGN KEY (inventory_num) REFERENCES Inventory(num)
);

-- 6. placeOrder_head_detail (부모: placeOrder_head)
CREATE TABLE placeOrder_head_detail (
  detail_id        NUMBER        NOT NULL,
  order_id         NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  approval_status  VARCHAR2(10),
  manager          VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_HEAD_DETAIL PRIMARY KEY (detail_id, order_id),
  CONSTRAINT FK_PHD_PLACEORDER_HEAD    FOREIGN KEY (order_id) REFERENCES placeOrder_head(order_id)
);

-- 7. placeOrder_branch (부모: stock_request)
CREATE TABLE placeOrder_branch (
  order_id  NUMBER        NOT NULL,
  order_date DATE,
  manager   VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_BRANCH               PRIMARY KEY (order_id),
  CONSTRAINT FK_PO_BRANCH_STOCK_REQ FOREIGN KEY (order_id) REFERENCES stock_request(order_id)
);

-- 8. placeOrder_branch_detail (부모: stock_request)
CREATE TABLE placeOrder_branch_detail (
  detail_id        NUMBER        NOT NULL,
  order_id         NUMBER        NOT NULL,
  branch_id        VARCHAR2(20)  NOT NULL,
  inventory_id     NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  approval_status  VARCHAR2(10),
  manager          VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_BRANCH_DETAIL PRIMARY KEY (detail_id),
  CONSTRAINT FK_POBD_ORDER             FOREIGN KEY (order_id)     REFERENCES stock_request(order_id),
  CONSTRAINT FK_POBD_BRANCH            FOREIGN KEY (branch_id)    REFERENCES branches(branch_id),
  CONSTRAINT FK_POBD_INVENTORY         FOREIGN KEY (inventory_id) REFERENCES inventory(num)
);

-- 9. inbound_orders (부모: branches)
CREATE TABLE inbound_orders (
  order_id  NUMBER        NOT NULL,
  branch_id NUMBER        NOT NULL,
  approval  VARCHAR2(10),
  in_date   DATE,
  manager   VARCHAR2(100),
  CONSTRAINT PK_INBOUND_ORDERS        PRIMARY KEY (order_id)
);

-- 10. outbound_orders (부모: branches)
CREATE TABLE outbound_orders (
  order_id  NUMBER        NOT NULL,
  branch_id VARCHAR2(20)        NOT NULL,
  approval  VARCHAR2(10),
  out_date  DATE,
  manager   VARCHAR2(100),
  CONSTRAINT PK_OUTBOUND_ORDERS        PRIMARY KEY (order_id),
  CONSTRAINT FK_OUTBOUND_ORDERS_BRANCH FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 11. work_log (부모: branches, users_p)
CREATE TABLE work_log (
  log_id     NUMBER        NOT NULL,
  branch_id  VARCHAR2(20)  NOT NULL,
  user_id    VARCHAR2(20)  NOT NULL,
  work_date  DATE          NOT NULL,
  start_time DATE          NOT NULL,
  end_time   DATE          NOT NULL,
  CONSTRAINT PK_WORK_LOG            PRIMARY KEY (log_id),
  CONSTRAINT FK_WORK_LOG_BRANCH     FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CONSTRAINT FK_WORK_LOG_USER       FOREIGN KEY (user_id)   REFERENCES users_p(user_id)
);

-- 12. sales (부모: branches)
CREATE TABLE sales (
  sales_id    NUMBER        NOT NULL,
  branch_id   VARCHAR2(20)  NOT NULL,
  created_at  DATE          DEFAULT SYSDATE NOT NULL,
  totalamount NUMBER,
  CONSTRAINT PK_SALES           PRIMARY KEY (sales_id),
  CONSTRAINT FK_SALES_BRANCH    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 13. board_p (부모: users_p)
CREATE TABLE board_p (
  num             NUMBER        NOT NULL,
  branch_id       VARCHAR2(20)  NOT NULL,
  user_id         VARCHAR2(20)  NOT NULL,
  title           VARCHAR2(100) NOT NULL,
  content         CLOB          NOT NULL,
  writer          VARCHAR2(20)  NOT NULL,
  view_count      NUMBER        NOT NULL,
  created_at      VARCHAR2(30)  NOT NULL,
  board_type      VARCHAR2(20)  NOT NULL,
  parent_num      NUMBER,
  target_user_id  VARCHAR2(20),
  CONSTRAINT PK_BOARD_P             PRIMARY KEY (num, branch_id),
  CONSTRAINT FK_BOARD_P_BRANCH      FOREIGN KEY (branch_id)   REFERENCES users_p(branch_id), -- branches table 의 branch_id를 참조해야함
  CONSTRAINT FK_BOARD_P_USER        FOREIGN KEY (user_id)     REFERENCES users_p(user_id)
);

-- 14. product (부모: 없음)
CREATE TABLE product (
  num         NUMBER        NOT NULL,
  name        VARCHAR2(100) NOT NULL,
  description VARCHAR2(1000),
  price       NUMBER        NOT NULL,
  status      VARCHAR2(20),
  imagepath   VARCHAR2(255),
  CONSTRAINT PK_PRODUCT PRIMARY KEY (num)
);

-- 15. hqboard (부모: 없음)
CREATE TABLE hqboard (
  num         NUMBER        NOT NULL,
  writer      VARCHAR2(20)  NOT NULL,
  title       VARCHAR2(100) NOT NULL,
  content     VARCHAR2(4000)NOT NULL,
  view_count  NUMBER        DEFAULT 0 NOT NULL,
  created_at  VARCHAR2(30)  DEFAULT SYSDATE NOT NULL,
  CONSTRAINT PK_HQBOARD PRIMARY KEY (num)
);

-- 16. branch_stock (부모: branches, inventory)
CREATE TABLE branch_stock (
    branch_num        NUMBER         NOT NULL PRIMARY KEY,                              -- 재고 고유번호 (PK)
    branch_id         VARCHAR2(20)   NOT NULL REFERENCES branches(branch_id),           -- 지점 아이디 (FK → branches.branch_id)
    inventory_id      NUMBER         NOT NULL REFERENCES inventory(num),                -- 재고 아이디 (FK → inventory.num)
    product           VARCHAR2(100)  NOT NULL,                                           -- 제품 이름
    current_quantity  NUMBER,                                                           -- 현재 물건 수량
    updatedat         DATE                                                              -- 마지막 추가 날짜
);


-- 1. users_p (부모: FK 참조 대상 없음)
CREATE TABLE users_p (
  num           NUMBER          NOT NULL,
  branch_id     VARCHAR2(20)  UNIQUE  NOT NULL,
  user_id       VARCHAR2(20) UNIQUE   NOT NULL,
  password      VARCHAR2(100)   NOT NULL,
  user_name     VARCHAR2(20)    NOT NULL,
  location      VARCHAR2(100),
  phone         VARCHAR2(50),
  profile_image VARCHAR2(255),
  role          VARCHAR2(10),
  updated_at    DATE,
  created_at    DATE,
  CONSTRAINT PK_USERS_P PRIMARY KEY (num, branch_id)
);

-- 2. branches (부모: users_p)
CREATE TABLE branches (
  num        NUMBER        NOT NULL,
  branch_id  VARCHAR2(20)  NOT NULL UNIQUE,
  name       VARCHAR2(50)  NOT NULL,
  address    VARCHAR2(100) NOT NULL,
  phone      VARCHAR2(20)  NOT NULL,
  status     VARCHAR2(20)  DEFAULT '운영중',
  created_at DATE          DEFAULT SYSDATE,
  updated_at DATE,
  CONSTRAINT PK_BRANCHES      PRIMARY KEY (num),
  CONSTRAINT FK_BRANCHES_USER FOREIGN KEY (branch_id) REFERENCES users_p(branch_id)
);

-- 3. Inventory (부모: 없음 or 나중에 stock_request 에서 참조)
CREATE TABLE Inventory (
  inventory_id NUMBER        NOT NULL,
  branch_id    NUMBER        NOT NULL,
  product      VARCHAR2(100) NOT NULL,
  quantity     NUMBER        NOT NULL,
  isDisposal   VARCHAR2(10)  DEFAULT 'NO',
  isPlaceOrder VARCHAR2(10)  DEFAULT 'NO',
  is_approval  VARCHAR2(20)  DEFAULT '대기',
  CONSTRAINT PK_INVENTORY PRIMARY KEY (inventory_id)
);

-- 4. stock_request (부모: branches, Inventory)
CREATE TABLE stock_request (
  order_id         NUMBER        NOT NULL,
  branch_id        VARCHAR2(20)  NOT NULL,
  inventory_id     NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  status           VARCHAR2(20),
  requestedat      DATE,
  updatedat        DATE,
  request_status   VARCHAR2(10),
  CONSTRAINT PK_STOCK_REQUEST PRIMARY KEY (order_id),
  CONSTRAINT FK_SR_BRANCH     FOREIGN KEY (branch_id)    REFERENCES branches(branch_id),
  CONSTRAINT FK_SR_INVENTORY  FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);

-- 5. placeOrder_head (부모: Inventory)
CREATE TABLE placeOrder_head (
  order_id      NUMBER        NOT NULL,
  inventory_num NUMBER        NOT NULL,
  order_date    DATE,
  manager       VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_HEAD           PRIMARY KEY (order_id),
  CONSTRAINT FK_PLACEORDER_HEAD_INVENTORY FOREIGN KEY (inventory_num) REFERENCES Inventory(inventory_id)
);

-- 6. placeOrder_head_detail (부모: placeOrder_head)
CREATE TABLE placeOrder_head_detail (
  detail_id        NUMBER        NOT NULL,
  order_id         NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  approval_status  VARCHAR2(10),
  manager          VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_HEAD_DETAIL PRIMARY KEY (detail_id, order_id),
  CONSTRAINT FK_PHD_PLACEORDER_HEAD    FOREIGN KEY (order_id) REFERENCES placeOrder_head(order_id)
);

-- 7. placeOrder_branch (부모: stock_request)
CREATE TABLE placeOrder_branch (
  order_id  NUMBER        NOT NULL,
  order_date DATE,
  manager   VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_BRANCH               PRIMARY KEY (order_id),
  CONSTRAINT FK_PO_BRANCH_STOCK_REQ FOREIGN KEY (order_id) REFERENCES stock_request(order_id)
);

-- 8. placeOrder_branch_detail (부모: stock_request)
CREATE TABLE placeOrder_branch_detail (
  detail_id        NUMBER        NOT NULL,
  order_id         NUMBER        NOT NULL,
  branch_id        VARCHAR2(20)  NOT NULL,
  inventory_id     NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  approval_status  VARCHAR2(10),
  manager          VARCHAR2(20),
  CONSTRAINT PK_PLACEORDER_BRANCH_DETAIL PRIMARY KEY (detail_id),
  CONSTRAINT FK_POBD_ORDER             FOREIGN KEY (order_id)     REFERENCES stock_request(order_id),
  CONSTRAINT FK_POBD_BRANCH            FOREIGN KEY (branch_id)    REFERENCES branches(branch_id),
  CONSTRAINT FK_POBD_INVENTORY         FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
);

-- 9. inbound_orders (부모: branches)
CREATE TABLE inbound_orders (
  order_id  NUMBER        NOT NULL,
  branch_id NUMBER        NOT NULL,
  approval  VARCHAR2(10),
  in_date   DATE,
  manager   VARCHAR2(100),
  CONSTRAINT PK_INBOUND_ORDERS        PRIMARY KEY (order_id)
);

-- 10. outbound_orders (부모: branches)
CREATE TABLE outbound_orders (
  order_id  NUMBER        NOT NULL,
  branch_id VARCHAR2(20)        NOT NULL,
  approval  VARCHAR2(10),
  out_date  DATE,
  manager   VARCHAR2(100),
  CONSTRAINT PK_OUTBOUND_ORDERS        PRIMARY KEY (order_id),
  CONSTRAINT FK_OUTBOUND_ORDERS_BRANCH FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 11. work_log (부모: branches, users_p)
CREATE TABLE work_log (
  log_id     NUMBER        NOT NULL,
  branch_id  VARCHAR2(20)  NOT NULL,
  user_id    VARCHAR2(20)  NOT NULL,
  work_date  DATE          NOT NULL,
  start_time DATE          NOT NULL,
  end_time   DATE          NOT NULL,
  CONSTRAINT PK_WORK_LOG            PRIMARY KEY (log_id),
  CONSTRAINT FK_WORK_LOG_BRANCH     FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CONSTRAINT FK_WORK_LOG_USER       FOREIGN KEY (user_id)   REFERENCES users_p(user_id)
);

-- 12. sales (부모: branches)
CREATE TABLE sales (
  sales_id    NUMBER        NOT NULL,
  branch_id   VARCHAR2(20)  NOT NULL,
  created_at  DATE          DEFAULT SYSDATE NOT NULL,
  totalamount NUMBER,
  CONSTRAINT PK_SALES           PRIMARY KEY (sales_id),
  CONSTRAINT FK_SALES_BRANCH    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

-- 13. board_p (부모: users_p)
CREATE TABLE board_p (
  num             NUMBER        NOT NULL,
  branch_id       VARCHAR2(20)  NOT NULL,
  user_id         VARCHAR2(20)  NOT NULL,
  title           VARCHAR2(100) NOT NULL,
  content         CLOB          NOT NULL,
  writer          VARCHAR2(20)  NOT NULL,
  view_count      NUMBER        NOT NULL,
  created_at      VARCHAR2(30)  NOT NULL,
  board_type      VARCHAR2(20)  NOT NULL,
  parent_num      NUMBER,
  target_user_id  VARCHAR2(20),
  CONSTRAINT PK_BOARD_P             PRIMARY KEY (num, branch_id),
  CONSTRAINT FK_BOARD_P_BRANCH      FOREIGN KEY (branch_id)   REFERENCES users_p(branch_id),
  CONSTRAINT FK_BOARD_P_USER        FOREIGN KEY (user_id)     REFERENCES users_p(user_id)
);

-- 14. product (부모: 없음)
CREATE TABLE product (
  num         NUMBER        NOT NULL,
  name        VARCHAR2(100) NOT NULL,
  description VARCHAR2(1000),
  price       NUMBER        NOT NULL,
  status      VARCHAR2(20),
  imagepath   VARCHAR2(255),
  CONSTRAINT PK_PRODUCT PRIMARY KEY (num)
);

-- 15. hqboard (부모: 없음)
CREATE TABLE hqboard (
  num         NUMBER        NOT NULL,
  writer      VARCHAR2(20)  NOT NULL,
  title       VARCHAR2(100) NOT NULL,
  content     VARCHAR2(4000)NOT NULL,
  view_count  NUMBER        DEFAULT 0 NOT NULL,
  created_at  VARCHAR2(30)  DEFAULT SYSDATE NOT NULL,
  CONSTRAINT PK_HQBOARD PRIMARY KEY (num)
);


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
    created_at  DATE           NOT NULL, 		-- 등록일
    updated_at  DATE, 							-- 수정일
    status		VARCHAR2(20)   NOT NULL			-- 운영 상태(운영중 | 휴업 | 폐업)
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