<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 컨트롤러 계층
	//세션 유효성 검사
	String loginMemberId = "";
	if(session.getAttribute("loginMemberId") != null) {
		loginMemberId = (String)session.getAttribute("loginMemberId");

	}
	// 요청값 유효성 검사
	if (request.getParameter("boardNo") == null							// boardNo가 null이거나 공백이면
		|| request.getParameter("boardNo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");	// home.jsp로 가라
		return;															// 코드 종료
	}
	// 요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	int commentNo = 0;
	if(request.getParameter("commentNo") != null) {
		commentNo = Integer.parseInt(request.getParameter("commentNo"));
	}
	boolean updateComment = false;
	if(request.getParameter("updateComment") != null) {
		updateComment = Boolean.valueOf(request.getParameter("updateComment"));
	}
	// 요청값 디버깅
	System.out.println(boardNo + " <-- boardOne prameter boardNo");
	int currentPage = 1;
	int rowPerPage = 10;
	int startRow = 0;
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 상세정보 결과셋(모델)
	// boardNo가 일치하는 데이터를 조회하는 sql 전송
	PreparedStatement oneStmt = null;
	ResultSet oneRs = null;
	String oneSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	oneStmt = conn.prepareStatement(oneSql);
	oneStmt.setInt(1, boardNo);
	// 위 sql 디버깅
	System.out.println(oneStmt + " <-- boardOne oneStmt");
	// 쿼리 결과셋 모델
	oneRs = oneStmt.executeQuery();
	// 결과셋 Board 객체에 저장
	Board one = new Board();
	if(oneRs.next()) {
		one.setBoardNo(oneRs.getInt("boardNo"));
		one.setLocalName(oneRs.getString("localName"));
		one.setBoardTitle(oneRs.getString("boardTitle"));
		one.setBoardContent(oneRs.getString("boardContent"));
		one.setMemberId(oneRs.getString("memberId"));
		one.setCreatedate(oneRs.getString("createdate"));
		one.setUpdatedate(oneRs.getString("updatedate"));
	}
	
	// 댓글 결과셋
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? ORDER BY createdate DESC LIMIT ?, ?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, startRow);
	commentStmt.setInt(3, rowPerPage);
	// 위 sql 디버깅
	System.out.println(commentStmt + " <-- boardOne commentStmt");
	// 쿼리 결과셋 모델
	commentRs = commentStmt.executeQuery();
	// 결과셋 ArrayList<Comment>에 저장
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()) {
		Comment c = new Comment();
		c.setCommentNo(commentRs.getInt("commentNo"));
		c.setBoardNo(commentRs.getInt("boardNo"));
		c.setCommentContent(commentRs.getString("commentContent"));
		c.setMemberId(commentRs.getString("memberId"));
		c.setCreatedate(commentRs.getString("createdate"));
		c.setUpdatedate(commentRs.getString("updatedate"));
		commentList.add(c);
	}
	System.out.println(commentList.size() + " <-- boardOne commentList.size()");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>boardOne</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="p-4 bg-dark text-white text-center">
	<a class="navbar-brand ps-3" href="<%=request.getContextPath()%>/home.jsp">user board</a>
	</div>
		<!-- 메인메뉴 -->
	<br>
	<div class="container">
		<div class="row">
			<div class="col-sm-9"><h1>상세 내용</h1></div>
		</div>
	</div>
	<br>
	<div class="container">
		<form action="<%=request.getContextPath()%>/board/updateBoardForm.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark">boardNo</th>
					<td>
						<input type="hidden" name="boardNo" value="<%=one.getBoardNo() %>">
						<%=one.getBoardNo() %>
					</td>
				</tr>
				<tr>
					<th class="table-dark">localName</th>
					<td><%=one.getLocalName() %></td>
				</tr>
				<tr>
					<th class="table-dark">boardTitle</th>
					<td><%=one.getBoardTitle() %></td>
				</tr>
				<tr>
					<th class="table-dark">boardContent</th>
					<td><%=one.getBoardContent() %></td>
				</tr>
				<tr>
					<th class="table-dark">memberId</th>
					<td><%=one.getMemberId() %></td>
				</tr>
				<tr>
					<th class="table-dark">createdate</th>
					<td><%=one.getCreatedate() %></td>
				</tr>
				<tr>
					<th class="table-dark">updatedate</th>
					<td><%=one.getUpdatedate().substring(0, 10) %></td>
				</tr>
			</table>
		<%
			if(one.getMemberId().equals(loginMemberId)) {
		%>
			<button type="submit" class="btn btn-dark">수정</button>
			<button type="submit" class="btn btn-dark" formaction="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">삭제</button>	
		<%	
			}
		%>
		</form>
		<br>
		<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp">
			<table class="table table-bordered">
				<tr>
					<th class="table-dark" col="3">댓글</th>
				</tr>
				<%
					for(Comment c : commentList){
				%>
						<tr>
							<td col="3">
							<%
								if(c.getMemberId().equals(loginMemberId) && updateComment == true) {
							%>
									<input type="hidden" name="boardNo" value="<%=c.getBoardNo() %>">
									<input type="hidden" name="commentNo" value="<%=c.getCommentNo() %>">
									<h5><%=session.getAttribute("loginMemberId") %></h5>
									<div class="row">
										<div class="col-sm">
										<textarea class="form-control" cols="100" name="commentContent"></textarea>
										</div>
										<div class="col-sm-2">
										<button type="submit" class="btn btn-dark">댓글수정</button>
										</div>
									</div>	
							<%		
								} else {
							%>
									<div class="row">
										<div class="col-sm">
											<h5><%=c.getMemberId() %></h5>
											<p><%=c.getCommentContent() %></p>
											<p class="text-muted"><small><%=c.getUpdatedate().substring(0, 10) %></small></p>
										</div>
										<div class="dropdown dropdown-menu-end col-sm-1">
											 <button type="button" class="btn btn-dark dropdown-toggle" data-bs-toggle="dropdown">
											 </button>
									 	<%
											if(c.getMemberId().equals(loginMemberId)) {	
										%>
											 <ul class="dropdown-menu">
											   <li><a class="dropdown-item" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>&updateComment=true">수정</a></li>
											   <li><a class="dropdown-item" href="<%=request.getContextPath()%>/board/deleteCommentAction.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>">삭제</a></li>
											 </ul>
										<%			
												}
										%>
										</div>
									</div>
							<%		
								}
							%>
							</td>
						</tr>
				<%	
					}
				%>
			</table>
		</form>
		<%
			if(session.getAttribute("loginMemberId") != null) {
		%>
				<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp">
					<input type="hidden" name="boardNo" value="<%=one.getBoardNo() %>">
					<table class="table table-bordered">
						<tr>
							<td>
								<h5><%=session.getAttribute("loginMemberId") %></h5>
								<div class="row">
									<div class="col-sm">
									<textarea class="form-control" cols="100" name="commentContent"></textarea>
									</div>
									<div class="col-sm-2">
									<button type="submit" class="btn btn-dark">댓글입력</button>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</form>
		<%	
			}
		%>
		<div>
			<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=one.getBoardNo()%>&currentPage=<%=currentPage-1%>">이전</a>
			<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=one.getBoardNo()%>&currentPage=<%=currentPage+1%>">다음</a>
		</div>
	</div>
	<div class="mt-5 p-4 bg-dark text-white text-center">
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</body>
</html>