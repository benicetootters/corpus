<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="javax.naming.*,javax.sql.DataSource,org.apache.logging.log4j.*,edu.bowdoin.corpus.*,
    edu.bowdoin.nova.*,java.util.*,
    nu.xom.Element" %><%

    String bwdn = (String) session.getAttribute("bwdn");
    if(null != bwdn ) {
    	
	    Context initContext = new javax.naming.InitialContext();
		Context envContext  = (Context)initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/petium");
	    org.apache.logging.log4j.Logger logger = LogManager.getLogger("edu.bowdoin.corpus");
	 
		DataMethods dm = new DataMethods(ds,logger);
		
		Element works = dm.GetWorks();
		//System.out.println( works.toXML());
		Transformations t = new Transformations();
		String xsl = application.getRealPath("lib/xsl/Catalog.xsl");
		
		
		Element tr = t.saxTransform(works, xsl, new HashMap());
	
    
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Corpus: Catalog of Works</title>
<jsp:include page="lib/syshead.jsp" />
<style>
div.wentry {margin:2em 4em; border:2px solid #333;padding:1em;}
div.t {width:50%;display:inline-block;vertical-align:top;padding:0em 1em;}
div.o {width:50%;display:inline-block;vertical-align:top;padding:0em 1em;}
h3.rtl {margin:0em;padding:0em;font-size:1.73em;text-align:right;font-family: 'Amiri', serif;
	direction: rtl;unicode-bidi: bidi-override;}
p.rtl {margin:0em;direction: rtl;unicode-bidi: bidi-override;font-family: 'Amiri', serif;}
a.view {font-size:4em;float:left;padding:0em .4em 1em 0em;}
a.view:hover {color:gold;}
</style>
</head>
<body>
<jsp:include page="lib/pagehead.jsp" />
<%
	out.write(tr.toXML());

%>
</body>
</html>
<%
} else {
	response.sendRedirect("index.jsp");
	}
%>