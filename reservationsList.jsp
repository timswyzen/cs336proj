<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>View Reservations</title>
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
	
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	%>
	<h2>Reservations List:</h2>
	<form method="post" action="reservationsList.jsp">

		Search by Customer<select name="customer">
			<option disabled selected value=null>-- select a customer --</option>
			<%
			String str = "SELECT name FROM Person;" ;
			//out.print(str);
				
				Statement stmt = con.createStatement();
				ResultSet result = stmt.executeQuery(str);
				
				while(result.next()){
					out.print("<option value=\"" + result.getString("name") + "\">" + result.getString("name") +"</option>");
				}
			%>
		</select> Search by Flight<select name="flight">
			<option disabled selected value=null>-- select a flight # --</option>
			<%
			str = "SELECT number FROM Flights;" ;
			//out.print(str);
				
				stmt = con.createStatement();
				result = stmt.executeQuery(str);
				
				while(result.next()){
					out.print("<option value=\"" + result.getString("number") + "\">" + result.getString("number") +"</option>");
				}
			%>
		</select> <input type="submit" value="View Reservations">
	</form>


	<%
	if(request.getParameter("customer") != null) {
		try {
			String person = request.getParameter("customer");
			
			str = "SELECT t.tid, f.number, f.type, f.fare_economy, f.depart_time, f.id, f.arrive_time, f.fare_first, d.lid AS destlid, p.lid, t.total_fare, t.booking_fee FROM Flights f, Departure p, Destination d, reserves r, Ticket t, Person e WHERE f.number=p.flight_number AND f.number=d.flight_number AND t.number=f.number AND r.ticket_number = t.tid AND r.user_name = e.user_name AND e.name =\"" + person +  "\";";
			//out.print(str);
			
			result = stmt.executeQuery(str);
			
			if (result.next() == false) {
				out.print("<h3> No Reserved Tickets for Customer " + person + "</h3>");
			} else {
			out.print("<h3>Reserved tickets for Customer " + person + "</h3>");
			out.print("<table class = \"user-table\" border=\"1\">");
			out.print("<tr>");
			out.print("<thead>");
			out.print("<th>");
			out.print("Ticket Number");
			out.print("</th>");
			out.print("<th>");
			out.print("Flight Number");
			out.print("</th>");
			out.print("<th>");
			out.print("Type");
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
			out.print("</thead>");
			out.print("</tr>");

			do {
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("tid"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("number"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("type"));
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
				out.print("</tr>");
			} while (result.next());

			out.print("</table>");
			out.print("</div>");

			} 
			
			}catch(Exception e){
				out.print("ERROR: " + e);
			}
	}
		
		
		if(request.getParameter("flight")!= null){
			String flightid = request.getParameter("flight");
			str = "SELECT e.name, t.tid, f.number, f.type, f.fare_economy, f.depart_time, f.id, f.arrive_time, f.fare_first, d.lid AS destlid, p.lid, t.total_fare, t.booking_fee FROM Flights f, Departure p, Destination d, reserves r, Ticket t, Person e WHERE f.number=p.flight_number AND f.number=d.flight_number AND t.number=f.number AND r.ticket_number = t.tid AND r.user_name = e.user_name AND f.number =" + flightid +  ";";
			//out.print(str);
			
			result = stmt.executeQuery(str);
			
			try {
			if (result.next() == false) {
				out.print("<h3> No Reserved Tickets for Flight #" + flightid + "</h3>");
			} else {
			out.print("<h3>Reservations for Flight #" + flightid + "</h3>");
			out.print("<table class = \"user-table\" border=\"1\">");
			out.print("<tr>");
			out.print("<thead>");
			out.print("<th>");
			out.print("Customer");
			out.print("</th>");
			out.print("<th>");
			out.print("Ticket Number");
			out.print("</th>");
			out.print("<th>");
			out.print("Flight Number");
			out.print("</th>");
			out.print("<th>");
			out.print("Type");
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
			out.print("</thead>");
			out.print("</tr>");

			do {
				out.print("<tr>");
				out.print("<td>");
				out.print(result.getString("name"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("tid"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("number"));
				out.print("</td>");
				out.print("<td>");
				out.print(result.getString("type"));
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
				out.print("</tr>");
			} while (result.next());

			out.print("</table>");
			out.print("</div>");

			}


		} catch (Exception e) {
			out.print("ERROR: " + e);
		}
			
		}
	%>

</body>
</html>
