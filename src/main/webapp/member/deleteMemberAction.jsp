<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {		
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 요청값 유효성 검사
	if(request.getParameter("memberId") == null						
		|| request.getParameter("memberId").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	if(request.getParameter("memberPw") == null	
		|| request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/imformationForm.jsp");
		return;
	}
	
	// 요청값 변수에 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 디버깅
	System.out.println(memberId + " <-- deleteMemberAction memberId");
	System.out.println(memberPw + " <-- deleteMemberAction memberPw");
	
	//db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement deleteMemberStmt = null;
	String deleteMemberSql = "DELETE FROM member WHERE member_id = ? AND member_pw = PASSWORD(?);";
	deleteMemberStmt = conn.prepareStatement(deleteMemberSql);
	deleteMemberStmt.setString(1, memberId);
	deleteMemberStmt.setString(2, memberPw);
	// 디버깅
	System.out.println(deleteMemberStmt + " <-- deleteMemberActionStmt");
	
	// 전송한 sql 실행값 반환
	// db쿼리 결과셋 모델
	int row = deleteMemberStmt.executeUpdate();
	
	if(row == 1){ 
		System.out.println("회원 삭제 성공");
	} else { 	
		
		System.out.println("회원 삭제 실패"); 
		response.sendRedirect(request.getContextPath()+"/member/imformationForm.jsp");
		return;
	}
	
	// 비밀번호 변경 완료 후 로그아웃 
	session.invalidate();
	response.sendRedirect(request.getContextPath() + "/home.jsp?");
%>