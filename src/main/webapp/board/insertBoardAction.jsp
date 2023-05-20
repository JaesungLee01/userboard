<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	// 요청값 유효성 검사
	System.out.println(request.getParameter("localName"));
	String msg = "";
	if(request.getParameter("localName") == null
			|| request.getParameter("localName").equals("")){
		msg = URLEncoder.encode("지역을 선택하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	if(request.getParameter("boardTitle") == null
			|| request.getParameter("boardTitle").equals("")
			|| request.getParameter("boardTitle").equals("제목을 입력해주세요")){
		msg = URLEncoder.encode("제목을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	if(request.getParameter("boardContent") == null
			|| request.getParameter("boardContent").equals("")
			|| request.getParameter("boardContent").equals("내용을 입력해주세요")){
		msg = URLEncoder.encode("내용을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg="+msg);
		return;
	}
	
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	// db접속
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	
	PreparedStatement updateBoardStmt = null;
	String updateBoardSql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) VALUES(?,?,?,?,NOW(),NOW())";
	updateBoardStmt = conn.prepareStatement(updateBoardSql);
	updateBoardStmt.setString(1, localName);
	updateBoardStmt.setString(2, boardTitle);
	updateBoardStmt.setString(3, boardContent);
	updateBoardStmt.setString(4, loginMemberId);
	
	System.out.println(updateBoardStmt + "<-- insertBoardAction BoardStmt");

	int row = updateBoardStmt.executeUpdate();
	
	if (row == 1) {
		System.out.println("게시물 등록 성공");
	}
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>