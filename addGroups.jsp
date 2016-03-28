<HTML>
<HEAD>

<TITLE>Add groups</TITLE>

<form>
  Group name:<br>
  <input type = "text" name = "groupName"><br>
  <input type = "submit" name = "Create"><br>
</form>

</HEAD>

<BODY>
<!--A simple example to demonstrate how to use JSP to 
    connect and query a database. 
    @author  Hong-Yu Zhang, University of Alberta
 -->
<%@ page import="java.sql.*" %>
<% 
if( session.getAttribute("isLogin")!=null && (Boolean)session.getAttribute("isLogin") && request.getParameter("Create") != null)
{
  	String add = (request.getParameter("groupName")).trim();
  	String userName=session.getAttribute("USERNAME").toString();
 	int group_id;
	
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
	String seq = "SELECT group_id_seq.nextval from dual";

	try{
	    stmt = conn.createStatement();
	    rset = stmt.executeQuery(seq);		
	    rset.next();
		group_id = rset.getInt(1);
    }
	catch(Exception ex){
	    out.println("<hr>" + ex.getMessage() + "<hr>");
	    return;
    }


	String cmd = "INSERT INTO groups values('"+group_id+"','"+userName+"','"+ add +"',sysdate)";
	
	try{
	    stmt = conn.createStatement();
	    stmt.executeUpdate(cmd);
	    conn.commit();
	    out.println("<p><b>Add Group Successful!</b></p>");
	    out.println("<a href=\"main.jsp\" >Go to main page</a>");
	    out.println("<a href=\"viewGroups.jsp\" >Go to view my groups</a>");
	    //out.println("<a href=\"updateGroup.jsp\" >Go to delete a friend in group</a>");

    }  
	catch(Exception ex){
	    
	    out.println("<hr>" + ex.getMessage() + "<hr>");
	    conn.rollback();//redo the operation
	    return;
    }
}
else{
	 out.println("<a href=\"login.html\">You need login first!</a>");
}
%>