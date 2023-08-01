<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
// 1. 요청분석(컨트롤러 계층)
	//현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 페이지 당 행 개수
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	// 시작 행 번호
	int startRow = 0 + (currentPage-1) * rowPerPage;
	
	// 요청값 유효성 검사
	// localName 변수 전체로 초기화
	String localName = "전체";
	
	if(request.getParameter("localName") != null) {			// 요청값 localName이 null이 아니면
		localName = request.getParameter("localName");		// 요청값 저장
	}
	// 요청값 디버깅
	System.out.println(localName + " <-- home localName");
	
	// 2. 모델계층
	// db 접속
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	// 1) 서브메뉴 결과셋(모델)
	// 전체, localName의 행의 수를 구하는 sql 전송
	PreparedStatement subMenuStmt = null;
	ResultSet subMenuRs = null;
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(*) FROM board GROUP BY local_name UNION ALL SELECT local_name, 0 FROM local WHERE local_name != All(SELECT local_name FROM board GROUP BY local_name);";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	// 위 sql 디버깅
	System.out.println(subMenuStmt + " <-- home subMenuStmt");
	// 전송한 sql 실행값 반환
	// 위 쿼리의 결과셋 모델
	subMenuRs = subMenuStmt.executeQuery();
	// subMenuList <-- HashMap<String, Object>의 데이터를 가진 ArrayList 모델 데이터
	// 애플리케이션에서 사용할 모델(사이즈 0)
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", subMenuRs.getString("localName"));
		m.put("cnt", subMenuRs.getInt("cnt"));
		subMenuList.add(m);
	}
	// 2) 페이지 수 결과셋
	// 총 행의 수를 구하는 sql 전송
	PreparedStatement totalRowStmt = null;
	ResultSet totalRowRs = null;
	String totalRowSql = "SELECT COUNT(*) FROM board";
	if(!localName.equals("전체")) {	// localName이 전체가 아니면
		totalRowSql =  "SELECT COUNT(*) FROM board WHERE local_name=?";
		totalRowStmt = conn.prepareStatement(totalRowSql);
		totalRowStmt.setString(1, localName);
	} else {
		totalRowStmt = conn.prepareStatement(totalRowSql);
	}
	// sql 디버깅
	System.out.println(totalRowStmt + " <-- home totalRowStmt");
	totalRowRs = totalRowStmt.executeQuery();
	//총 행의 수
	int totalRow = 0;
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("count(*)");
	}
	// 마지막 페이지 = 총 행의 수 / 페이지 당 행의 수
	int lastPage = totalRow / rowPerPage;
	// 총 행의 수 / 페이지 당 행의 수 의 나머지가 0이 아니면 마지막 페이지 + 1
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
		
	// 3) 게시판 목록 결과셋(모델)
	// boardNo, boardTitle를 조회하는 sql 
	PreparedStatement listStmt = null;
	ResultSet listRs = null;
	String listSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board ORDER BY board_no DESC";
	if(!localName.equals("전체")) {	// localName이 전체가 아니면
		listSql =  "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board WHERE local_name=? ORDER BY board_no DESC";	// localName이 일치하는 행을 조회
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, localName);
	} else {
		listStmt = conn.prepareStatement(listSql);
	}
	// sql 디버깅
	System.out.println(listStmt + " <-- home listStmt");
	// sql 실행 결과
	// 위 쿼리의 결과셋 모델
	listRs = listStmt.executeQuery();
	// vo타입 Board의 데이터를 가진 ArrayList
	// 애플리케이션에서 사용할 모델(사이즈 0)
	ArrayList<Board> list = new ArrayList<Board>();
	while (listRs.next()) {
		Board b = new Board();
		b.setBoardNo(listRs.getInt("boardNo"));
		b.setLocalName(listRs.getString("localName"));
		b.setBoardTitle(listRs.getString("boardTitle"));
		b.setCreatedate(listRs.getString("createdate"));
		list.add(b);
	}
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>HOME</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="<%=request.getContextPath() %>/template/css/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="<%=request.getContextPath()%>/home.jsp">user board</a>
            <!-- Sidebar Toggle-->
            <!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
                <div class="input-group">
                    <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                    <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
                </div>
            </form>
            <!-- Navbar-->
            <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
		            <%
						if(session.getAttribute("loginMemberId") == null) {	// 로그인 정보가 없다면 로그인 폼 표시
					%>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/member/loginForm.jsp">로그인</a></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/member/insertMemberForm.jsp">회원가입</a></li>
                    <%	
						} else {
					%>
                        <li><%=session.getAttribute("loginMemberId") %>님 환영합니다!</a></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/member/imformationForm.jsp">회원정보</a></li>
                    <%		
						}
					%>
                    </ul>
                </li>
            </ul>
        </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
            </div>
            <div id="layoutSidenav_content">
                <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                            <div class="text-muted"><jsp:include page="/inc/copyright.jsp"></jsp:include></div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="<%=request.getContextPath() %>/template/js/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="<%=request.getContextPath() %>/template/js/datatables-simple-demo.js"></script>
    </body>
</html>
