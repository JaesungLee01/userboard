<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	// 요청값 유효성 검사
	String msg = "";
	if(request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
	
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localSql = "SELECT local_name localName FROM local";
	localStmt = conn.prepareStatement(localSql);
	
	// 디버깅
	System.out.println(localStmt + "<--insertBoardForm localStmt");
	
	localRs = localStmt.executeQuery();
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()) {
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		localList.add(l);
		
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
		<table>
			<tr>
				<th>지역</th>
				<td>
					<select name="localName">
						 <option value="">지역을 선택해주세요 </option>
						 <%
						 	for(Local l : localList) {
						 %>
						 	<option value="<%=l.getLocalName()%>"><%=l.getLocalName()%></option>
						 <%
						 	}
						 %>
					</select>
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="boardContent">내용을 입력하세요</textarea></td>
			</tr>
		</table>
		<button type="submit">등록</button>
	</form>
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>