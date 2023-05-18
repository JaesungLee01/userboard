<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	if(request.getParameter("localName") == null
			|| request.getParameter("localName").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
		return;
	}
	
	String categoryName = request.getParameter("localName");
	
	System.out.println(categoryName + "<--deleteCategorAction categoryName");
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement categoryCheckStmt = null;
	ResultSet categoryCheckRs = null;
	String categoryCheckSql = "SELECT COUNT(local_name) cnt FROM board WHERE local_name = ?;";
	categoryCheckStmt = conn.prepareStatement(categoryCheckSql);
	categoryCheckStmt.setString(1, categoryName);
	
	System.out.println(categoryCheckStmt + "<-- deleteCategoryAction categoryCheckStmt");
	
	categoryCheckRs = categoryCheckStmt.executeQuery();
	int cnt = 0;
	if(categoryCheckRs.next()) {
		cnt = categoryCheckRs.getInt("cnt");
	}
	
	if (cnt != 0){
		response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
		return;
	}
	
	PreparedStatement deleteCategoryStmt = null;
	String deleteCategorySql = "DELETE FROM local WHERE local_name = ?;";
	deleteCategoryStmt = conn.prepareStatement(deleteCategorySql);
	deleteCategoryStmt.setString(1, categoryName);
	
	System.out.println(deleteCategoryStmt + " <-- deleteCategoryAction deleteCategoryStmt");
	
	int row = deleteCategoryStmt.executeUpdate();
	
	if (row == 1) {
		System.out.println("삭제성공");
	} else {
		System.out.println("삭제실패");
		response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
		return;
	}
		
	response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
	
	
%>

