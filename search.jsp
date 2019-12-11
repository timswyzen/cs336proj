<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta charset="ISO-8859-1">
<title>Search</title>
<%@ include file="parts/header.jsp" %>
<style>

.flight-table {
    border: solid 1px #4CAF50;
    border-collapse: collapse;
    border-spacing: 0;
}
.flight-table thead th {
    background-color: #4CAF50;
    border: solid 1px #4CAF50;
    color: white;
    padding: 10px;
    text-align: left;
    text-shadow: 1px 1px 1px #2E6A30;
}
.flight-table tbody td {
    border: solid 1px #4CAF50;
    color: #333;
    padding: 10px;
    text-shadow: 1px 1px 1px #fff;
}

</style>

</head>
<body>
<%!
public String datetimeConv(String inString){
	String ymd = inString.substring(0,10);
	
	String hm = inString.substring(11,16);
	return ymd + " " + hm + ":00.0";
}
%>
<%
//Make sure user is signed in
if (session.getAttribute("username") == null) {
	String site = new String("main.jsp");
    response.setStatus(response.SC_MOVED_TEMPORARILY);
    response.setHeader("Location", site); 
}

try{
	//Set up connection
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	
	//Make UI for filtering form
	out.print("<form method=\"post\" action=\"search.jsp\">");
	out.print("<table>");
	out.print("<tr>");
	out.print("<td>Max price</td><td><input type=\"text\" name=\"maxprice\"></td>");
	out.print("</tr>");
	out.print("<tr>");
	out.print("<td>Departure Airport</td><td><input type=\"text\" name=\"depart\"></td>");
	out.print("<td>Arrival Airport</td><td><input type=\"text\" name=\"arrive\"></td>");
	out.print("</tr>");
	out.print("<tr>");
	out.print("<td>Round trip?<input type=\"radio\" name=\"roundtrip\" value=\"yes\"></td>");
	out.print("<td>One way?<input type=\"radio\" name=\"roundtrip\" value=\"no\"></td>");
	out.print("<td>All types?<input type=\"radio\" name=\"roundtrip\" value=\"both\" checked></td>");
	out.print("</tr>");
	out.print("<tr>");
	out.print("<td>Earliest Departure Date</td><td><input type=\"datetime-local\" name=\"earlydate\"></td>");
	out.print("<td>Latest Arrival Date</td><td><input type=\"datetime-local\" name=\"latedate\"></td>");
	out.print("</tr>");
	out.print("<tr>");
	out.print("<td>Airline ID</td><td><input type=\"text\" name=\"aid\"></td>");
	out.print("</tr>");
	out.print("<tr>");
	out.print("<td>Sort by: </td><td><select name=\"sorter\">");
	out.print("<option value=\"price\">Price</option>");
	out.print("<option value=\"depart\">Departure</option>");
	out.print("<option value=\"arrive\">Arrival</option>");
	out.print("</tr>");
	out.print("</table>");
	out.print("<input type=\"submit\" value=\"Search\">");
	out.print("</form>");

	//Build our SQL statement
	String str = "SELECT f.number, f.type, f.fare_economy, f.depart_time, f.id, f.arrive_time, f.fare_first, d.lid AS destlid, p.lid FROM Flights f, Departure p, Destination d WHERE f.number=p.flight_number AND f.number=d.flight_number";
	//for each search/filter field, add a WHERE clause
	try{
	if(request.getParameter("roundtrip").equals("yes"))
		str = str.concat(" AND f.type='round'");
	else if(request.getParameter("roundtrip").equals("no"))
		str = str.concat(" AND f.type='oneway'");
	if(request.getParameter("maxprice") != null && !request.getParameter("maxprice").isEmpty()){
		str = str.concat(" AND f.fare_economy <= " + request.getParameter("maxprice"));
	}
	if(request.getParameter("aid") != null && !request.getParameter("aid").isEmpty()){
		str = str.concat(" AND f.id LIKE \"" + request.getParameter("aid") + "\"");
	}
	if(request.getParameter("depart") != null && !request.getParameter("depart").isEmpty()){
		str = str.concat(" AND p.lid LIKE '" + request.getParameter("depart") + "'");
	}
	if(request.getParameter("arrive") != null && !request.getParameter("arrive").isEmpty()){
		str = str.concat(" AND d.lid LIKE '" + request.getParameter("arrive") + "'");
	}
	if(request.getParameter("earlydate") != null && !request.getParameter("earlydate").isEmpty()){
		str = str.concat(" AND f.depart_time > '" + datetimeConv(request.getParameter("earlydate")) + "'" );
	}
	if(request.getParameter("latedate") != null && !request.getParameter("latedate").isEmpty()){
		out.print(request.getParameter("latedate"));
		str = str.concat(" AND f.arrive_time < '" + datetimeConv(request.getParameter("latedate")) + "'" );
	}
	
	if(request.getParameter("sorter").equals("price"))
		str = str.concat(" ORDER BY f.fare_economy");
	else if(request.getParameter("sorter").equals("depart"))
		str = str.concat(" ORDER BY f.depart_time");
	else if(request.getParameter("sorter").equals("arrive"))
		str = str.concat(" ORDER BY f.arrive_time");}
	catch (Exception e){};
	
	//Run the query against the database.
	Statement stmt = con.createStatement();
	ResultSet result = stmt.executeQuery(str);
	
	//Make resultant table
	out.print("<table border=\"1\" class = \"flight-table\">");
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
	out.print("<th>");
	out.print("Book Flight");
	out.print("</th>");
	out.print("</thead>");
	out.print("</tr>");
	
	//Populate resultant table
	while (result.next()) {
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
		//reserving
		out.print("<form method=\"post\" action=\"reserve.jsp\">");
		out.print("<input type=\"submit\" name=\"Reserved\" value=\"Reserve Flight " + result.getString("number") + "\">");
		out.print("</form>");
		out.print("</td>");
		out.print("</tr>");
	}
		
	out.print("</table>");
		
	con.close();
}
catch (Exception e){
	out.print(e);
}
%>

</body>
</html>