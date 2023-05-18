<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
request.setCharacterEncoding("utf-8");	
	

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int currentPage = 1;
	int rowPerPage = 10;
	int startRow = 0;
	
	// 모델계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 전체의 행을 구하는 sql 전송
	
	// boardd one 결과 셋
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo,local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1,boardNo);
	
	boardRs = boardStmt.executeQuery(); // row -> 1 -> Board타입
	
	Board board = null;
	if(boardRs.next()){
		board = new Board();
		board.setBoardNo(boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("localName")); 
		board.setBoardTitle(boardRs.getString("boardTitle")); 
		board.setBoardContent(boardRs.getString("boardContent")); 
		board.setMemberId(boardRs.getString("memberId")); 
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}
	
	// commentList 결과 셋
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	String commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? ORDER BY createdate DESC LIMIT ?, ?";
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1,boardNo);
	commentListStmt.setInt(2,startRow);
	commentListStmt.setInt(3,rowPerPage);
	
	commentListRs = commentListStmt.executeQuery(); //row -> 최대10 -> ArrayList<comment>
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentListRs.next()){
		Comment c = new Comment();
		c.setCommentNo(commentListRs.getInt("commentNo"));
		c.setBoardNo(commentListRs.getInt("boardNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate").substring(0,10));
		commentList.add(c);
	}
	
	
	//뷰계층
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 3-1)board one 결과세 -->
	<table>
		<tr>
			<th>boardNo</th>
			<td><%=board.getBoardNo() %></td>
		</tr>
		<tr>
			<th>localName</th>
			<td><%=board.getLocalName() %></td>
		</tr>
		<tr>
			<th>boardTitle</th>
			<td><%=board.getBoardTitle() %></td>
		</tr>
		<tr>
			<th>boardContent</th>
			<td><%=board.getBoardContent() %></td>
		</tr>
		<tr>
			<th>memberId</th>
			<td><%=board.getMemberId() %></td>
		</tr>
		<tr>
			<th>createDate</th>
			<td><%=board.getCreatedate() %></td>
		</tr>
		<tr>
			<th>updatdDate</th>
			<td><%=board.getUpdatedate() %></td>
		</tr>

	</table>
	<%
		if(session.getAttribute("loginMemberId") == board.getMemberId()){
			
	%>
			<button type="submit">수정</button>
			<button type="submit">삭제</button>
	<%
		}
		// 로그인 사용자만 댓글 입력 허용
		if(session.getAttribute("loginMemberId") !=null ){
			// 현재 로그인 사용자 아이디
			String loginMemberId = (String)session.getAttribute("loginMemberId");
	%>
		<form action="<%=request.getContextPath()%>/board/insertCommentAcion.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=board.getBoardNo()%>">
			<input type="hidden" name="memberId" value="<%=loginMemberId%>">
			<table>
				<th>commentContent</th>
				<td>
					<textarea rows="2" cols="80" name="commentContent"></textarea>
				</td>
			</table>
			<button type="submit">댓글입력</button>
		</form>
	
	<%
		}
	%>
	
	<!-- 3-1)board one 결과세 -->
	<table>
		<tr>
	
			<th>commentContent</th>
			<th>memberId</th>
			<th>createdate</th>
			<th>updatedate</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Comment c : commentList) {
				
		%>
			<tr>
				<td><%=c.getMemberId() %></td>
				<td><%=c.getCommentContent() %></td>
				<td><%=c.getCreatedate() %></td>
				<td><%=c.getUpdatedate() %></td>
				<td>수정</td>
				<td>삭제</td>
			</tr>
		<%
			}
		%>
	</table>
	
	<div>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentpage=<%=currentPage-1%>">이전</a>
		<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentpage=<%=currentPage+1%>">다음</a>
	</div>
	
	
</body>
</html>