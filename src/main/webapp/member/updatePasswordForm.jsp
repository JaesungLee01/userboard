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
	// 요청값 유효성 검사
	if(request.getParameter("memberId") == null						// 아이디 정보가 없으면 홈으로
		|| request.getParameter("memberId").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	if(request.getParameter("memberPw") == null						// 비밀번호 정보가 없으면 회원정보 페이지로
		|| request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	}
	// 요청값 변수에 저장
	String memberId = request.getParameter("memberId");
	String oldMemberPw = request.getParameter("memberPw");
	// 디버깅
	System.out.println(memberId + " <-- updatePasswordForm prameter memberId");
	System.out.println(oldMemberPw + " <-- updatePasswordForm prameter oldMemberPw");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 입력받은 비밀번호와 일치하는 데이터 조회 결과 셋
	// 입력받은 비밀번호와 일치하는 행을 조회하는 sql 전송
	PreparedStatement updatePwStmt = null;
	ResultSet updatePwRs = null;
	String updatePwSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ? AND member_pw = PASSWORD(?);";
	updatePwStmt = conn.prepareStatement(updatePwSql);
	updatePwStmt.setString(1, memberId);
	updatePwStmt.setString(2, oldMemberPw);
	// 위 sql 디버깅
	System.out.println(updatePwStmt + " <-- profileForm profileStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	updatePwRs = updatePwStmt.executeQuery();
	Member profile = null;
	if(!updatePwRs.next()) {					// 비밀번호가 틀리면 회원정보 페이지로
		response.sendRedirect(request.getContextPath()+"/member/profileForm.jsp");
		return;
	} else {
		profile = new Member();
		profile.setMemberId(updatePwRs.getString("memberId"));
		profile.setMemberPw(updatePwRs.getString("memberPw")); 
		profile.setCreatedate(updatePwRs.getString("createdate"));
		profile.setUpdatedate(updatePwRs.getString("updatedate"));
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
        <title>Password Reset - SB Admin</title>
        <link href="<%=request.getContextPath() %>/template/css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="bg-primary">
         <jsp:include page="/inc/header.jsp"></jsp:include>
                <main>
                    <div class="login">
                        <div class="row justify-content-center">
                            <div class="col-lg-5">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-header"><h3 class="text-center font-weight-light my-4">Password Recovery</h3></div>
                                    <div class="card-body">
                                        <div class="small mb-3 text-muted">Enter your email address and we will send you a link to reset your password.</div>
                                        <form action="<%=request.getContextPath() %>/member/updatePasswordAction.jsp" method="post">
                                            <div class="form-floating mb-3">
                                            	<input type="hidden" name="memberId" value="<%=profile.getMemberId()%>">
												<input type="hidden" name="oldMemberPw" value="<%=oldMemberPw %>">
                                                <input class="form-control" id="inputEmail" type="password" name="memberPw" />
                                                <label for="inputEmail">새 비밀번호</label>
                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="inputEmail" type="password" name="memberPwCk" />
                                                <label for="inputEmail">비밀번호 확인</label>
                                            </div>
                                            <button type="submit">수정</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                </main>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="<%=request.getContextPath() %>/template/js/scripts.js"></script>
    </body>
</html>
