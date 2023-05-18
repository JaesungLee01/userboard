<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%

	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	String sql = "SELECT local_name localName, '대한민국'conuntry, '박성환' worker FROM LOCAL LIMIT 0,1";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	// vo 대신 HashMap타입을 사용
	
	HashMap<String, Object> map = null;
	if(rs.next()) {
		// 디버깅
		// System.out.println(rs.getString("localName"));
		// System.out.println(rs.getString("conuntry"));
		// System.out.println(rs.getString("worker"));
		map = new HashMap<String, Object>();
		map.put("localName",rs.getString("localName"));
		map.put("conuntry",rs.getString("conuntry"));
		map.put("worker",rs.getString("worker"));
	}
		System.out.println((String)map.get("localName"));
		System.out.println((String)map.get("conuntry"));
		System.out.println((String)map.get("worker"));
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	String sql2 = "SELECT local_name localName, '대한민국'conuntry, '박성환' worker FROM local LIMIT 0,1";
	stmt2 = conn.prepareStatement(sql);
	rs2 = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	
	while(rs2.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs2.getString("localName"));
		m.put("conuntry", rs2.getString("conuntry"));
		m.put("worker", rs2.getString("worker"));
		list.add(m);
	}
	
	
	PreparedStatement stmt3 = null;
	ResultSet rs3 = null;
	String sql3 = "SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
	stmt3 = conn.prepareStatement(sql3);
	rs3 = stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	
	while(rs3.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName", rs3.getString("localName"));
		m.put("cnt", rs3.getInt("cnt"));
		list3.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
		<tr>
			<th>localName</th>
			<th>conuntry</th>
			<th>worker</th>
		</tr>
		<%
			for(HashMap<String, Object> m : list) {
				
		%>
			<tr>
				<td><%=m.get("localName") %></td>
				<td><%=m.get("conuntry") %></td>
				<td><%=m.get("worker") %></td>
			</tr>
		<%
			}
		%>
	</table>
	
	<hr>
	
	<ul>
		<li>
			<a href="">전체</a>
		</li>
		<%
			for(HashMap<String, Object> m : list3) {
		%>
			<li>
				<a href="">
					<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt") %>)
				</a>
			</li>
		<%
			}
		%>
	</ul>
</body>
</html>