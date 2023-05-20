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
	String msg = "";
	if(request.getParameter("msg") != null) {
		msg = request.getParameter("msg");
	}
	if(request.getParameter("boardNo") == null
			|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//db접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	PreparedStatement localStmt = null;
	ResultSet localRs = null;
	String localSql = "SELECT local_name localName FROM local";
	localStmt = conn.prepareStatement(localSql);
	
	localRs = localStmt.executeQuery();
	ArrayList<Local> localList = new ArrayList<Local>();
	while(localRs.next()){
		Local l = new Local();
		l.setLocalName(localRs.getString("localName"));
		localList.add(l);
	}
	
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	
	System.out.println(boardStmt + "<-- updateBoardForm boardStmt");
	
	boardRs = boardStmt.executeQuery();
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.setBoardNo(boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("localName"));
		board.setBoardTitle(boardRs.getString("boardTitle"));
		board.setBoardContent(boardRs.getString("boardContent"));
		board.setMemberId(boardRs.getString("memberId"));
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp" method="post">
		<table>
			<tr>
				<th>지역</th>
				<td>
					<input type="hidden" name="boardNo" value="<%=board.getBoardNo() %>">
					<select name="localName">
						<option value="">지역을 선택해주세요</option>
						<%
							for(Local l : localList) {
								if(board.getLocalName().equals(l.getLocalName())){
							
						%>
								<option value="<%=l.getLocalName()%>" selected="selected"><%=l.getLocalName() %></option>
							
						<%
								}else {
						%>
									<option value="<%=l.getLocalName()%>"><%=l.getLocalName()%></option>
						<%
								}
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name="boardTitle" value="<%=board.getBoardTitle()%>"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="boardContent"><%=board.getBoardContent()%></textarea></td>
			</tr>
		</table>
		<button>수정
		</button>
	</form>
</body>
</html>