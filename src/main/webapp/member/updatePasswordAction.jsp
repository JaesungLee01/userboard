<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");

	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	System.out.println(request.getParameter("memberId") + "<-- updatePasswordAction memberId");
	System.out.println(request.getParameter("beforememberPw") + "<-- updatePasswordAction beforememberPw");
	
	if(request.getParameter("memberId") == null
			|| request.getParameter("memberId").equals("")
			|| request.getParameter("beforememberPw") == null
			|| request.getParameter("beforememberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	if(request.getParameter("memberPw") == null
			|| request.getParameter("memberPw").equals("")
			|| request.getParameter("memberPwCheck") == null
			|| request.getParameter("memberPwCheck").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/imformationForm.jsp");
		return;
	}
		
	String memberId = request.getParameter("memberId");
	String beforememberPw = request.getParameter("beforememberPw");
	String memberPw = request.getParameter("memberPw");
	String memberPwCheck = request.getParameter("memberPwCheck");
	
	System.out.println(memberId + "<-- updatePasswordAction memberId");
	System.out.println(memberPw + "<-- updatePasswordAction memberPw");
	System.out.println(memberPwCheck + "<-- updatePasswordAction memberPwCheck");
	
	if(!memberPw.equals(memberPwCheck)) {
		response.sendRedirect(request.getContextPath()+"/member/imformationForm.jsp");
		return;
	}
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	PreparedStatement updatePwStmt = null;
	String updatePwSql = "UPDATE member SET member_pw = PASSWORD(?), updatedate = now() WHERE member_id = ? AND member_pw = PASSWORD(?);";
	updatePwStmt = conn.prepareStatement(updatePwSql);
	updatePwStmt.setString(1, memberPw);
	updatePwStmt.setString(2, memberId);
	updatePwStmt.setString(3, beforememberPw);
	
	
	System.out.println(updatePwStmt + "<-- updatePasswordAction updatePwStmt");
	
	
	
	int row = updatePwStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath()+"/member/updatePasswordForm.jsp?memberPw="+memberPw+"&memberPw="+beforememberPw);
		return;
	}
	
	session.invalidate();
	response.sendRedirect(request.getContextPath()+"/home.jsp?");
	
	
%>








