<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	// 로그인중인 아이디 저장
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	System.out.println(loginMemberId + "<-- imformationloginMemberId");
	
	// db 연결
   	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 로그인중인 Member 조회
	PreparedStatement imformationStmt = null;
	ResultSet imformationRs = null;
	String imformationSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ?;";
	imformationStmt = conn.prepareStatement(imformationSql);
	imformationStmt.setString(1, loginMemberId);
	// 디버깅
	System.out.println(imformationStmt + "<-- imforamtionForm Stmt");
	
	imformationRs = imformationStmt.executeQuery();
	Member imformation = null;
	if(imformationRs.next()) {
		imformation = new Member();
		imformation.setMemberId(imformationRs.getString("memberId"));
		imformation.setMemberPw(imformationRs.getString("memberPw"));
		imformation.setCreatedate(imformationRs.getString("createdate"));
		imformation.setUpdatedate(imformationRs.getString("updatedate"));
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
	<h1>회원 정보</h1>
	<form action="<%=request.getContextPath()%>/member/updatePasswordForm.jsp" method="post">
		<table class="table table-info">
			<tr>
				<th>아이디</th>
				<td><input type="text" readonly="readonly" value="<%=imformation.getMemberId() %>" name="memberId"></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="memberPw"></td>
			</tr>
			<tr>
				<th>생성날짜</th>
				<td><%=imformation.getCreatedate().substring(0,10) %></td>
			</tr>
		</table>
		
		<button type="submit">비밀번호 수정</button>
		<button type="submit" formaction="<%=request.getContextPath()%>/member/deleteMemberAction.jsp">회원 탈퇴</button>
	
	</form>


</div>
</body>
</html>