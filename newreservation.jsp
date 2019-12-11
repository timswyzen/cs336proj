<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>New Reservation...</title>
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
	%>
	<h2>New User Info.:</h2>
	<form method="post" action="newreservation.jsp">

		Username:<br> <input type="text" name="username"> <br>
		Flight:<br> <input type="text" name="flight">
		Flight type: <select name="type">
			<option>Economy</option>
			<option>First-Class</option>
		</select> <br>
		<input type="submit" value="Create New Reservation">
	</form>


	<%
	if(request.getParameter("username") != null)
		try {
			//Set up connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();

			String name = request.getParameter("username");
			String flightnum = request.getParameter("flight");
			String ftype = request.getParameter("type");
			Statement stmt = con.createStatement();
			
			//Create ticket
			String typer = "";
			String engTyper = "";
			if( ftype.equals("Economy") )
				typer = "f.fare_economy";
			else if( ftype.equals("First-Class") )
				typer = "f.fare_first";
			String str = "INSERT INTO Ticket SELECT " + flightnum + ",f.type,10,CURDATE(),(" + typer + "+10),0 FROM Flights f WHERE f.number=" + flightnum + "; ";

			PreparedStatement ps = con.prepareStatement(str);
			ps.executeUpdate();
			
			// unfortunately have to do these separately.. :\
			str = "INSERT INTO reserves SELECT \"" + name + "\",MAX(t.tid) FROM Ticket t";
			ps = con.prepareStatement(str);
			ps.executeUpdate();
			
			out.print("Reservation created successfully!");

		} catch (Exception e) {
			out.print("ERROR: " + e);
		}
	%>

</body>
</html>
