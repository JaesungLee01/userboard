<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
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
 	<h1>카테고리 추가</h1>
 		<form action="<%=request.getContextPath()%>/board/insertCategoryAction.jsp" method="post">
 			<table>
 				<tr>
 					<th>지역명</th>
 					<td><input type="text" name="localName"></td>
 				</tr>
 			</table>
 			<button type="submit">지역추가</button>
 		</form>
</body>
</html>