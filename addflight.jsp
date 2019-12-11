<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Editing Flight...</title>
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

if(request.getParameter("id") != null)
	try {
		//Set up connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		String id = request.getParameter("id");
		String type = request.getParameter("type");
		String depart_time = request.getParameter("depart_time");
		String arrive_time = request.getParameter("arrive_time");
		String fare_first = request.getParameter("fare_first");
		String fare_economy = request.getParameter("fare_economy");
		String depart_lid = request.getParameter("lid");
		String dest_lid = request.getParameter("destlid");
		
		Statement stmt = con.createStatement();
		String str = "INSERT INTO Flights SELECT (MAX(number)+1),'" + id + "','" + type + "','" + depart_time + "','" + arrive_time + "'," + fare_first + "," + fare_economy + " FROM Flights";

		PreparedStatement ps = con.prepareStatement(str);
		ps.executeUpdate();
		
		str = "INSERT INTO Destination SELECT 0,(MAX(number)),\"" + dest_lid + "\" FROM Flights";
		ps = con.prepareStatement(str);
		ps.executeUpdate();
		
		str = "INSERT INTO Departure SELECT 0,(MAX(number)),\"" + depart_lid + "\" FROM Flights";
		ps = con.prepareStatement(str);
		ps.executeUpdate();
		
		out.print("Successfully added this flight.");

	} catch (Exception e) {
		out.print("ERROR: " + e);
	}

//Set up connection
ApplicationDB db = new ApplicationDB();
Connection con = db.getConnection();

out.print("<h2>Adding flight</h2>");
out.print("<form method=\"post\" action=\"addflight.jsp\">  Airline: <input type=\"text\" name=\"id\">");
out.print("<br>Type: <select name=\"type\"><option>round</option><option>oneway</option></select>");
out.print("<br>Depart time (keep formatting): <input type=\"text\" name=\"depart_time\" value=\"YYYY-MM-DD HH:MM:SS\">");
out.print("<br>Arrive time (keep formatting): <input type=\"text\" name=\"arrive_time\" value=\"YYYY-MM-DD HH:MM:SS\">");
out.print("<br>First-Class Fare: <input type=\"text\" name=\"fare_first\" value=\"0.0\">");
out.print("<br>Economy Fare: <input type=\"text\" name=\"fare_economy\" value=\"0.0\">");
out.print("<br>Depart Airport: <input type=\"text\" name=\"lid\">");
out.print("<br>Arrive Airport: <input type=\"text\" name=\"destlid\">");
out.print("<br><input type=\"submit\" value=\"Submit\">");
out.print("</form>");


%>

</body>
</html>
