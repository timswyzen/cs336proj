<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Reserving...</title>
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

String s = request.getParameter("Reserved");
int reservedFlightNum = Integer.parseInt(s.substring(s.lastIndexOf(' ') + 1));
out.print("Checking for a ticket for Flight " + reservedFlightNum + "\n");
	
//Total seats for economy
String str = "SELECT COUNT(*) AS ct FROM Seats s, Uses u WHERE u.flight_number=" + reservedFlightNum + " AND s.cid=u.cid AND s.class=\"economy\"";
		
Statement stmt = con.createStatement();
ResultSet result = stmt.executeQuery(str);
result.next();
int totalEconomy = result.getInt("ct");

//Used seats for economy
str = "SELECT COUNT(*) AS ct FROM Ticket t, Flights f WHERE t.number=" + reservedFlightNum + " AND t.booking_fee = f.fare_economy";
result = stmt.executeQuery(str);
result.next();
int usedEconomy = result.getInt("ct");
int econAvailable = totalEconomy-usedEconomy;

out.print("<br><br>Economy seats available:<br>" + econAvailable);
if( econAvailable > 0 ){
	out.print("<form method=\"post\" action=\"purchase.jsp\">");
	out.print("<input type=\"submit\" name=\"Reserved\" value=\"Purchase Economy for Flight " + reservedFlightNum + "\">");
	out.print("</form>");
}
else{
	out.print("<form method=\"post\" action=\"purchase.jsp\">");
	out.print("<input type=\"submit\" name=\"Reserved\" value=\"Waitlist Economy for Flight " + reservedFlightNum + "\">");
	out.print("</form>");
}

//Total seats for firstclass
str = "SELECT COUNT(*) AS ct FROM Seats s, Uses u WHERE u.flight_number=" + reservedFlightNum + " AND s.cid=u.cid AND s.class=\"first\"";
		
stmt = con.createStatement();
result = stmt.executeQuery(str);
result.next();
int totalFirst = result.getInt("ct");

//Used seats for firstclass
str = "SELECT COUNT(*) AS ct FROM Ticket t, Flights f WHERE t.number=" + reservedFlightNum + " AND t.booking_fee = f.fare_first";
result = stmt.executeQuery(str);
result.next();
int usedFirst = result.getInt("ct");
int firstAvailable = totalFirst-usedFirst;

out.print("<br><br>First class seats available:<br>" + firstAvailable);
if( firstAvailable > 0 ){
	out.print("<form method=\"post\" action=\"purchase.jsp\">");
	out.print("<input type=\"submit\" name=\"Reserved\" value=\"Purchase First-Class for Flight " + reservedFlightNum + "\">");
	out.print("</form>");
}
else{
	out.print("<form method=\"post\" action=\"purchase.jsp\">");
	out.print("<input type=\"submit\" name=\"Reserved\" value=\"Waitlist First-Class for Flight " + reservedFlightNum + "\">");
	out.print("</form>");
}

//look how many first class seats we have
//if > 0, option to purchase. else, add to wait list button

//look how many economy seats we have
//if > 0, option to purchase. else, add to wait list button

%>

</body>