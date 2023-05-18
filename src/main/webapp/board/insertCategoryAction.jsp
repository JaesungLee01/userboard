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
			|| request.getParameter("localName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/insertCategoryForm.jsp");
		return;
	}
	
	String categoryName = request.getParameter("localName");
	
	
	//db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement insertCategoryStmt = null;
	String insertCategorySql = "INSERT INTO local(local_name, createdate, updatedate) VALUES(?, NOW(), NOW());";
	
	insertCategoryStmt = conn.prepareStatement(insertCategorySql);
	
	System.out.println(insertCategoryStmt + "<-- insertCategoryAction insertCategoryStmt");
	insertCategoryStmt.setString(1, categoryName);
	
	int row = insertCategoryStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("카테고리 추가 성공");
	} else {
		System.out.println("카테고리 추가 실패");
		response.sendRedirect(request.getContextPath()+"/board/insertCategoryForm.jsp");
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
%>
>