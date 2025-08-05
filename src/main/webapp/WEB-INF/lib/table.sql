
-- 250804 테이블문 ------------------- ▼ -------------

--1. baord_p
CREATE TABLE board_p (
    num             NUMBER         PRIMARY KEY,
    branch_id       VARCHAR2(20)   NOT NULL,
    title           VARCHAR2(100)  NOT NULL,
    content         CLOB           NOT NULL,
    view_count      NUMBER         DEFAULT 0 NOT NULL,
    created_at      VARCHAR2(30)   NOT NULL,
    board_type      VARCHAR2(20)   NOT NULL,
    parent_num      NUMBER,
    writer          VARCHAR2(20)   NOT NULL,
    target_user_id  VARCHAR2(20),
    user_id         VARCHAR2(20)   NOT NULL,
    CONSTRAINT fk_board_p_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    CONSTRAINT fk_board_p_user FOREIGN KEY (user_id) REFERENCES users_p(user_id),
    CONSTRAINT fk_board_p_target_user FOREIGN KEY (target_user_id) REFERENCES users_p(user_id),
    CONSTRAINT fk_board_p_parent FOREIGN KEY (parent_num) REFERENCES board_p(num)
);

--2. BRANCHES

CREATE TABLE branches (
  num        NUMBER        NOT NULL,
  branch_id  VARCHAR2(20)  NOT NULL,
  name       VARCHAR2(50)  NOT NULL,
  address    VARCHAR2(100) NOT NULL,
  phone      VARCHAR2(20)  NOT NULL,
  status     VARCHAR2(20)  DEFAULT '운영중',
  created_at DATE          DEFAULT SYSDATE,
  updated_at DATE,
  CONSTRAINT pk_branches_num_branch_id PRIMARY KEY (num, branch_id),
  CONSTRAINT uq_branches_branch_id     UNIQUE (branch_id)
);

--3. BRANCH_STOCK

CREATE TABLE branch_stock (
  branch_num       NUMBER        NOT NULL,
  branch_id        VARCHAR2(20)  NOT NULL,
  inventory_id     NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER,
  updatedat        DATE,
  CONSTRAINT pk_branch_stock PRIMARY KEY (branch_num),
  CONSTRAINT fk_branch_stock_branch    FOREIGN KEY (branch_id)    REFERENCES branches(branch_id),
  CONSTRAINT fk_branch_stock_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(num)
);

--4. HQBOARD

CREATE TABLE hqboard (
  num         NUMBER        NOT NULL,
  writer      VARCHAR2(20)  NOT NULL,
  title       VARCHAR2(100) NOT NULL,
  content     VARCHAR2(4000) NOT NULL,
  view_count  NUMBER        DEFAULT 0 NOT NULL,
  created_at  VARCHAR2(30)  DEFAULT SYSDATE NOT NULL,
  CONSTRAINT pk_hqboard PRIMARY KEY (num)
);
-- 5. INBOUND_ORDERS

CREATE TABLE inbound_orders (
  order_id   NUMBER        NOT NULL,
  branch_id  NUMBER        NOT NULL,
  approval   VARCHAR2(10),
  in_date    DATE,
  manager    VARCHAR2(100)
  -- 제약조건 없음 (PK/FK)
);
-- 6. INVENTORY

CREATE TABLE inventory (
  num           NUMBER        NOT NULL,
  branch_id     NUMBER        NOT NULL,
  product       VARCHAR2(100) NOT NULL,
  quantity      NUMBER        NOT NULL,
  isdisposal    VARCHAR2(10)  DEFAULT 'NO',
  isplaceorder  VARCHAR2(10)  DEFAULT 'NO',
  is_approval   VARCHAR2(20)  DEFAULT '대기',
  CONSTRAINT pk_inventory PRIMARY KEY (num)
);

--7. OUTBOUND_ORDERS

CREATE TABLE outbound_orders (
  order_id   NUMBER        NOT NULL,
  branch_id  VARCHAR2(20)  NOT NULL,
  approval   VARCHAR2(10),
  out_date   DATE,
  manager    VARCHAR2(100),
  CONSTRAINT fk_outbound_orders_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

--8. PLACEORDER_BRANCH

CREATE TABLE placeorder_branch (
  order_id   NUMBER       NOT NULL,
  order_date DATE,
  manager    VARCHAR2(20),
  CONSTRAINT fk_po_branch_stock_req FOREIGN KEY (order_id) REFERENCES stock_request(order_id)
);

--9. PLACEORDER_BRANCH_DETAIL

CREATE TABLE placeorder_branch_detail (
  detail_id        NUMBER        NOT NULL,
  order_id         NUMBER        NOT NULL,
  branch_id        VARCHAR2(20)  NOT NULL,
  inventory_id     NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  approval_status  VARCHAR2(10),
  manager          VARCHAR2(20),
  CONSTRAINT fk_pobd_branch    FOREIGN KEY (branch_id)    REFERENCES branches(branch_id),
  CONSTRAINT fk_pobd_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(num),
  CONSTRAINT fk_pobd_order     FOREIGN KEY (order_id)     REFERENCES stock_request(order_id)
);

--10. PLACEORDER_HEAD

CREATE TABLE placeorder_head (
  order_id      NUMBER       NOT NULL,
  inventory_num NUMBER       NOT NULL,
  order_date    DATE,
  manager       VARCHAR2(20),
  CONSTRAINT pk_placeorder_head PRIMARY KEY (order_id),
  CONSTRAINT fk_placeorder_head_inventory FOREIGN KEY (inventory_num) REFERENCES inventory(num)
);
 --11. PLACEORDER_HEAD_DETAIL

CREATE TABLE placeorder_head_detail (
  detail_id        NUMBER        NOT NULL,
  order_id         NUMBER        NOT NULL,
  product          VARCHAR2(100) NOT NULL,
  current_quantity NUMBER        NOT NULL,
  request_quantity NUMBER        NOT NULL,
  approval_status  VARCHAR2(10),
  manager          VARCHAR2(20),
  CONSTRAINT fk_phd_placeorder_head FOREIGN KEY (order_id) REFERENCES placeorder_head(order_id)
);

--12. PRODUCT

CREATE TABLE product (
  num         NUMBER        NOT NULL,
  name        VARCHAR2(100) NOT NULL,
  description VARCHAR2(1000),
  price       NUMBER        NOT NULL,
  status      VARCHAR2(20),
  imagepath   VARCHAR2(255),
  CONSTRAINT pk_product PRIMARY KEY (num)
);
--13. SALES

CREATE TABLE sales (
  sales_id    NUMBER        NOT NULL,
  branch_id   VARCHAR2(20)  NOT NULL,
  created_at  DATE          DEFAULT SYSDATE NOT NULL,
  totalamount NUMBER,
  CONSTRAINT pk_sales PRIMARY KEY (sales_id),
  CONSTRAINT fk_sales_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

--14. STOCK_REQUEST

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
  branch_num       NUMBER        NOT NULL,
  CONSTRAINT pk_stock_request PRIMARY KEY (order_id),
  CONSTRAINT fk_sr_branch    FOREIGN KEY (branch_id)    REFERENCES branches(branch_id),
  CONSTRAINT fk_sr_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(num)
);

-- 15. USERS_P

CREATE TABLE users_p (
  num          NUMBER        NOT NULL,
  branch_id    VARCHAR2(20)  NOT NULL,
  user_id      VARCHAR2(20)  NOT NULL,
  password     VARCHAR2(100) NOT NULL,
  user_name    VARCHAR2(20)  NOT NULL,
  location     VARCHAR2(100),
  phone        VARCHAR2(50),
  profile_image VARCHAR2(255),
  role         VARCHAR2(10),
  updated_at   DATE,
  created_at   DATE,
  CONSTRAINT pk_users_p PRIMARY KEY (num),
  CONSTRAINT uq_users_p_user_id UNIQUE (user_id)
);

-- 16. WORK_LOG

CREATE TABLE work_log (
  log_id     NUMBER        NOT NULL,
  branch_id  VARCHAR2(20)  NOT NULL,
  user_id    VARCHAR2(20)  NOT NULL,
  work_date  DATE          NOT NULL,
  start_time DATE          NOT NULL,
  end_time   DATE          NOT NULL,
  CONSTRAINT pk_work_log PRIMARY KEY (log_id),
  CONSTRAINT fk_work_log_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CONSTRAINT fk_work_log_user   FOREIGN KEY (user_id)   REFERENCES users_p(user_id)
);

-- 17. comments_p
CREATE TABLE comments_p(
	num NUMBER PRIMARY KEY, -- 댓글 고유 번호 (시퀀스 사용)
	board_num NUMBER NOT NULL, -- 원글 번호(board_p 테이블의 num 참조)
	writer VARCHAR2(100) NOT NULL, -- 작성자
	content CLOB NOT NULL, -- 댓글 내용
	created_at DATE DEFAULT SYSDATE, -- 작성일
	updated_at DATE, -- 수정일
	FOREIGN KEY (board_num) REFERENCES board_p(num) ON DELETE CASCADE
);

CREATE SEQUENCE placeOrder_head_seq;

CREATE SEQUENCE hqboard_seq;

CREATE SEQUENCE sales_seq;

CREATE SEQUENCE inventory_seq;

CREATE SEQUENCE inbound_seq;


CREATE SEQUENCE inandout_seq;

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

CREATE SEQUENCE users_p_seq;

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

CREATE SEQUENCE outbound_sequence;


CREATE SEQUENCE branches_seq;

CREATE SEQUENCE work_log_seq;

CREATE SEQUENCE board_p_seq;                     -- board_p.num

CREATE SEQUENCE branch_stock_seq;                -- branch_stock.branch_num

CREATE SEQUENCE pob_detail_seq;                  -- placeorder_branch_detail.detail_id

CREATE SEQUENCE pohd_detail_seq;                 -- placeorder_head_detail.detail_id

CREATE SEQUENCE product_seq;                     -- product.num

CREATE SEQUENCE stock_request_seq;               -- stock_request.order_id

CREATE SEQUENCE users_p_seq;     

CREATE SEQUENCE comments_p_seq;
-- 250804 테이블문 ------------------- ▲ -------------

