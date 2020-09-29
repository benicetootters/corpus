<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="javax.naming.*,javax.sql.DataSource,org.apache.logging.log4j.*,edu.bowdoin.corpus.*,
    edu.bowdoin.nova.*,java.util.*,
    nu.xom.Element" %><%

    String adm = (String) session.getAttribute("adm");
    if(null != adm && !(adm.equals("-999"))) {
    	
    Context initContext = new javax.naming.InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/petium");
    org.apache.logging.log4j.Logger logger = LogManager.getLogger("edu.bowdoin.corpus");

	DataMethods dm = new DataMethods(ds,logger);
	
	Element works = dm.GetWorks();
	Element langs = dm.GetLanguages();
	Transformations t = new Transformations();
	String xsl = application.getRealPath("lib/xsl/works.xsl");
	
	
	Element tr = t.saxTransform(works, xsl, new HashMap());
	
	xsl = application.getRealPath("lib/xsl/addWork.xsl");
	HashMap<String,String> params = new HashMap<String,String>(1);
	params.put("uid", adm);
	Element aw = t.saxTransform(langs, xsl, params);
	
	
    
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Tools</title>
<jsp:include page="lib/syshead.jsp" />
<script type="text/javascript">
	$(document).ready(function() {
		$("#wlist").height( $(window).height() * .5);
		
		
	});
</script>
</head>
<body>
<jsp:include page="lib/pagehead.jsp" />
<%
	out.write(tr.toXML());
	out.write("<hr />");
	out.write(aw.toXML());
%>
</body>
</html>
<%
} else {
	response.sendRedirect("index.jsp");
	}
%>