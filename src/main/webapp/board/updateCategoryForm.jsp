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
		response.sendRedirect(request.getContextPath()+"/board/categoryList");
		return;
	}
	
	String categoryName = request.getParameter("localName");
	
	System.out.println(categoryName + "<-- updateCategoryForm categoryName");
	
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
	
	categoryCheckRs = categoryCheckStmt.executeQuery();
	
	int cnt = 0;
	if(categoryCheckRs.next()) {
		cnt = categoryCheckRs.getInt("cnt");
	}
	
	if(cnt != 0) {
		response.sendRedirect(request.getContextPath()+"/board/categoryList.jsp");
		return;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>카테고리 수정</h1>
	<form action="<%=request.getContextPath()%>/board/updateCategoryAction.jsp" method="post">
		<table>
			<tr>
				<th>지역명</th>
				<td>
					<%=categoryName %>
					<input type="hidden" name="beforcategoryName" value="<%=categoryName%>">
				</td>
			</tr>
			<tr>
				<th>새 지역명</th>
				<td>
					<input type="text" name="newcategoryName">
				</td>
			</tr>
		</table>
		<button type="submit">수정</button>
	</form>
</body>
</html>