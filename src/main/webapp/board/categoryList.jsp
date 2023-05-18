<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement categoryStmt = null;
	ResultSet categoryRs = null;
	String categorySql = "SELECT local_name localName, createdate, updatedate FROM local;";
	categoryStmt = conn.prepareStatement(categorySql);
	
	System.out.println(categoryStmt + "<-- categoryList categoryStmt");
	
	categoryRs = categoryStmt.executeQuery();
	
	ArrayList<Board> categoryList = new ArrayList<Board>();
	while(categoryRs.next()) {
		Board c = new Board();
		c.setLocalName(categoryRs.getString("localName"));
		c.setCreatedate(categoryRs.getString("createdate"));
		c.setUpdatedate(categoryRs.getString("updatedate"));
		categoryList.add(c);
		
	}
	
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<h1>카테고리</h1>
	<a href="<%=request.getContextPath()%>/board/insertCategoryForm.jsp">카테고리 추가</a>
	<table>
		<tr>
			<th>지역명</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Board c : categoryList){
		%>
			<tr>
				<td>
					<%=c.getLocalName() %>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/board/updateCategoryForm.jsp?localName=<%=c.getLocalName()%>">수정</a>
				</td>
				<td>
					<a href="<%=request.getContextPath()%>/board/deleteCategoryAction.jsp?localName=<%=c.getLocalName()%>">삭제</a>				
				</td>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>