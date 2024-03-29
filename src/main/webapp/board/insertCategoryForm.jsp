<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {				// 로그인 중이 아니라면
		response.sendRedirect(request.getContextPath()+"/home.jsp");// 홈으로
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>카테고리 추가</title>
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
		<h1>카테고리 추가</h1>
		<form action="<%=request.getContextPath()%>/board/insertCategoryAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">지역명</th>
					<td><input type="text" name="localName"></td>
				</tr>
			</table>
			<button type="submit">추가</button>
		</form>
	</div>
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
</body>
</html>