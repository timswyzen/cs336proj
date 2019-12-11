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

		String number = request.getParameter("flightnum").split(" ",0)[3];
		String id = request.getParameter("id");
		String type = request.getParameter("type");
		String depart_time = request.getParameter("depart_time");
		String arrive_time = request.getParameter("arrive_time");
		String fare_first = request.getParameter("fare_first");
		String fare_economy = request.getParameter("fare_economy");
		String depart_lid = request.getParameter("lid");
		String dest_lid = request.getParameter("destlid");
		
		Statement stmt = con.createStatement();
		String str = "UPDATE Flights SET type=\"" + type + "\", id=\"" + id + "\", depart_time=\"" + depart_time + "\", arrive_time=\"" + arrive_time + "\", fare_first=" + fare_first + ", fare_economy=" + fare_economy + " WHERE number=" + number;

		PreparedStatement ps = con.prepareStatement(str);
		ps.executeUpdate();
		
		str = "UPDATE Destination SET lid=\"" + dest_lid + "\" WHERE flight_number=" + number;
		ps = con.prepareStatement(str);
		ps.executeUpdate();
		
		str = "UPDATE Departure SET lid=\"" + depart_lid + "\" WHERE flight_number=" + number;
		ps = con.prepareStatement(str);
		ps.executeUpdate();
		
		out.print("Successfully updated this flight.");

	} catch (Exception e) {
		out.print("ERROR: " + e);
	}

if(request.getParameter("flightnum") != null)
	try {
		//Set up connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		String name = request.getParameter("flightnum").split(" ",0)[2];
		String str = "SELECT f.number,f.id,f.type,f.depart_time,f.arrive_time,f.fare_first,f.fare_economy,d.lid AS destlid,p.lid FROM Flights f, Departure p, Destination d WHERE f.number=p.flight_number AND f.number=d.flight_number AND f.number=" + name;
		Statement stmt = con.createStatement();
		ResultSet result = stmt.executeQuery(str);
		result.next();
		
		out.print("<h2>Editing Flight " + result.getString("number") + "</h2>");
		out.print("<form method=\"post\" action=\"editflight.jsp\">  Airline: <input type=\"text\" name=\"id\" value=\"" + result.getString("id") + " \">");
		out.print("<br>Type: <select name=\"type\" value=\"" + result.getString("type") + " \"><option>round</option><option>oneway</option></select>");
		out.print("<br>Depart time (keep formatting): <input type=\"text\" name=\"depart_time\" value=\"" + result.getString("depart_time") + " \">");
		out.print("<br>Arrive time (keep formatting): <input type=\"text\" name=\"arrive_time\" value=\"" + result.getString("arrive_time") + " \">");
		out.print("<br>First-Class Fare: <input type=\"text\" name=\"fare_first\" value=\"" + result.getString("fare_first") + " \">");
		out.print("<br>Economy Fare: <input type=\"text\" name=\"fare_economy\" value=\"" + result.getString("fare_economy") + " \">");
		out.print("<br>Depart Airport: <input type=\"text\" name=\"lid\" value=\"" + result.getString("lid") + " \">");
		out.print("<br>Arrive Airport: <input type=\"text\" name=\"destlid\" value=\"" + result.getString("destlid") + " \">");
		out.print("<br><input type=\"submit\" name=\"flightnum\" value=\"Submit for Flight " + name + "\">");
		out.print("</form>");

	} catch (Exception e) {
		out.print("ERROR: " + e);
	}
%>

</body>
</html>
