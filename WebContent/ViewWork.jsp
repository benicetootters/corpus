<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="javax.naming.*,javax.sql.DataSource,org.apache.logging.log4j.*,edu.bowdoin.corpus.*,
    edu.bowdoin.nova.*,java.util.*,
    nu.xom.Element" %><%

    String bwdn = "30123"; //(String) session.getAttribute("bwdn");
    if(null != bwdn &&  !(bwdn.equals("-999"))) {
    	String wid = (String) request.getParameter("wid");
    	
	    Context initContext = new javax.naming.InitialContext();
		Context envContext  = (Context)initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/petium");
	    org.apache.logging.log4j.Logger logger = LogManager.getLogger("edu.bowdoin.corpus");
	 
		DataMethods dm = new DataMethods(ds,logger);
		
		Element works = dm.GetWorkPetia(wid);
		
		//System.out.println(works.toXML());
		Transformations t = new Transformations();
		String xsl = application.getRealPath("lib/xsl/ViewWork.xsl");
			
		Element tr = t.saxTransform(works, xsl, new HashMap());

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Tools</title>
<jsp:include page="lib/syshead.jsp" />
<script type="text/javascript">
	$(document).ready(function() {
		$( document ).tooltip();
		$("#orig").height( $(window).height() -4*$("header").height());
		$("#tran").height( $(window).height() - 4*$("header").height() );
		
		$("span.petiumo").mouseover(function() {
			var id = $(this).attr("id");
			var rid = "t"+id.substring(1);
			$("#"+rid).addClass("lit");
			if($("#tran").is(":hidden")) {
				$("#tranHeader").click();
			}
		});
		$("span.petiumo").mouseout(function() {
			var id = $(this).attr("id");
			var rid = "t"+id.substring(1);
			$("#"+rid).removeClass("lit");
		});
		
		
		$("span.petiumt").mouseover(function() {
			var id = $(this).attr("id");
			var rid = "o"+id.substring(1);
			$("#orig").animate({
				scrollTop: $("#"+rid).offset().top
			}, 80);
			
			
			$("#"+rid).addClass("lit");
			

		});
		$("span.petiumt").mouseout(function() {
			var id = $(this).attr("id");
			var rid = "o"+id.substring(1);
			$("#"+rid).removeClass("lit");
		});
		
		
	});
</script>

<style>

div#work {width:100%;overflow-y:visible;}

div#orig {width:65%;display:inline-block;vertical-align:top;text-align:right;font-family: 'Amiri', serif;
	padding:0em 1em;direction: rtl;unicode-bidi: bidi-override;font-size:2.02em;
	overflow-y:auto;}
div#tran {width:34%;display:inline-block;vertical-align:top;background-color:#eee;padding:0em 1em;}

span.petiumo:hover {color:#e00;}
span.petiumt:hover {color:#00e;}

.lit {background-color:rgba(255,0,0,.3)}
.dim {background-color:transparent;}

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