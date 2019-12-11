<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Cancelling...</title>
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

try{
	String s = request.getParameter("Cancelled");
	int ticketnum = Integer.parseInt(s.substring(s.lastIndexOf(' ') + 1));
	out.print("Cancelling Ticket #" + ticketnum + "\n");
	
	String str = "";
	if( s.split( "", 0 )[1].equals("Waitlist") )
	{
		str = "DELETE FROM waitlists WHERE ticket_number=" + ticketnum;
	}
	else
	{
		str = "DELETE FROM reserves WHERE ticket_number=" + ticketnum;
	}
	
	PreparedStatement ps = con.prepareStatement(str);
	ps.executeUpdate();
	
	str = "DELETE FROM Ticket WHERE tid=" + ticketnum;
	
	ps = con.prepareStatement(str);
	ps.executeUpdate();
}
catch (Exception e){
	out.print(e);
}
%>


</body>
</html>