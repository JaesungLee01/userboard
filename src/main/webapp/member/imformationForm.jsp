<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;
	}
	// 로그인 중인 아이디 변수에 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	// 디버깅
	System.out.println(loginMemberId + " <-- profileForm parameter loginMemberId");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 로그인 중인 Memeber 조회 결과 셋
	// 로그인 중인 Memeber와 일치하는 행을 조회하는 sql 전송
	PreparedStatement profileStmt = null;
	ResultSet profileRs = null;
	String profileSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ?;";
	profileStmt = conn.prepareStatement(profileSql);
	profileStmt.setString(1, loginMemberId);
	// 위 sql 디버깅
	System.out.println(profileStmt + " <-- profileForm profileStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	profileRs = profileStmt.executeQuery();
	Member profile = null;
	if(profileRs.next()) {
		profile = new Member();
		profile.setMemberId(profileRs.getString("memberId"));
		profile.setMemberPw(profileRs.getString("memberPw")); 
		profile.setCreatedate(profileRs.getString("createdate"));
		profile.setUpdatedate(profileRs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>회원정보</title>
        <link href="<%=request.getContextPath() %>/template/css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="bg-primary">
    
        <jsp:include page="/inc/header.jsp"></jsp:include>
                <main class="login">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-5">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-header"><h3 class="text-center font-weight-light my-4">회원정보</h3></div>
                                    <div class="card-body">
                                        <form action="<%=request.getContextPath() %>/member/updatePasswordForm.jsp" method="post">
                                            <div class="form-floating mb-3">
                                                <input class="form-control" readonly="readonly" name="memberId" type="text" value="<%=profile.getMemberId()%>" />
                                                <label for="inputEmail">아이디</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="inputEmail" type="password" name="memberPw" />
                                                <label for="inputEmail">비밀번호</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="inputEmail" value="<%=profile.getCreatedate().substring(0, 10)%>"  />
                                                <label for="inputEmail">생성날짜</label>
                                            </div>
                                            <button type="submit">비밀번호 수정</button>
											<button type="submit" formaction="<%=request.getContextPath() %>/member/deleteMemberAction.jsp">회원 탈퇴</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="<%=request.getContextPath() %>/template/js/scripts.js"></script>
    </body>
</html>
