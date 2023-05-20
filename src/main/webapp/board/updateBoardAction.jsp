<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>

<%
	// 세션유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
	// 요청값 유효성 검사
	if(request.getParameter("boardNo") == null
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = "";
	if(request.getParameter("localName") == null
			|| request.getParameter("localName").equals("")) {
		msg = URLEncoder.encode("지역을 선택하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
		
	}
	if(request.getParameter("boardTitle") == null
			|| request.getParameter("boardTitle").equals("")) {
		msg = URLEncoder.encode("제목을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
		
	}
	if(request.getParameter("boardContent") == null
			|| request.getParameter("boardContent").equals("")) {
		msg = URLEncoder.encode("내용을 입력하세요", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/updateBoardForm.jsp?msg="+msg+"&boardNo="+boardNo);
		return;
		
	}
	
	// 요청값 변수에 저장
	String localName = request.getParameter("localName");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement updateBoardStmt = null;
	String updateBoardSql = "UPDATE board SET local_name=?, board_title=?, board_content=?, updatedate=NOW() WHERE board_no=? AND member_id=?";
	updateBoardStmt = conn.prepareStatement(updateBoardSql);
	updateBoardStmt.setString(1,localName);
	updateBoardStmt.setString(2,boardTitle);
	updateBoardStmt.setString(3,boardContent);
	updateBoardStmt.setInt(4,boardNo);
	updateBoardStmt.setString(5,loginMemberId);
	
	System.out.println(updateBoardStmt + "<-- updateBoardAction updateBoardStmt");
	
	int row = updateBoardStmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("게시물수정 완료");
	}
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>

