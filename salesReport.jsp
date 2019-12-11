<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Sales Report</title>
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
	<h2>Sales Report:</h2>
	<h3>
		Top Customer: 
		<%
		Statement stmt = con.createStatement();

		String str = "SELECT user_name, SUM(total_fare) AS money FROM Ticket INNER JOIN reserves ON reserves.ticket_number = Ticket.tid GROUP BY reserves.user_name ORDER BY sum(total_fare) DESC LIMIT 1;";
		ResultSet result = stmt.executeQuery(str);
		
		result.next();
		
		String money = result.getString("money");
		str = "SELECT name FROM Person where user_name = \"" + result.getString("user_name") + "\";";
		result = stmt.executeQuery(str);
		result.next();
		
		String name = result.getString("name");
		
		out.print(name);	%>
	</h3>
	<p>Generated the most total revenue: $<%=money%></p>
	
	<form method="post" action="salesReport.jsp">
		Sales By Month:<select name="month">
			<option disabled selected value=null>-- select a month --</option>
			<option value=1>Jan.</option>
			<option value=2>Feb.</option>
			<option value=3>Mar.</option>
			<option value=4>Apr.</option>
			<option value=5>May</option>
			<option value=6>Jun.</option>
			<option value=7>Jul.</option>
			<option value=8>Aug.</option>
			<option value=9>Sept.</option>
			<option value=10>Oct.</option>
			<option value=11>Nov.</option>
			<option value=12>Dec.</option>
		</select> Revenue by Customer<select name="customer">
			<option disabled selected value=null>-- select a customer --</option>
			<%
				str = "SELECT user_name FROM Person;";
				//out.print(str);

				result = stmt.executeQuery(str);

				while (result.next()) {
					out.print("<option value=\"" + result.getString("user_name") + "\">" + result.getString("user_name")
							+ "</option>");
				}
			%>
		</select> Revenue by Flight<select name="flight">
			<option disabled selected value=null>-- select a flight # --</option>
			<%
				str = "SELECT number FROM Flights;";
				//out.print(str);

				stmt = con.createStatement();
				result = stmt.executeQuery(str);

				while (result.next()) {
					out.print("<option value=\"" + result.getString("number") + "\">" + result.getString("number")
							+ "</option>");
				}
			%>
		</select> Revenue by Airline<select name="airline">
			<option disabled selected value=null>-- select an airline--</option>
			<%
				str = "SELECT id FROM Airlines;";
				//out.print(str);

				stmt = con.createStatement();
				result = stmt.executeQuery(str);

				while (result.next()) {
					out.print("<option value=\"" + result.getString("id") + "\">" + result.getString("id") + "</option>");
				}
			%>
		</select> <input style="margin: 5px;" type="submit"
			value="Generate Sales Report">
	</form>

	<%
		if (request.getParameter("month") != null)
			try {

				int month = Integer.parseInt(request.getParameter("month"));
				//Set up connection

				String monthstr = "";

				if (month == 1) {
					monthstr = "January";
				} else if (month == 2) {
					monthstr = "February";
				} else if (month == 3) {
					monthstr = "March";
				} else if (month == 4) {
					monthstr = "April";
				} else if (month == 5) {
					monthstr = "May";
				} else if (month == 6) {
					monthstr = "June";
				} else if (month == 7) {
					monthstr = "July";
				} else if (month == 8) {
					monthstr = "August";
				} else if (month == 9) {
					monthstr = "September";
				} else if (month == 10) {
					monthstr = "October";
				} else if (month == 11) {
					monthstr = "November";
				} else if (month == 12) {
					monthstr = "December";
				}

				str = "SELECT COUNT(*) AS numtickets, SUM(booking_fee) AS profit, SUM(total_fare) AS totalsales FROM Ticket WHERE EXTRACT(MONTH FROM issue_date) ="
						+ month + ";";
				//out.print(str);

				stmt = con.createStatement();
				result = stmt.executeQuery(str);

				result.next();
				if (result.getString("totalsales") != null) {
	%>
	<h3><%=monthstr %> Sales Report</h3>
	<p>
		<b> Number of Tickets Sold in <%=monthstr%>:
		</b>
		<%=result.getString("numtickets")%>
	</p>
	<p>
		<b> Net Profit Made: </b> $<%=result.getString("profit")%>
	</p>

	<p>
		<b> Total Revenue Generated: </b> $<%=result.getString("totalsales")%>
	</p>


	<%
		} else {
	%>
	<h3>No data exists for selected month.</h3>
	<%
		}

			} catch (Exception e) {
				String error = e.toString();
				System.out.println("ERROR: " + e);
			}
	
	%> 
	<h3>--------------------------------</h3>
	<h3>Overall Report Info:</h3>
	<%

		if (request.getParameter("customer") != null)
			try {
				//out.print(request.getParameter("customer"));

				str = "SELECT SUM(total_fare) AS revenue FROM Ticket, reserves WHERE reserves.ticket_number = Ticket.tid AND reserves.user_name =\""
						+ request.getParameter("customer") + "\";";
				//out.print(str);SELECT SUM(total_fare) FROM Ticket, reserves WHERE reserves.ticket_number = Ticket.tid AND reserves.user_name ="ezascake" LIMIT 0, 100

				stmt = con.createStatement();
				result = stmt.executeQuery(str);

				result.next();

				if (result.getString("revenue") != null) {
	%>
	<b> Total Revenue Generated by <%=request.getParameter("customer")%>:
	</b>
	<p>
		$<%=result.getString("revenue")%>
	</p>

	<%
		} else {
	%>
	<h3>Selected customer has not generated any revenue.</h3>
	<%
		}

			} catch (Exception e) {
				String error = e.toString();
				System.out.println("ERROR: " + e);
			}

		if (request.getParameter("flight") != null)
			try {
				//out.print(request.getParameter("flight"));

				str = "SELECT SUM(total_fare) AS revenue FROM Ticket, Flights WHERE Ticket.number = Flights.number AND Flights.number =\""
						+ request.getParameter("flight") + "\";";
				//out.print(str);
				stmt = con.createStatement();
				result = stmt.executeQuery(str);

				result.next();

				if (result.getString("revenue") != null) {
	%>
	<h3>--------------------------------</h3>
	<b> Total Revenue Generated by Flight #<%=request.getParameter("flight")%>:
	</b>
	<p>
		$<%=result.getString("revenue")%>
	</p>

	<%
		} else {
	%>
	<h3>Selected Flight has not generated any revenue.</h3>
	<%
		}

			} catch (Exception e) {
				String error = e.toString();
				System.out.println("ERROR: " + e);
			}

		if (request.getParameter("airline") != null)
			try {
				//out.print(request.getParameter("airline"));

				str = "SELECT SUM(total_fare) AS revenue FROM Ticket, Flights WHERE Ticket.number = Flights.number AND Flights.id =\""
						+ request.getParameter("airline") + "\";";
				//out.print(str);
				stmt = con.createStatement();
				result = stmt.executeQuery(str);

				result.next();

				if (result.getString("revenue") != null) {
	%>
	<h3>--------------------------------</h3>
	<b> Total Revenue Generated by <%=request.getParameter("airline")%>:
	</b>
	<p>
		$<%=result.getString("revenue")%>
	</p>

	<%
		} else {
	%>
	<h3>Selected Airline has not generated any revenue.</h3>
	<%
		}

			} catch (Exception e) {
				String error = e.toString();
				System.out.println("ERROR: " + e);
			}
	%>

</body>
</html>