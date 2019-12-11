<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>

<style>


</style>
</head>
<body>
<%
	    
		try {
			
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			String entity = request.getParameter("username");
			String password = request.getParameter("password");
			String entryType = request.getParameter("register");

			if (entryType == null) {
			
				//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
				String str = "SELECT user_name,passwd FROM Person WHERE user_name='"+entity+"';";
				//Run the query against the database.
				ResultSet result = stmt.executeQuery(str);
				
				if (password.length() <= 1 || entity.length() <= 1) {
					out.print("Username/password too short.");
				}
				else {
					Boolean foundUser = false;
					while (result.next()) {
						foundUser = true;
						if (result.getString("passwd").equals(password)) {
							out.print("Login successful.");
							session.setAttribute("username", entity);
						}
						else {
							out.print("Incorrect password.");
						}
					}
					if (foundUser == false) {
						out.print("User not found.");
					}
				}
				
			}
			
			else {
				String str = "SELECT user_name FROM Person WHERE user_name='" + entity + "';";
				ResultSet result = stmt.executeQuery(str);
				if (password.length() <= 5 || entity.length() <= 2) {
					out.print("Username must be at least 3 characters; password must be at least 6 characters.");
				}
				else if (result.next() != false) {
					out.print("User already exists.");
				}
				else {
					int i = stmt.executeUpdate("INSERT INTO Person(user_name,passwd) VALUES ('"+entity+"','"+password+"')");
					out.print("Account successfully created. Please log in now!");
				}
					
			}
			
			
			con.close();
			
			
		} catch (Exception e) {
			out.print(e);
		}
%>
<br>
<br>
<a href="main.jsp">Enter homepage.</a>
</body>
</html>