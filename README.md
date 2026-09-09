# Fiction-Hub-Novel (FictionHub)

웹소설 연재·감상 플랫폼. 독자는 작품을 감상하고, 작가는 작품을 연재하며,
신인작가 광장·리뷰·자유게시판 등 커뮤니티 기능을 제공한다.

## 기술 스택

| 구분 | 사용 기술 |
|------|-----------|
| 언어 | Java 11 |
| 프레임워크 | Spring Framework 5 (Spring MVC) |
| 뷰 | JSP + JSTL |
| 영속성 | MyBatis, Spring JDBC |
| DB | MySQL (HikariCP 커넥션 풀) |
| 인증 | 자체 인증 (jBCrypt 비밀번호 해시) |
| 빌드 | Maven |
| 에디터 | CKEditor (신인작가 광장 게시판) |

## 주요 기능

- **회원 / 인증**: 회원가입, 로그인, 아이디·비밀번호 찾기, 마이페이지(내 글·댓글 관리, 정보 수정)
- **작품**: 소설 목록·상세·회차 열람
- **작가**: 작가 신청, 작가 페이지, 작품 등록
- **커뮤니티**: 신인작가 광장(rookie), 리뷰(review), 자유게시판(find)
- **관리자**: 회원·작가·소설·콘텐츠 관리

## 프로젝트 구조

```
src/main/java/com/novel/
├── controller/   # Auth, Home, Novel, Board, MyPage, Admin
├── service/      # 비즈니스 로직
├── dao|mapper/   # MyBatis 매퍼
├── domain|dto/   # 도메인 · DTO
├── exception/    # 커스텀 예외
└── util/         # HtmlSanitizer 등 유틸
src/main/webapp/WEB-INF/views/   # JSP 뷰
schema_v7.sql, schema_v8.sql     # DB 스키마
```

## 실행 방법

1. MySQL에 스키마 적용
   ```bash
   mysql -u root -p < schema_v7.sql
   mysql -u root -p < schema_v8.sql
   ```
2. DB 접속 정보 설정 (`src/main/resources`의 DataSource 설정)
3. 빌드 및 실행
   ```bash
   mvn clean package
   ```
   생성된 WAR를 Tomcat 9(Servlet 4 / Java 11)에 배포한다.

## 보안 처리

- 비밀번호는 jBCrypt로 해시하여 저장
- 회원가입 입력값은 서버에서 재검증 (`InvalidRegistrationException`)
- 신인작가 광장 게시글은 저장 전 화이트리스트 기반 HTML 새니타이징 (`HtmlSanitizer`)
  으로 XSS 차단, 그 외 사용자 입력은 JSTL `<c:out>` / `fn:escapeXml`로 이스케이프
