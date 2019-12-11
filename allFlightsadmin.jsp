<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>View All Flights</title>
<%@ include file="parts/header.jsp"%>
<style>
li.gah {
	margin: 1em 0;
}
</style>
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
	<h2>List of Flights:</h2>
	<h3>Most Active Flights (most tickets sold):</h3>
	<ol>
		<%
			String str = "SELECT number AS flightnum, COUNT(number) AS ticketssold FROM Ticket INNER JOIN reserves ON reserves.ticket_number = Ticket.tid GROUP BY flightnum ORDER BY ticketssold DESC;";
			Statement stmt = con.createStatement();
			ResultSet result = stmt.executeQuery(str);
			while (result.next()) {
				out.print("<li class = \"gah\"> Flight Number #" + result.getString("flightnum") + " - "
						+ result.getString("ticketssold") + " tickets sold</li>");
			}
		%>
	</ol>
	<form method="post" action="allFlightsadmin.jsp">

		Search by Airport<select name="airport">
			<option disabled selected value=null>-- select an airport --</option>
			<%
				str = "SELECT id FROM Airports;";
				//out.print(str);

				result = stmt.executeQuery(str);

				while (result.next()) {
					out.print("<option value=\"" + result.getString("id") + "\">" + result.getString("id") + "</option>");
				}
			%>
		</select> <input type="submit" value="View Flights">
	</form>


	<%
		if (request.getParameter("airport") != null) {
			try {
				String airport = request.getParameter("airport");

				str = "SELECT distinct f.number, f.type, f.fare_economy, f.depart_time, f.id, f.arrive_time, f.fare_first, p.lid AS depid, d.lid AS destlid FROM Flights f, Airports a, Departure p, Destination d WHERE f.number = p.flight_number AND f.number = d.flight_number AND (p.lid = a.id OR d.lid = a.id) AND a.id = \""
						+ airport + "\";";
				//out.print(str);

				result = stmt.executeQuery(str);

				if (result.next() == false) {
					out.print("<h3> No Flights for airport " + airport + "</h3>");
				} else {
					out.print("<h3>Flights for airport " + airport + "</h3>");
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
					out.print("</thead>");
					out.print("</tr>");

					do {
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
						out.print(result.getString("depid"));
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
		} else {

		}
	%>

</body>
</html>
