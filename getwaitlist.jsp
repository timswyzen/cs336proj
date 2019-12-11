<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Get a Waitlist</title>
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

if (request.getParameter("flightnum") != null) {

	try {
		out.print("<br>Users waitlisted for flight " + request.getParameter("flightnum") + ":");
		String str = ("SELECT w.user_name FROM waitlists w, Ticket t WHERE w.ticket_number=t.tid AND t.number=" + request.getParameter("flightnum"));
		Statement stmt = con.createStatement();
		ResultSet result = stmt.executeQuery(str);

		out.print("<table class = \"user-table\"border=\"1\">");
		out.print("<tr>");
		out.print("<thead>");
		out.print("<th>");
		out.print("Username");
		out.print("</th>");

		while(result.next()){
			out.print("<tr>");
			out.print("<td>");
			out.print(result.getString("user_name"));
			out.print("</td>");
			out.print("</tr>");
		}

	} catch (Exception e) {
		out.print(e);
	}
}
out.print("<br><br><form method=\"post\" action=\"getwaitlist.jsp\">");
out.print("Enter Flight Number: <input type=\"text\" name=\"flightnum\">");
out.print("<input type=\"submit\" value=\"Submit\">");
out.print("</form>");
%>


</body>
</html>