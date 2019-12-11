<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Editing Airports</title>
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

		if (request.getParameter("newport") != null) {
			try {
				String s = request.getParameter("newport");
				String stre = "INSERT INTO Airports VALUE (\"" + s + "\")";

				PreparedStatement ps = con.prepareStatement(stre);
				ps.executeUpdate();

			} catch (Exception e) {
				out.print(e);
			}
		}
		if (request.getParameter("DeletedPort") != null) {
			try {
				String s = request.getParameter("DeletedPort").split(" ", 0)[2];
				String stre = "DELETE FROM Airports WHERE id='" + s + "';";

				PreparedStatement ps = con.prepareStatement(stre);
				ps.executeUpdate();

			} catch (Exception e) {
				String error = e.toString();
				if (error.contains("a foreign key constraint fails")) {
						out.print("<p><script> alert(\"AIRPORT WAS NOT DELETED: Airport currently in use\"); </script></p>");
				} else {
					out.print(e);
				}
			}
		}

		out.print("<h2>Edit Airports</h2>");
		String str = ("SELECT * FROM Airports");
		Statement stmt = con.createStatement();
		ResultSet result = stmt.executeQuery(str);

		out.print("<table class = \"user-table\"border=\"1\">");
		out.print("<tr>");
		out.print("<thead>");
		out.print("<th>");
		out.print("Airport ID");
		out.print("</th>");
		out.print("<th>");
		out.print("Delete");
		out.print("</th>");

		while (result.next()) {
			out.print("<tr>");
			out.print("<td>");
			out.print(result.getString("id"));
			out.print("</td>");
			out.print("<td>");
			out.print("<form method=\"post\" action=\"airport.jsp\" onSubmit=\"alert('" + result.getString("id")
					+ " WAS DELETED.');\">");
			out.print("<input type=\"submit\" name=\"DeletedPort\" value=\"Delete Airport " + result.getString("id")
					+ "\">");
			out.print("</form>");
			out.print("</td>");
			out.print("</tr>");
		}

		out.print("</table>");
		out.print("<h3>Add Airport:</h3>");
		out.print("<form method=\"post\" action=\"airport.jsp\">");
		out.print("Airport Name: <input type=\"text\" name=\"newport\">");
		out.print("<input type=\"submit\" value=\"Submit\">");
		out.print("</form>");
	%>


</body>
</html>