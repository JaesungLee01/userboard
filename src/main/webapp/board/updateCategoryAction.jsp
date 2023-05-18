<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	if(request.getParameter("beforcategoryName") == null
			|| request.getParameter("beforcategoryName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
		return;
	}
	
	String beforcategoryName = request.getParameter("beforcategoryName");
	
	if(request.getParameter("newcategoryName") == null
			|| request.getParameter("newcategoryName").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/updateCategoryForm.jsp?localName="+beforcategoryName);
		return;
	}
	
	String newcategoryName = request.getParameter("newcategoryName");
	
	System.out.println(newcategoryName + "<-- updateAction categoryName");
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement updateCategoryStmt = null;
	String updateCategorySql = "UPDATE local SET local_name = ?, updatedate = NOW() WHERE local_name = ?;";
	updateCategoryStmt = conn.prepareStatement(updateCategorySql);
	updateCategoryStmt.setString(1, newcategoryName);
	updateCategoryStmt.setString(2, beforcategoryName);
	
	System.out.println(updateCategoryStmt + "<-- updateCategoryAction updateCategoryStmt");
	
	int row = updateCategoryStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("카테고리 수정");
		
	} else {
		
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath()+"/board/updateCategoryForm.jsp?localName="+beforcategoryName);
		return;
	}
	
	response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
	
	
%>