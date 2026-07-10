-- ========================================================
-- novel 프로젝트 DB 스키마 (v7 - 통합 로그인 폐지, 자체 인증 전환)
-- v6 대비 변경사항:
--   1) 통합 로그인이 사라짐에 따라 이 프로젝트가 직접 인증을 처리하도록 전환
--      -> password 컬럼: 이제 실제 bcrypt 해시가 저장되는 용도로 의미 변경
--      -> integrated_user 테이블명은 과거 통합 로그인 흔적이지만, 마이그레이션 비용 상
--         이번 v7에서는 이름을 그대로 유지 (필요 시 추후 rename 검토)
--   2) role ENUM에 SUPER_ADMIN 추가
--      -> USER: 일반회원 / ADMIN: 관리자 모드 접근 / SUPER_ADMIN: 관리자 임명 권한까지 보유
--      -> SUPER_ADMIN은 시스템에 최초 1명만 두는 것을 권장 (회원가입 화면에서는 선택 불가,
--         DB에서 최초 1회 수동 승격 후 그 계정이 이후 ADMIN을 임명/해제)
--   3) 비밀번호 재설정(찾기) 기능을 위한 password_reset_token 테이블 신설
--   4) 개발용 더미 시드 데이터(CHANGE_ME_HASH) 제거
--      -> 슈퍼어드민 계정은 "회원가입 페이지에서 직접 가입 후 SQL로 role만 승격"하는 방식 권장
--         (평문 비밀번호를 스키마 파일에 남기지 않기 위함)
-- ========================================================

USE novels;

-- ========================================================
-- 1. 회원 테이블
--    role='SUPER_ADMIN'인 회원이 다른 회원에게 ADMIN 권한을 부여/회수할 수 있음
--    role='ADMIN'인 회원은 관리자 모드(/admin/**) 접근은 가능하지만 임명 권한은 없음
-- ========================================================
CREATE TABLE integrated_user (
    user_id INT NOT NULL AUTO_INCREMENT    COMMENT '회원 고유 식별 번호',
    username VARCHAR(50) NOT NULL UNIQUE   COMMENT '로그인 아이디',
    password VARCHAR(255) NOT NULL         COMMENT '비밀번호 - bcrypt 해시값 저장 (평문 저장 금지, 애플리케이션에서 BCrypt.hashpw로 해시 후 저장)',
    nickname VARCHAR(50) NOT NULL          COMMENT '화면에 노출될 유저의 닉네임',
    email VARCHAR(100) NOT NULL UNIQUE     COMMENT '이메일 (비밀번호 찾기 본인확인 및 재설정 메일 발송에 사용)',
    age INT NULL                           COMMENT '회원 나이 (선택 입력)',
    role ENUM('USER', 'ADMIN', 'SUPER_ADMIN') DEFAULT 'USER' NOT NULL 
                                           COMMENT '유저 권한 등급 - USER(일반) / ADMIN(관리자모드 접근) / SUPER_ADMIN(관리자 임명 권한, 시스템 내 1명 권장)',
    is_author BOOLEAN DEFAULT FALSE NOT NULL COMMENT '작가 인증 여부 (Author_Applications 승인 시 TRUE로 전환)',
    pen_name VARCHAR(100) NULL             COMMENT '인증된 작가 필명 (작가 인증 승인 시 채워짐, 인증 마크 표시용)',
    is_suspended BOOLEAN DEFAULT FALSE NOT NULL COMMENT '회원 정지 여부 (TRUE인 경우 로그인 차단)',
    suspended_reason VARCHAR(255) NULL     COMMENT '정지 사유',
    suspended_at TIMESTAMP NULL            COMMENT '정지 처리 일시',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입 일시',
    PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 2. 소설 기본 정보 테이블
-- ========================================================
CREATE TABLE Novels (
    novel_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '소설 작품 고유 번호',
    title VARCHAR(255) NOT NULL            COMMENT '웹소설 제목',
    author_name VARCHAR(100) NOT NULL       COMMENT '웹소설 원작 작가 이름',
    summary TEXT                           COMMENT '모달 팝업창에 노출될 소설 줄거리 요약',
    cover_image_url VARCHAR(255)           COMMENT '액자형 그리드 뷰에 띄울 소설 표지 이미지 URL',
    platform ENUM('카카오페이지', '네이버시리즈', '문피아', '노벨피아', '기타') NOT NULL 
                                           COMMENT '소설이 연재/서비스 중인 메인 플랫폼 구분',
    view_count INT DEFAULT 0               COMMENT '소설 상세 모달 누적 클릭 수',
    managed_by INT NULL                    COMMENT '이 소설 정보를 등록/수정한 관리자 (role=ADMIN 또는 SUPER_ADMIN)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '소설 데이터 등록 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '소설 정보 최종 수정 일시',
    FOREIGN KEY (managed_by) REFERENCES integrated_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 3. [다중 게시판 마스터]
-- ========================================================
CREATE TABLE Boards (
    board_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '게시판 고유 식별 번호',
    board_name VARCHAR(50) NOT NULL        COMMENT '화면 메뉴에 표시될 게시판 이름',
    board_type VARCHAR(20) NOT NULL        COMMENT '게시판 형태 구분 (GENERAL / EDITOR)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '게시판 신설 일시'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 4. [통합 게시글 테이블]
-- ========================================================
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY  COMMENT '게시글 고유 번호',
    board_id INT NOT NULL                  COMMENT '어느 게시판 소속인지 분류',
    user_id INT NOT NULL                   COMMENT '작성자',
    title VARCHAR(255) NOT NULL            COMMENT '게시글 제목',
    content LONGTEXT NOT NULL              COMMENT '글 본문',
    target_author VARCHAR(100) NULL        COMMENT '작가정보 게시판 전용 (대상 프로 작가 이름)',
    platform_tag VARCHAR(20) DEFAULT '전체' COMMENT '게시글 태그',
    view_count INT DEFAULT 0               COMMENT '게시글 상세 조회수',
    is_solved BOOLEAN DEFAULT FALSE        COMMENT '이 소설 찾아요 게시판 전용 - 해결/미해결',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성 일시',
    FOREIGN KEY (board_id) REFERENCES Boards(board_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES integrated_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 5. [통합 댓글 테이블]
-- ========================================================
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글 고유 번호',
    post_id INT NOT NULL                      COMMENT '게시글 매핑',
    user_id INT NOT NULL                      COMMENT '작성자',
    content TEXT NOT NULL                     COMMENT '댓글 본문',
    likes INT DEFAULT 0                       COMMENT '좋아요 수',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성 일시',
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES integrated_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 6. [독립형 평점 테이블]
-- ========================================================
CREATE TABLE Novel_Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY  COMMENT '리뷰 고유 번호',
    novel_id INT NOT NULL                     COMMENT '대상 소설',
    user_id INT NOT NULL                      COMMENT '작성자',
    review_text TEXT NOT NULL                 COMMENT '리뷰 한줄평 내용',
    rating INT CHECK (rating BETWEEN 1 AND 5) COMMENT '평점 (1~5)',
    likes INT DEFAULT 0                       COMMENT '좋아요 수',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '작성 일시',
    FOREIGN KEY (novel_id) REFERENCES Novels(novel_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES integrated_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 7. [작가 인증 신청 테이블]
-- ========================================================
CREATE TABLE Author_Applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '신청 고유 번호',
    user_id INT NOT NULL                   COMMENT '신청 회원',
    pen_name VARCHAR(100) NOT NULL         COMMENT '작가 필명',
    work_title VARCHAR(255) NOT NULL       COMMENT '대표 작품명',
    platform VARCHAR(50) NULL              COMMENT '연재 플랫폼',
    description TEXT NULL                  COMMENT '추가 설명',
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING' NOT NULL COMMENT '심사 상태',
    reviewed_by INT NULL                   COMMENT '심사 처리한 관리자',
    reviewed_at TIMESTAMP NULL             COMMENT '심사 처리 일시',
    reject_reason VARCHAR(255) NULL        COMMENT '반려 사유',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '신청 일시',
    FOREIGN KEY (user_id) REFERENCES integrated_user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES integrated_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 8. Boards 초기 데이터
-- ========================================================
INSERT INTO Boards (board_name, board_type) VALUES
    ('이 소설 찾아요', 'GENERAL'),
    ('신인작가 광장', 'EDITOR'),
    ('작가 정보관', 'EDITOR');

-- ========================================================
-- 9. [댓글 좋아요 중복 방지 테이블]
-- ========================================================
CREATE TABLE Comment_Likes (
    comment_id INT NOT NULL                COMMENT '좋아요를 누른 댓글',
    user_id INT NOT NULL                   COMMENT '좋아요를 누른 회원',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '좋아요 누른 일시',
    PRIMARY KEY (comment_id, user_id),
    FOREIGN KEY (comment_id) REFERENCES Comments(comment_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES integrated_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 10. [신규] 비밀번호 재설정 토큰 테이블
--     - '비밀번호 찾기' 요청 시 1회용 토큰을 발급해 이메일로 전달
--     - 토큰은 만료시간(expires_at)과 사용여부(used)로 재사용/유출 위험을 제한
-- ========================================================
CREATE TABLE password_reset_token (
    token_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '토큰 고유 번호',
    user_id INT NOT NULL                   COMMENT '재설정 대상 회원',
    token VARCHAR(64) NOT NULL UNIQUE      COMMENT '재설정 링크에 포함되는 1회용 토큰 값 (UUID 기반)',
    expires_at DATETIME NOT NULL           COMMENT '토큰 만료 시각 (발급 후 30분 권장)',
    used BOOLEAN DEFAULT FALSE NOT NULL    COMMENT '이미 사용된 토큰인지 여부 (재사용 방지)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '토큰 발급 일시',
    FOREIGN KEY (user_id) REFERENCES integrated_user(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================================
-- 11. 슈퍼어드민 부트스트랩 방법 (스키마 파일에 평문 비밀번호를 남기지 않기 위해
--     "회원가입 -> role 수동 승격" 방식을 사용합니다)
--
--   1) 애플리케이션을 기동하고 /register 에서 슈퍼어드민으로 쓸 계정을 일반 회원처럼 가입합니다.
--   2) 아래 SQL로 그 계정 한 명만 SUPER_ADMIN으로 승격합니다.
--
--      UPDATE integrated_user SET role = 'SUPER_ADMIN' WHERE username = '가입한_아이디';
--
--   3) 이후 관리자 지정은 애플리케이션 화면(관리자 모드 > 회원 관리)에서
--      슈퍼어드민 계정으로 로그인해 다른 회원에게 ADMIN 권한을 부여/회수하면 됩니다.
--      (SUPER_ADMIN은 이 SQL 승격 절차로만 만들어지며, 화면상 UI로는 생성/부여할 수 없습니다)
-- ========================================================
