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


