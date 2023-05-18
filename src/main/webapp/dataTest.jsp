<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%
	// 필드 정보은닉이 안된 Data클래스
	Data d = new Data();
	d.x = 7;
	d.y = 10;
	System.out.println(d.x);
	System.out.println(d.y);
	System.out.println(d.x);
	System.out.println(d.y);
	
	// 필드 정보은닉이 안된 Data클래스
	/*
	Data2 d2 = new Data2();
	d2.x = 7;
	d2.y = 10; // Data2 y필드는 private 으로 정보은닉 되어있다
	System.out.println(d2.x);
	System.out.println(d2.y);
	*/
%>