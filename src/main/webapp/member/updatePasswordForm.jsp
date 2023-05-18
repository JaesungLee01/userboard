<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//요청값 유효성 검사
	if(request.getParameter("memberId") == null 
			|| request.getParameter("memberId").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	if(request.getParameter("memberPw") == null
			|| request.getParameter("memberPw").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/member/imformationForm.jsp");
		return;
	}
	// 변수에 저장
	String memberId = request.getParameter("memberId");
	String beforememberPw = request.getParameter("memberPw");
	// 디버깅
	System.out.println(memberId + "<-- updatePasswordForm memberId");
	System.out.println(beforememberPw + "<-- updatePasswordForm memberPw");
	
	// db 연결
   	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement updatePwStmt = null;
	ResultSet updatePwRs = null;
	String updatePwSql = "SELECT member_id memberId, member_pw memberPw, createdate, updatedate FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	updatePwStmt = conn.prepareStatement(updatePwSql);
	updatePwStmt. setString(1,memberId);
	updatePwStmt. setString(2,beforememberPw);
	
	updatePwRs = updatePwStmt.executeQuery();
	Member imformation = null;
	if(!updatePwRs.next()) {
		response.sendRedirect(request.getContextPath()+"/member/imformationForm.jsp");
		return;
	} else {
		
		imformation = new Member();
		imformation.setMemberId(updatePwRs.getString("memberId"));
		imformation.setMemberPw(updatePwRs.getString("memberPw"));
		imformation.setCreatedate(updatePwRs.getString("createdate"));
		imformation.setUpdatedate(updatePwRs.getString("updatedate"));
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
	<h1>비밀번호 수정</h1>
	<form action="<%=request.getContextPath()%>/member/updatePasswordAction.jsp" method="post">
		<table class="table table-info">
		<tr>
			<th>새 비밀번호</th>
				<td>
					<input type="hidden" name="memberId" value="<%=imformation.getMemberId() %>">
					<input type="hidden" name="beforememberPw" value="<%=beforememberPw %>" >
					<input type="password" name="memberPw">
				</td>
			</tr>
			<tr>
				<th>비밀번호 확인</th>
				<td><input type="password" name="memberPwCheck"></td>
			</tr>
		</table>
		<button type="submit">정보 수정</button>
	</form>

</div>
</body>
</html>