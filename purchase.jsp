<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Purchasing...</title>
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
String[] splitt = s.split(" ",0);

try{
	String typer = "";
	if( splitt[1].equals("First-Class") )
		typer = "f.fare_first";
	else if( splitt[1].equals("Economy") )
		typer = "f.fare_economy";
	String str = "INSERT INTO Ticket SELECT " + splitt[4] + ",f.type,10,CURDATE(),(" + typer + "+10),0 FROM Flights f WHERE f.number=" + splitt[4] + ";";

	PreparedStatement ps = con.prepareStatement(str);
	ps.executeUpdate();
	
	if( splitt[0].equals("Waitlist")){
		str = "INSERT INTO waitlists SELECT \"" + session.getAttribute("username") + "\",MAX(t.tid) FROM Ticket t";
		ps = con.prepareStatement(str);
		ps.executeUpdate();
	}
	else{
		str = "INSERT INTO reserves SELECT \"" + session.getAttribute("username") + "\",MAX(t.tid) FROM Ticket t";
		ps = con.prepareStatement(str);
		ps.executeUpdate();
	}
	out.print("Purchase complete!");

}
catch (Exception e){
	out.print(e);
}


%>

</body>