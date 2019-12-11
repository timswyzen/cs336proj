<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Editing Reservations</title>
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

if (request.getParameter("newnumber") != null) {

	try {
		String s = request.getParameter("newnumber");
		String c = request.getParameter("tid").split(" ", 0)[1];

		String stre = "UPDATE Ticket SET number=\"" + s + "\" WHERE tid=" + c;
		PreparedStatement ps = con.prepareStatement(stre);
		ps.executeUpdate();

	} catch (Exception e) {
		out.print(e);
	}
}


String str = ("SELECT r.user_name, t.number, t.tid FROM reserves r, Ticket t WHERE r.ticket_number=t.tid");
Statement stmt = con.createStatement();
ResultSet result = stmt.executeQuery(str);

out.print("<table class = \"user-table\"border=\"1\">");
out.print("<tr>");
out.print("<thead>");
out.print("<th>");
out.print("Username");
out.print("</th>");
out.print("<th>");
out.print("Ticket Number");
out.print("</th>");
out.print("<th>");
out.print("Flight Number");
out.print("</th>");
out.print("<th>");
out.print("Edit Flight Number");
out.print("</th>");

while(result.next()){
	out.print("<tr>");
	out.print("<td>");
	out.print(result.getString("user_name"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("tid"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("number"));
	out.print("</td>");
	out.print("<td>");
	out.print("<form method=\"post\" action=\"editreserves.jsp\">");
	out.print("New Flight Number: <input type=\"text\" name=\"newnumber\">");
	out.print("<input type=\"submit\" name=\"tid\" value=\"Submit " + result.getString("tid") + "\">");
	out.print("</form>");
	out.print("</td>");
	out.print("</tr>");
}


out.print("</table>");
%>


</body>
</html>