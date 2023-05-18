<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); //기존세션을 지우고 갱신
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>