<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
// 인코딩 설정
	request.setCharacterEncoding("utf-8");
	// 1.요청분석 (컨트롤러 계층)
	// 1) session JSP내장 (기본)객체
	// 2) request / response JSP 내장 (기본) 객체
	
	int currentPage = 1;
	int rowPerPage = 10;
	int startRow = 0;
	
	// 2.모델 계층

	
	// localName 기본값을 전체로 설정
	String localName = "전체";
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
	}
		// 디버깅
		System.out.println(localName + " <-- home localName");
		
		// db 연결
	   	String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		// 전체의 행을 구하는 sql 전송                    
		PreparedStatement subMenuStmt = null;
		ResultSet subMenuRs = null;
	
		// 쿼리문
		String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
		subMenuStmt = conn.prepareStatement(subMenuSql);
		// sql 문 디버깅
		System.out.println(subMenuStmt);
		
		subMenuRs = subMenuStmt.executeQuery();
		
		ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String,Object>>();
		while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt",subMenuRs.getInt("cnt"));
		subMenuList.add(m);
		}
		
		PreparedStatement listStmt = null;
		ResultSet listRs = null;
		String listSql = "SELECT board_no boardNo, board_title boardTitle, local_name localName FROM board ORDER BY board_no DESC LIMIT ?, ?";
		
		if(!localName.equals("전체")) {
		listSql = "SELECT board_no boardNo, board_title boardTitle, local_name localName FROM board WHERE local_name=? ORDER BY board_no DESC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, localName);
		listStmt.setInt(2, startRow);
		listStmt.setInt(3, rowPerPage);
			} else {
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, startRow);
		listStmt.setInt(2, rowPerPage);
	
		}
		
		listRs = listStmt.executeQuery();
		
		ArrayList<Board> list = new ArrayList<Board>();
		
		// vo board 데이터
		while(listRs.next()) {
		Board b = new Board();
		b.setBoardNo(listRs.getInt("boardNo")); 
		b.setBoardTitle(listRs.getString("boardTitle"));
		b.setLocalName(listRs.getString("localName")); 
		list.add(b);
		}
		// 2) 게시판 목록 결과셋(모델)
		//PreparedStatement boardStmt = null;
		//ResultSet boardRs = null;
		/*
	SELECT
		board_no boardNo,
		local_name localName,
		board_title boardTitle,
		createdate
	FROM board
	WHERE local_name=?
	ORDER BY createdate DESC
	LIMIT ?, ? 
		*/
		/*
		String boardSql = "";
		if(localName.equals("")){
	boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board ORDER BY createdate DESC LIMIT ?, ? ";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, startRow);
	boardStmt.setInt(2, rowPerPage);
	
		} else {
	boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board WHERE local_name=? ORDER BY createdate DESC LIMIT ?, ? ";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setString(1, localName);
	boardStmt.setInt(2, startRow);
	boardStmt.setInt(3, rowPerPage);
	
		}
		boardRs = boardStmt.executeQuery();
		ArrayList<board> boardList = new ArrayList<board>(); // 어플리케이션에서 사용할 모델 (사이즈0)
		
		while (boardRs.next()) {
	board b = new board();
	b.boardNo = 
		}
		*/
%>	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>

	<%
	/*
		SELECT '전체' localName, COUNT(local_name) cnt FROM board
		UNION ALL
		SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name
			*/
			
			//subMenuList <-- 모델데이터
	%>
   	
   <%
   	   // request.getRequestDispatcher("/inc/mainmenu.jsp").include(request, response);
   	         // 이코드 액션태그로 변경하면 아래와 같다
   	   %>
   <!-- 메인메뉴(가로) -->
   <div class="container">
      <jsp:include page="/inc/mainmenu.jsp"></jsp:include>
   </div>
   <!-- 서브메뉴(세로) subMenuList모델을 출력 -->
   
   <div class="container">
   
      <!-- home 내용 : 로그인폼 / 카테고리별 게시글 5개씩 -->   
      <!-- 로그인 폼 -->
      <%
      if(session.getAttribute("loginMemberId") == null) { // 로그인전이면 로그인폼출력
      %>
            <form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
               <table class="table table-info">
                  <tr>
                     <td>아이디</td>
                     <td><input type="text" name="memberId"></td>
                  </tr>
                  <tr>
                     <td>패스워드</td>
                     <td><input type="password" name="memberPw"></td>
                  </tr>
               </table>
               <button type="submit">로그인</button>
            </form>
      <%
      }
      %>
      
      <!-- 카테고리별 게시글 5개씩  -->
      
   </div>
   
   <div>
   		<ul>

		<%
		for(HashMap<String, Object> m : subMenuList) {
		%>
			<li>
				<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
					<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
				</a>
			</li>
		<%
		}
		%>
	</ul>
   </div>
   <div>
   		<table>
   			<tr>
   				<th>번호</th>
   				<th>구분</th>
   				<th>제목</th>
   			</tr>
   			<%
   			for(Board b : list) {
   			%>
   				<tr>
   					<td><%=b.getBoardNo() %></td>
   					<td><%=b.getLocalName() %></td>
   					<td>
   						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
   						<%=b.getBoardTitle() %>
   						</a>
   					</td>
   				</tr>
   			<%
   				}
   			%>
   		</table>
   </div>

   <div class="container">
      <!-- include 페이지 : Copyright &copy; 구디아카데미 -->
      <jsp:include page="/inc/copyright.jsp"></jsp:include>
   </div>
</body>
</html>