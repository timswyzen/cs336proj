<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Editing Aircraft</title>
<%@ include file="parts/header.jsp" %>
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
		String stre = "INSERT INTO Aircraft SELECT (MAX(id)+1) FROM Aircraft";

		PreparedStatement ps = con.prepareStatement(stre);
		ps.executeUpdate();
		
		stre = "INSERT INTO Owns SELECT \"" + s + "\",MAX(c.id) FROM Aircraft c";
		ps = con.prepareStatement(stre);
		ps.executeUpdate();

	} catch (Exception e) {
		out.print(e);
	}
}
if (request.getParameter("DeletedCraft") != null) {
	try {
		String s = request.getParameter("DeletedCraft").split(" ", 0)[2];
		String stre = "DELETE FROM Owns WHERE cid='" + s + "';";

		PreparedStatement ps = con.prepareStatement(stre);
		ps.executeUpdate();
		
		stre = "DELETE FROM Aircraft WHERE id='" + s + "';";
		ps = con.prepareStatement(stre);
		ps.executeUpdate();

	} catch (Exception e) {
		out.print(e);
	}
}
if (request.getParameter("newowner") != null) {

	try {
		String s = request.getParameter("newowner");
		String c = request.getParameter("cid").split(" ", 0)[1];

		String stre = "UPDATE Owns SET lid=\"" + s + "\" WHERE cid=" + c;
		PreparedStatement ps = con.prepareStatement(stre);
		ps.executeUpdate();

	} catch (Exception e) {
		out.print(e);
	}
}


String str = ("SELECT * FROM Owns");
Statement stmt = con.createStatement();
ResultSet result = stmt.executeQuery(str);

out.print("<h2>Edit Aircrafts</h2>");

out.print("<table class = \"user-table\"border=\"1\">");
out.print("<tr>");
out.print("<thead>");
out.print("<th>");
out.print("Aircraft ID");
out.print("</th>");
out.print("<th>");
out.print("Owned by");
out.print("</th>");
out.print("<th>");
out.print("Edit owner");
out.print("</th>");
out.print("<th>");
out.print("Delete");
out.print("</th>");

while(result.next()){
	out.print("<tr>");
	out.print("<td>");
	out.print(result.getString("cid"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("lid"));
	out.print("</td>");
	out.print("<td>");
	out.print("<form method=\"post\" action=\"aircraft.jsp\">");
	out.print("New Owner: <input type=\"text\" name=\"newowner\">");
	out.print("<input type=\"submit\" name=\"cid\" value=\"Change Owner\">");
	out.print("</form>");
	out.print("</td>");
	out.print("<td>");
	out.print("<form method=\"post\" action=\"aircraft.jsp\" onSubmit=\"alert('"
			+ result.getString("cid") + " WAS DELETED.');\">");
	out.print("<input type=\"submit\" name=\"DeletedCraft\" value=\"Delete Aircraft "
			+ result.getString("cid") + "\">");
	out.print("</form>");
	out.print("</td>");
	out.print("</tr>");
}


out.print("</table>");
out.print("<h2>Add aircraft:</h2>");
out.print(" <form method=\"post\" action=\"aircraft.jsp\">");
out.print("Owner of Aircraft: <input type=\"text\" name=\"newport\">");
out.print("<input type=\"submit\" value=\"Submit\">");
out.print("</form>");
%>


</body>
</html>