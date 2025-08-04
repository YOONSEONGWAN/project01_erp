CREATE TABLE comments_p(
	num NUMBER PRIMARY KEY, -- 댓글 고유 번호 (시퀀스 사용)
	board_num NUMBER NOT NULL, -- 원글 번호(board_p 테이블의 num 참조)
	writer VARCHAR2(100) NOT NULL, -- 작성자
	content CLOB NOT NULL, -- 댓글 내용
	created_at DATE DEFAULT SYSDATE, -- 작성일
	updated_at DATE, -- 수정일
	FOREIGN KEY (board_num) REFERENCES board_p(num) ON DELETE CASCADE
);

CREATE SEQUENCE comments_p_seq;

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


