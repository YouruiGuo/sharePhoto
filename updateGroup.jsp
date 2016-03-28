<HTML>
<HEAD>

<TITLE>Update group</TITLE>



</HEAD>

<BODY>
<!--A simple example to demonstrate how to use JSP to 
    connect and query a database. 
    @author  Hong-Yu Zhang, University of Alberta
 -->
<%@ page import="java.sql.*" %>
<% 
if( session.getAttribute("isLogin")!=null && (Boolean)session.getAttribute("isLogin"))
{

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


	////////////////////get the group lists
	String sql = "SELECT group_name FROM groups where user_name ='"+userName+"'";

	try{
	    stmt = conn.createStatement();
	    rset = stmt.executeQuery(sql);	
	    %>	

<form>
<td>groups:</td>
<td><select name = "groups" id = "groups">
	<%
	while(rset.next()){
	%>
	<option value = "<%=rset.getString(1)%>"><%=rset.getString(1)%></option>
	<%}%>
</select></td>
<input type = "submit" value = "ok" name = "group">
</form>


<%    }
	catch(Exception ex){
	    out.println("<br>" + ex.getMessage() + "<br>");
	    return;
    }


    /////////////////get user lists under selected group
    if(request.getParameter("group") != null){
    	//String group_name = request.getAttribute("groups").toString();
    	session.setAttribute("Mygroup",request.getParameter("groups"));
    	//out.println(request.getParameter("groups"));
    	response.sendRedirect("deleteFriend.jsp");

	}

}
else{
	 out.println("<a href=\"login.html\">You need login first!</a>");
}
%>