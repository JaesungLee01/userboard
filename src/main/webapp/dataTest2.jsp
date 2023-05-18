<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*"%>

<%
	Data3 d1 = new Data3();
	Data3 d2 = new Data3();
	/*
	d1.x = 1;
	d2.x = 100;
	*/
	d1.setX(777);
	d2.setX(444);
	
	System.out.println(d1.getX()); // this -> d1
	System.out.println(d2.getX()); // this -> d2
%>