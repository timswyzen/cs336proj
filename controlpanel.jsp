<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Control Panel</title>
<%@ include file="parts/header.jsp"%>

</head>
<body>
	<script>
		function deleteAlert(user) {
			alert(user + " was deleted.");
		}
	</script>

	<%
		//Make sure user is signed in
		if (session.getAttribute("username") == null) {
			String site = new String("main.jsp");
			response.setStatus(response.SC_MOVED_TEMPORARILY);
			response.setHeader("Location", site);
		}

		//Set up connection
		try {
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();

			//Get user's name
			String currUser = session.getAttribute("username").toString();
			String str = "SELECT adminnum, repnum FROM Person WHERE user_name = '" + currUser + "';";
			//out.print(currUser);

			Statement stmt = con.createStatement();
			ResultSet result = stmt.executeQuery(str);
			result.next();

			//check if user is admin or rep.
			int adminnum = Integer.parseInt(result.getString("adminnum"));
			int repnum = Integer.parseInt(result.getString("repnum"));

			//ADMIN CONTROL PANEL
			if (adminnum == 1) {
				out.print("<h1> ADMIN PAGE</h1>");

				//Delete User Alert
				if (request.getParameter("DeletedUser") != null) {

					try {
						String s = request.getParameter("DeletedUser");
						String byeuser = s.substring(12); //char count of "Delete User_"
						
						str = "DELETE FROM reserves WHERE user_name='" + byeuser + "';";
						PreparedStatement ps = con.prepareStatement(str);
						ps.executeUpdate();
						str = "DELETE FROM waitlists WHERE user_name='" + byeuser + "';";
						ps = con.prepareStatement(str);
						ps.executeUpdate();
						str = "DELETE FROM Person WHERE user_name='" + byeuser + "';";

						ps = con.prepareStatement(str);
						ps.executeUpdate();

					} catch (Exception e) {
						out.print(e);
					}
				}

				//User Database
				str = "SELECT * FROM Person;";
				result = stmt.executeQuery(str);
				out.print("<div>");
				out.print("<h3>User Database</h3>");
				out.print("<table class = \"user-table\"border=\"1\">");
				out.print("<tr>");
				out.print("<thead>");
				out.print("<th>");
				out.print("Username");
				out.print("</th>");
				out.print("<th>");
				out.print("Password");
				out.print("</th>");
				out.print("<th>");
				out.print("Name");
				out.print("</th>");
				out.print("<th>");
				out.print("Account #");
				out.print("</th>");
				out.print("<th>");
				out.print("Admin.");
				out.print("</th>");
				out.print("<th>");
				out.print("Rep.");
				out.print("</th>");
				out.print("<th>");
				out.print("Delete User");
				out.print("</th>");
				out.print("<th>");
				out.print("Edit User");
				out.print("</th>");
				out.print("</thead>");
				out.print("</tr>");

				while (result.next()) {
					out.print("<tr>");
					out.print("<td>");
					out.print(result.getString("user_name"));
					out.print("</td>");
					out.print("<td>");
					out.print(result.getString("passwd"));
					out.print("</td>");
					out.print("<td>");
					out.print(result.getString("name"));
					out.print("</td>");
					out.print("<td>");
					out.print(result.getString("accountnum"));
					out.print("</td>");
					out.print("<td>");
					out.print(result.getString("adminnum"));
					out.print("</td>");
					out.print("<td>");
					out.print(result.getString("repnum"));
					out.print("</td>");
					out.print("<td>");
					if(Integer.parseInt(result.getString("adminnum")) == 0){
						out.print("<form method=\"post\" action=\"controlpanel.jsp\" onSubmit=\"alert('"
								+ result.getString("user_name") + " WAS DELETED.');\">");
						out.print("<input type=\"submit\" name=\"DeletedUser\" value=\"Delete User "
								+ result.getString("user_name") + "\">");
						out.print("</form>");
						
					}
					out.print("</td>");
					out.print("<td>");
					if(Integer.parseInt(result.getString("adminnum")) == 0){
					out.print("<form method=\"post\" action=\"edituser.jsp\">");
					out.print("<input type=\"submit\" name=\"EditUser\" value=\"Edit User "
							+ result.getString("user_name") + "\">");
					out.print("</form>");
					}
					out.print("</td>");
					out.print("</tr>");
				}
				out.print("</table>");
				out.print("<form method=\"post\" action=\"newuser.jsp\"  style = \"margin: 10px;\">");
				out.print("<input type=\"submit\" name=\"newUser\" value=\"New User\">");
				out.print("</form>");
				out.print("</div>");

				out.print("<h3>Other Admin. Abilities</h3>");
				out.print("<form method=\"post\" action=\"salesReport.jsp\">");
				out.print(
						"<input type=\"submit\" name=\"saleReport\" value=\"View Sales Report\" style = \"margin: 10px;\">");
				out.print("</form>");
				out.print("<form method=\"post\" action=\"reservationsList.jsp\">");
				out.print(
						"<input type=\"submit\" name=\"saleReport\" value=\"View List of Reservations\" style = \"margin: 10px;\">");
				out.print("</form>");
				out.print("<form method=\"post\" action=\"allFlightsadmin.jsp\">");
				out.print(
						"<input type=\"submit\" name=\"allFlights\" value=\"View Flight Information\" style = \"margin: 10px;\">");
				out.print("</form>");

				//REP CONTROL PANEL
			} 
			if (repnum == 1) {
				out.print("<h1> REP. PAGE</h1>");
				out.print("<form method=\"post\" action=\"newreservation.jsp\"  style = \"margin: 10px;\">");
				out.print("<input type=\"submit\" name=\"newReserv\" value=\"New Reservation\">");
				out.print("</form>");
				
				out.print("<form method=\"post\" action=\"aircraft.jsp\"  style = \"margin: 10px;\">");
				out.print("<input type=\"submit\" name=\"aircraft\" value=\"Edit Aircraft\">");
				out.print("</form>");
				
				out.print("<form method=\"post\" action=\"airport.jsp\"  style = \"margin: 10px;\">");
				out.print("<input type=\"submit\" name=\"airport\" value=\"Edit Airports\">");
				out.print("</form>");
				
				out.print("<form method=\"post\" action=\"flight.jsp\"  style = \"margin: 10px;\">");
				out.print("<input type=\"submit\" name=\"flight\" value=\"Edit Flights\">");
				out.print("</form>");
				
				out.print("<form method=\"post\" action=\"editreserves.jsp\"  style = \"margin: 10px;\">");
				out.print("<input type=\"submit\" name=\"flight\" value=\"Edit Reservations\">");
				out.print("</form>");
				
				out.print("<form method=\"post\" action=\"getwaitlist.jsp\"  style = \"margin: 10px;\">");
				out.print("<input type=\"submit\" name=\"flight\" value=\"Get a Waitlist\">");
				out.print("</form>");
			}

			//USER (BASE) CONTROL PANEL

			//List all flights purchased
			str = "SELECT t.tid, f.number, f.type, f.fare_economy, f.depart_time, f.id, f.arrive_time, f.fare_first, d.lid AS destlid, p.lid, t.total_fare, t.booking_fee FROM Flights f, Departure p, Destination d, reserves r, Ticket t WHERE f.number=p.flight_number AND f.number=d.flight_number AND t.number=f.number AND r.ticket_number = t.tid AND r.user_name = \""
					+ session.getAttribute("username") + "\"";
			result = stmt.executeQuery(str);

			if (result.next() == false) {
				out.print("<h3> No Reserved Tickets </h3>");
			} else {
				//Show Flights Joined

				out.print("<h3>Reserved tickets</h3>");
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
				out.print("Cancel Flight");
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
					if( Float.parseFloat(result.getString("total_fare")) - Float.parseFloat(result.getString("booking_fee")) == Float.parseFloat(result.getString("fare_economy")) )
						out.print(result.getString("fare_economy"));
					out.print("</td>");
					out.print("<td>");
					if( Float.parseFloat(result.getString("total_fare")) - Float.parseFloat(result.getString("booking_fee")) == Float.parseFloat(result.getString("fare_first")) )
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
					//cancelling
					out.print("<form method=\"post\" action=\"cancel.jsp\">");
					out.print("<input type=\"submit\" name=\"Cancelled\" value=\"Cancel Ticket "
							+ result.getString("tid") + "\">");
					out.print("</form>");
					out.print("</td>");
					out.print("</tr>");
				} while (result.next());

				out.print("</table>");
				out.print("</div>");

			}

			//WAITLIST
			//List all flights purchased
			str = "SELECT t.tid, f.number, f.type, f.fare_economy, f.depart_time, f.id, f.arrive_time, f.fare_first, d.lid AS destlid, p.lid, t.total_fare, t.booking_fee FROM Flights f, Departure p, Destination d, waitlists r, Ticket t WHERE f.number=p.flight_number AND f.number=d.flight_number AND t.number=f.number AND r.ticket_number = t.tid AND r.user_name = \""
					+ session.getAttribute("username") + "\"";
			result = stmt.executeQuery(str);

			//Show Flights Joined
			if (result.next() == false) {
				out.print("<h3>No Waitlisted Tickets</h3>");
			} else {

				out.print("<h3>Waitlisted tickets</h3>");
				out.print("<div>");
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
				out.print("Cancel Flight");
				out.print("</th>");
				out.print("</thead>");
				out.print("</tr>");

				do{
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
					if( Float.parseFloat(result.getString("total_fare")) - Float.parseFloat(result.getString("booking_fee")) == Float.parseFloat(result.getString("fare_economy")) )
						out.print(result.getString("fare_economy"));
					out.print("</td>");
					out.print("<td>");
					if( Float.parseFloat(result.getString("total_fare")) - Float.parseFloat(result.getString("booking_fee")) == Float.parseFloat(result.getString("fare_first")) )
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
					//cancelling
					out.print("<form method=\"post\" action=\"cancel.jsp\">");
					out.print("<input type=\"submit\" name=\"Cancelled\" value=\"Cancel Waitlist "
							+ result.getString("tid") + "\">");
					out.print("</form>");
					out.print("</td>");
					out.print("</tr>");
				} while(result.next());

				out.print("</table>");
				out.print("</div>");
			}
			con.close();

		} catch (Exception E) {
			out.print(E);
		}
	%>
</body>