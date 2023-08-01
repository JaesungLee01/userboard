<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;
	}

	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// local 테이블을 조회하는 sql 전송
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localSql = "SELECT local_name localName, createdate, updatedate FROM local;";
	localStmt = conn.prepareStatement(localSql);
	// 위 sql 디버깅
	System.out.println(localStmt + " <-- selectLocal localStmt");
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	localRs = localStmt.executeQuery();
	// 애플리케이션에서 사용할 모델(사이즈 0) -> ArrayList
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()) {
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		l.setCreatedate(localRs.getString("createdate"));
		l.setUpdatedate(localRs.getString("updatedate"));
		localList.add(l);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 목록</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="p-4 bg-dark text-white text-center">
	<a class="navbar-brand ps-3" href="<%=request.getContextPath()%>/home.jsp">user board</a>
	</div>
	<div class="container">
		<!-- 메인메뉴(가로) -->
		<h1>카테고리 목록</h1>
		<a href="<%=request.getContextPath()%>/board/insertCategoryForm.jsp">카테고리 추가</a>
		<table class="table table-bordered">
			<tr>
				<th class="table-dark">지역명</th>
				<th class="table-dark">수정</th>
				<th class="table-dark">삭제</th>
			</tr>
			<%
				for(Local l : localList) {
			%>
					<tr>
						<td>
							<%=l.getLocalName() %>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/board/updateCategoryForm.jsp?localName=<%=l.getLocalName() %>"><img src="<%=request.getContextPath()%>/img/edit.png"></a>
						</td>
						<td><a href="<%=request.getContextPath()%>/board/deleteCategoryAction.jsp?localName=<%=l.getLocalName() %>"><img src="<%=request.getContextPath()%>/img/delete.png"></a></td>
					</tr>
			<%		
				}
			%>
		</table>
	</div>
	<div class="mt-5 p-4 bg-dark text-white text-center">
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>