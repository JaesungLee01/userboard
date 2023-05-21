<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String loginMemberId = "";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");
		return;
	}
	
	if(request.getParameter("boardNo") == null
			|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	String boardNo = request.getParameter("boardNo");
	
	if(request.getParameter("commentNo") == null
			|| request.getParameter("commentNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	if(request.getParameter("commentContent") == null
			|| request.getParameter("commentContent").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	
	
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement updateCommentStmt = null;
	String updateCommentSql = "UPDATE comment SET comment_content=? WHERE member_id=? AND comment_no=?";
	updateCommentStmt = conn.prepareStatement(updateCommentSql);
	updateCommentStmt.setString(1, commentContent);
	updateCommentStmt.setString(2, loginMemberId);
	updateCommentStmt.setInt(3, commentNo);
	
	int row = updateCommentStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("댓굴 수정 성공");
	}
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	
	
	
%>