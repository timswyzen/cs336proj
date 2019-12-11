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
<h2>Edit Flights</h2>
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

if (request.getParameter("DeletedFlight") != null) {
	try {
		String s = request.getParameter("DeletedFlight").split(" ", 0)[2];
		
		String stre = "DELETE FROM Flights WHERE number=" + s;
		PreparedStatement ps = con.prepareStatement(stre);
		ps.executeUpdate();
		
		stre = "DELETE FROM Departure WHERE flight_number=" + s;
		ps = con.prepareStatement(stre);
		ps.executeUpdate();
		
		stre = "DELETE FROM Destination WHERE flight_number=" + s;
		ps = con.prepareStatement(stre);
		ps.executeUpdate();
		
		stre = "DELETE FROM Ticket WHERE number=" + s;
		ps = con.prepareStatement(stre);
		ps.executeUpdate();

	} catch (Exception e) {
		out.print(e);
	}
}

String str = "SELECT f.number, f.type, f.fare_economy, f.depart_time, f.id, f.arrive_time, f.fare_first, d.lid AS destlid, p.lid FROM Flights f, Departure p, Destination d WHERE f.number=p.flight_number AND f.number=d.flight_number ORDER BY f.number";

Statement stmt = con.createStatement();
ResultSet result = stmt.executeQuery(str);

out.print("<table border=\"1\" class = \"user-table\">");
out.print("<tr>");
out.print("<thead>");
out.print("<th>");
out.print("Flight Number");
out.print("</th>");
out.print("<th>");
out.print("Type");
out.print("</th>");
out.print("<th>");
out.print("Price (Economy)");
out.print("</th>");
out.print("<th>");
out.print("Price (First Class)");
out.print("</th>");
out.print("<th>");
out.print("Departure");
out.print("</th>");
out.print("<th>");
out.print("Depart Time");
out.print("</th>");
out.print("<th>");
out.print("Destination");
out.print("</th>");
out.print("<th>");
out.print("Arrive Time");
out.print("</th>");
out.print("<th>");
out.print("Airline");
out.print("</th>");
out.print("<th>");
out.print("Edit");
out.print("</th>");
out.print("<th>");
out.print("Delete");
out.print("</th>");
out.print("</thead>");
out.print("</tr>");

//Populate resultant table
while (result.next()) {
	out.print("<tr>");
	out.print("<td>");
	out.print(result.getString("number"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("type"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("fare_economy"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("fare_first"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("lid"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("depart_time"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("destlid"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("arrive_time"));
	out.print("</td>");
	out.print("<td>");
	out.print(result.getString("id"));
	out.print("</td>");
	out.print("<td>");
	out.print("<form method=\"post\" action=\"editflight.jsp\">");
	out.print("<input type=\"submit\" name=\"flightnum\" value=\"Edit Flight "
			+ result.getString("number") + "\">");
	out.print("</form>");
	out.print("</td>");
	out.print("<td>");
	out.print("<form method=\"post\" action=\"flight.jsp\">");
	out.print("<input type=\"submit\" name=\"DeletedFlight\" value=\"Delete Flight "
			+ result.getString("number") + "\">");
	out.print("</form>");
	out.print("</td>");
	out.print("</tr>");
}
	
out.print("</table>");
	

out.print("<br><br><form method=\"post\" action=\"addflight.jsp\">");
out.print("<input type=\"submit\" value=\"Add new flight\">");
out.print("</form>");
%>


</body>
</html>