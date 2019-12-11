<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>New User...</title>
<%@ include file="parts/header.jsp"%>
</head>
<body>
	<%
		//Make sure user is signed in
		if (session.getAttribute("username") == null) {
			String site = new String("main.jsp");
			response.setStatus(response.SC_MOVED_TEMPORARILY);
			response.setHeader("Location", site);
		}
	%>
	<h2>New User Info.:</h2>
	<form method="post" action="newuser.jsp">

		Username:<br> <input type="text" name="username"> <br>
		Name:<br> <input type="text" name="name"> <br>
		Password:<br> <input type="text" name="passwd"> <br>
		Admin Num. <select name="adnum">
			<option>0</option>
			<option>1</option>
		</select> Rep Num. <select name="repnum">
			<option>0</option>
			<option>1</option>
		</select> <input type="submit" value="Create New User">
	</form>


	<%
	if(request.getParameter("username") != null)
		try {
			//Set up connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();

			String name = request.getParameter("name");
			String username = request.getParameter("username");
			String pass = request.getParameter("passwd");
			String adminnum = request.getParameter("adnum");
			String repnum = request.getParameter("repnum");
			//String accnum = request.getParameter("accnum");
			Statement stmt = con.createStatement();
			String str = "INSERT INTO `Person`(`user_name`, `passwd`, `name`, `adminnum`, `repnum`) VALUES('";
			str += username + "','" + pass + "','" + name + "','" + adminnum + "','" + repnum
					+ "');";

			PreparedStatement ps = con.prepareStatement(str);
			ps.executeUpdate();

		} catch (Exception e) {
			out.print("ERROR: " + e);
		}
	%>

</body>
</html>
