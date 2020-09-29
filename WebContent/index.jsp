<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,javax.naming.*,javax.sql.DataSource,org.apache.logging.log4j.*,edu.bowdoin.auth.*,edu.bowdoin.corpus.*" %><%
    
    String uid = (String) request.getParameter("user");
	String pwd = (String) request.getParameter("dwp");
  
 	if(null != uid && null != pwd) {
 		String un = uid.substring(0, uid.indexOf("@"));
 		//System.out.println(un);
 		ADAuthenticator ba = new ADAuthenticator();
	    Map aa = ba.authenticate(un,pwd);          
        String dn = null;
        if( null != aa) {
			dn = (String) aa.get("sAMAccountName");
 			session.setAttribute("bwdn", dn);
 		  
        	Context initContext = new javax.naming.InitialContext();
        	Context envContext  = (Context)initContext.lookup("java:/comp/env");
        	DataSource ds = (DataSource)envContext.lookup("jdbc/petium");
    	    org.apache.logging.log4j.Logger logger = LogManager.getLogger("edu.bowdoin.corpus");
    	
    		DataMethods dm = new DataMethods(ds,logger);
        	
        	int user = dm.GetUserID(uid);
        	
			if(user > 0) {
	        	session.setAttribute("adm", ""+user);
    	    	response.sendRedirect("Works.jsp");
			} else {
				response.sendRedirect("Catalog.jsp");
			}
	 	} else {
	 		response.sendRedirect("index.jsp?invalid");
	 	}
 	} else {
    
%><!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Corpus login</title>
</head>
<body>
<form method="post" action="index.jsp">

Email:<br />
<input type="text" name="user" value="" />
<hr />
Password:<br />
<input type="password" name="dwp" value="" />
<br /><br />
<input type="submit" value="Log in" />

</form>
</body>
</html>
<%
 	}
    
%>