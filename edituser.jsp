<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Editing User...</title>
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

		//Set up connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		try {
			String user = null;
			if (request.getParameter("EditUser") != null) {
				String s = request.getParameter("EditUser");
				user = s.substring(s.lastIndexOf(' ') + 1);

			}

			//	out.print(user);

			Statement stmt = con.createStatement();
			String str = "SELECT * FROM Person WHERE user_name='" + user + "';";
			ResultSet result = stmt.executeQuery(str);
			result.next();

			//out.print(str);
	%>
	<h2>
		New Information for User:
		<%=user%></h2>
	<form action="edituser.jsp">

		<input type="hidden" id="EditUser" name="EditUser" value=<%=user%>>
		<label>UserName</label> <input type="text" id="unameEdit"
			name="unameEdit"
			value="<%out.print(result.getString("user_name"));%>"> <label>Name</label>
		<input name="nameEdit" type="text" id="nameEdit"
			value="<%out.print(result.getString("name"));%>"> <label>Password</label>
		<input type="text" id="pswdEdit" name="pswdEdit"
			value="<%out.print(result.getString("passwd"));%>">
		<%--  <label>Account
			Num.</label> <select id="accnumE" name="accnumE">
			<option value="1"
				<%if (Integer.parseInt(result.getString("accountnum")) == 1) {
					out.print("selected");
				}%>>1</option>
			<option
				<%if (Integer.parseInt(result.getString("accountnum")) == 0) {
					out.print("selected");
				}%>>0</option>
		</select> --%>
		<label>Admin.</label> <select id="adminnumE" name="adminnumE">
			<option
				<%if (Integer.parseInt(result.getString("adminnum")) == 1) {
					out.print("selected");
				}%>>1</option>
			<option
				<%if (Integer.parseInt(result.getString("adminnum")) == 0) {
					out.print("selected");
				}%>>0</option>
		</select> <label>Rep.</label> <select id="repnum" name="repnumE">
			<option
				<%if (Integer.parseInt(result.getString("repnum")) == 1) {
					out.print("selected");
				}%>>1</option>
			<option
				<%if (Integer.parseInt(result.getString("repnum")) == 0) {
					out.print("selected");
				}%>>0</option>
		</select> <input type="Submit" value="Edit User Data" />
	</form>

	<%
		String name = request.getParameter("nameEdit");
			String username = request.getParameter("unameEdit");
			String pass = request.getParameter("pswdEdit");
			String adminnumE = request.getParameter("adminnumE");
			String repnumE = request.getParameter("repnumE");
			//	String accnumE = request.getParameter("accnumE");

			String oname = result.getString("name");
			String ouname = result.getString("user_name");
			String opswd = result.getString("passwd");
			String oadnum = result.getString("adminnum");
			//String oaccnum = result.getString("accountnum");
			String orepnum = result.getString("repnum");
			str = "UPDATE Person SET ";

			if (!username.equals(ouname)) {
				str += "`user_name` = \"" + username + "\",";
			}
			if (!name.equals(oname)) {
				str += "`name` = \"" + name + "\",";
			}
			if (!pass.equals(opswd)) {
				str += "`passwd` = \"" + pass + "\",";
			}
			if (!adminnumE.equals(oadnum)) {
				str += "`adminnum` = " + adminnumE + ",";
			}
			if (!repnumE.equals(orepnum)) {
				str += "`repnum` = " + repnumE + ",";
			}
			/* 	if(!accnumE.equals(oaccnum)) {
					str += "`accountnum` = " + accnumE + ",";
				} */

			if (str.charAt(str.length() - 1) == ',') {
				str = str.substring(0, str.length() - 1);
			}

			str += " WHERE `user_name` =\"" + ouname + "\";";
			//out.print(str); 

			PreparedStatement ps = con.prepareStatement(str);

			ps.executeUpdate();

			ps = con.prepareStatement(str);
			ps.executeUpdate();

			if (name != null && name.length() != 0) {
	%>
	<b>Updated User Information:</b>
	<ul>
		<li>Username: <%=username%></li>
		<li>Name: <%=name%></li>
		<li>Password: <%=pass%></li>
		<li>Admin Num.: <%=adminnumE%></li>
		<li>Rep Num.: <%=repnumE%></li>
		<%-- 		<li>Account Num.: <%=accnumE%></li> --%>
	</ul>





	<%
		}

		} catch (Exception e) {
			out.print("ERROR: " + e);
		}
	%>

</body>
</html>
