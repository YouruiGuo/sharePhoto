<HTML>
<HEAD>

<TITLE>update</TITLE>


</HEAD>

<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>

<% 
	String userName=session.getAttribute("USERNAME").toString();
 	int group_id = 0;
	
  	Connection conn = null;
  	Statement stmt = null;
	ResultSet rset;	

  	String driverName = "oracle.jdbc.driver.OracleDriver";
  	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

	try{
	    //load and register the driver
	    Class drvClass = Class.forName(driverName); 
	    DriverManager.registerDriver((Driver) drvClass.newInstance());
	 }
	catch(Exception ex){
	   out.println("<hr>" + ex.getMessage() + "<hr>");
	   return;
	}
	 
	try{
	    //establish the connection 
	    conn = DriverManager.getConnection(dbstring,"jni1","c3912016");
	    conn.setAutoCommit(false);
	    stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,	
	      ResultSet.CONCUR_UPDATABLE);
	}
	catch(Exception ex){
	    
	    out.println("<hr>" + ex.getMessage() + "<hr>");
	    return;
	}

	String s1 = "select group_id from groups where group_name = '"+session.getAttribute("Mygroup")+"'";
		try{
		//out.println("<br>"+s1+"<br>");
		    stmt = conn.createStatement();
		    rset = stmt.executeQuery(s1);		
		    rset.next();
			group_id = rset.getInt(1);
	    }
		catch(Exception ex){
		    out.println("<hr>" + ex.getMessage() + "<hr>");
		    return;
	    }



    	String sql1 = "SELECT friend_id FROM group_lists where group_id = '"+group_id+"'";

	try{
	    stmt = conn.createStatement();
	    rset = stmt.executeQuery(sql1);	
	    %>	


<td>users:</td>
	<%
	while(rset.next()){
	%>
	<li><%=rset.getString(1)%></li>
	<%}%>
<form>
	user name:<br>
	<input type = "text" name = "user">
<input type = "submit" value = "delete"  name = "action">
<input type = "submit" value = "add"  name = "action">
</form>
	<%}
 	catch(Exception ex){
	    out.println("<hr>" + ex.getMessage() + "<hr>");
	    return;
    }

    //String action = request.getParameter("submit");
    //out.println(action);
	/////////////////////delete the user from group_lists
    if("delete".equals(request.getParameter("submit"))){

    	String s = "delete from group_lists where friend_id = '"+(request.getParameter("user")).trim()+"'";
		out.println(s);
		try{
			out.println(s);
		    stmt = conn.createStatement();
		    rset = stmt.executeQuery(s);		
			conn.commit();
	   		out.println("<p><b>Remove a Friend Successful!</b></p>");
	    	out.println("<a href=\"main.jsp\" >Go to main page</a>");
	    }
		catch(Exception ex){
		    out.println("<hr>" + ex.getMessage() + "<hr>");
	    	conn.rollback();//redo the operation
	    	return;
	    }
	}
	else{
		out.println("Aaaaaa");
	}


	/////////////////add user
	if ("add".equals(request.getParameter("submit"))) {

	String cmd = "INSERT INTO group_lists VALUES ('"+ group_id +"','"+ (request.getParameter("user")).trim() +"',sysdate,null)";

	try{
	out.println(cmd);
	    stmt = conn.createStatement();
	    stmt.executeUpdate(cmd);
	    conn.commit();
	    out.println("<p><b>Add Friend to Group Successful!</b></p>");
	    out.println("<a href=\"main.jsp\" >Go to main page</a>");

    }  
	catch(Exception ex){
	    
	    out.println("<hr>" + ex.getMessage() + "<hr>");
	    conn.rollback();//redo the operation
	    return;
    }
	}
	    else{
    	out.println("bbbbbb");
	}
%>
