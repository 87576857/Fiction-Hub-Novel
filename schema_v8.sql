-- ========================================================
-- v8. [리뷰 좋아요 중복 방지 테이블]
-- Comment_Likes와 동일한 패턴: (review_id, user_id) 복합 PK로 유저당 1리뷰 1좋아요만 허용
-- ========================================================
CREATE TABLE Review_Likes (
    review_id INT NOT NULL                 COMMENT '좋아요를 누른 리뷰',
    user_id INT NOT NULL                   COMMENT '좋아요를 누른 회원',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '좋아요 누른 일시',
    PRIMARY KEY (review_id, user_id),
    FOREIGN KEY (review_id) REFERENCES Novel_Reviews(review_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES integrated_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
