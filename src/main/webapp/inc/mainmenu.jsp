<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div>
	<ul>
		<li><a href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		<!-- 
			로그인 전 : 회원가입
			로그인 후 : 회원정보 / 로그아웃  (로그인정보 세션 loginMemverId)
		 -->
		 
		 <%
		 	if(session.getAttribute("loginMemberId") == null ){
		 		
		%>
		<li><a href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
		<%
		 	} else {
		 		
		 %>
		<li><a href="<%=request.getContextPath()%>/member/imformationForm.jsp">회원정보</a></li>
		<li><a href="<%=request.getContextPath()%>/board/categoryList.jsp">카테고리</a></li>
		<li><a href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
		 	
		 <%
		 	}
		 %>
	</ul>
</div>