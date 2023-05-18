<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	// 유효성 검사
	if(request.getParameter("memberId").equals("")
		||request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
		return;
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 요청값 디버깅
	System.out.println(memberId + " <-- insertMemberAction memberId");
	System.out.println(memberId + " <-- insertMemberAction memberPw");
	
	// 요청값 객체에 묶어서 저장
	Member paramMember = new Member();
	paramMember.setMemberId(memberId); 
	paramMember.setMemberPw(memberPw);
	
	// 객체 디버깅
	System.out.println(paramMember.getMemberId() + " <-- insertMemberAction memberId");
	System.out.println(paramMember.getMemberPw() + " <-- insertMemberAction memberPw");
	
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// sql 전송
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES (?, PASSWORD(?), NOW(), NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	
	// sql 디버깅
	System.out.println(stmt + " <-- insertMemberAction sql");
	
	int row = stmt.executeUpdate();
	
	if(row == 1){ // 회원가입 성공
		System.out.println("회원가입 성공");
	} else { 	// 회원가입 실패
		System.out.println("회원가입 실패"); 
	}
	
	response.sendRedirect(request.getContextPath() + "/home.jsp");
%>