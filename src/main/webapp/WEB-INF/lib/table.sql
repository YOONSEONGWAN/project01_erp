CREATE TABLE comment



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

CREATE SEQUENCE board_p_seq;

CREATE TABLE users_p (
    num          NUMBER         PRIMARY KEY,             -- 회원 고유번호 (내부 PK)
    branch_id    VARCHAR2(20)   NOT NULL,                -- 지점 아이디 (FK)
    user_id      VARCHAR2(20)   NOT NULL UNIQUE,         -- 로그인 ID (고유값)
    password     VARCHAR2(100)  NOT NULL,                -- 비밀번호
    user_name    VARCHAR2(20)   NOT NULL,                -- 이름
    location     VARCHAR2(100),                          -- 주소
    phone        VARCHAR2(50),                           -- 전화번호
    role         VARCHAR2(10),                           -- 역할 (관리자/지점 등)
    updated_at   DATE,                                   -- 수정 일자
    created_at   DATE,                                   -- 가입 일자
    CONSTRAINT fk_users_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE SEQUENCE users_p_seq;

CREATE TABLE branches (
    num         NUMBER         PRIMARY KEY,           -- 지점 고유번호 (내부 PK)
    branch_id   VARCHAR2(20)   NOT NULL UNIQUE,       -- 지점 ID (외부 참조용 ID)
    name        VARCHAR2(50)   NOT NULL,              -- 지점 이름
    address     VARCHAR2(100)  NOT NULL,              -- 지점 주소
    phone       VARCHAR2(20)   NOT NULL,              -- 지점 연락처
    created_at  DATE           NOT NULL DEFAULT SYSDATE, -- 등록일 (기본값 SYSDATE)
    updated_at  DATE                                     -- 수정일 (nullable)
);