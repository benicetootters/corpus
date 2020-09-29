<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="javax.naming.*,javax.sql.DataSource,org.apache.logging.log4j.*,edu.bowdoin.corpus.*,
    edu.bowdoin.nova.*,java.util.*,
    nu.xom.Element" %><%

    String adm = (String) session.getAttribute("adm");
    if(null != adm && !(adm.equals("-999"))) {
    	String wid = (String) request.getParameter("wid");
    	String ne = (String) request.getParameter("ne");
    	
    Context initContext = new javax.naming.InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/petium");
    org.apache.logging.log4j.Logger logger = LogManager.getLogger("edu.bowdoin.corpus");

	DataMethods dm = new DataMethods(ds,logger);
	
	Element works = dm.GetWorkPetia(wid);
	
	//System.out.println(works.toXML());
	Transformations t = new Transformations();
	String xsl = application.getRealPath("lib/xsl/work.xsl");
		
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
		$("#por").val( $("#tbox tr").length);
		
		var ltr = $("#tbox tr").last();
		
		$("#work").height( $(window).height() - ($("header").height() + $("#edits").height()+30));
		
<%
	// if add a new entry, scroll to bottom of pane
	if(ne !=null) {
%>
		$("#work").animate({
			scrollTop: $("#work").get(0).scrollHeight
		}, 980);
<%
	}
%>
		var lbt = $(ltr).find("td:nth-child(1)").html();
		var lat = $(ltr).find("td:nth-child(2)").html();
		
		$("#bt option").each( function() {
			if($(this).val() == lbt) {
				$(this).attr("selected","selected");
			}
		});
		
		$("#ali option").each( function() {
			if($(this).val() == lat) {
				$(this).attr("selected","selected");
			}
		});
		
		
		$("td.tak").click( function() {
			
			var tr = $(this).parent();
			var pid = $(this).attr("data");
			
			
			$("#epid").val(pid);
			$("#newBox").hide();
			$("#editBox").show();
			
			var ebt = $(tr).find("td:nth-child(1)").html();
			var eali = $(tr).find("td:nth-child(2)").html();
			
			
			$("#ebt option").each( function() {
				if($(this).val() == ebt) {
					$(this).attr("selected","selected");
				}
			});
			
			$("#eali option").each( function() {
				if($(this).val() == eali) {
					$(this).attr("selected","selected");
				}
			});
			
			$("#eorig").val($(tr).find("td:nth-child(3) span").html() );
			$("#etran").val($(tr).find("td:nth-child(4) span").html() );
			$("#wpor").val($(tr).find("td:nth-child(5)").html() );
			$("#epor").val($(tr).find("td:nth-child(5)").html() );
			
		});
		
		$("#canc").click( function() {
			$("#newBox").show();
			$("#editBox").hide();
		});
		
		$("#rem").click( function() {
			if( confirm("Are you SURE you want to remove this entry?") ) {
				window.location.href="mvc.jsp?m=removePetium&pid="+$("#epid").val()+"&wid=<%=wid%>";
			}
		});
		
		$("#deets").click( function() {
			$("#edeets").dialog({width: "90%",
					   maxWidth: "768px"});
		});
		
		
	});
</script>
</head>
<body>
<jsp:include page="lib/pagehead.jsp" />
<%
	out.write(tr.toXML());
%>

	<div id="edits">
		<fieldset id="newBox">
			<legend>New Entry</legend>
			<form method="post" action="mvc.jsp" >
				<input type="hidden" name="m" value="addPetium" />
				<input type="hidden" name="wid" value="<%=wid%>" />
			
			<table id="newe">
				<tbody>
					<tr>
						<td>Block Type</td>
						<td>
							<select id="bt" name="bt">
								<option value="inline">inline</option>
								<option value="p">new line</option>
								<option value="h1">Heading 1</option>
								<option value="h2">Heading 2</option>
								<option value="h3">Heading 3</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Alignment</td>
						<td>
							<select id="ali" name="ali">
								<option value="default">default</option>
								<option value="left">left</option>
								<option value="center">center</option>
								<option value="right">right</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Original</td>
						<td>
							<input type="text" name="orig" size="100" class="rtl" />
						</td>
					</tr>
					<tr>
						<td>Translation</td>
						<td>
							<input type="text" name="tran" size="100" />
						</td>
					</tr>
					<tr>
						<td>Order</td>
						<td>
							<input name="por" id="por" type="number" min="1" step="1" size="3" style="width:45px;" value="999" />
						</td>
					</tr>
					<tr>
						<td>Notes/References</td>
						<td>
							<textarea name="notes" rows="3" cols="50"> </textarea>
						</td>
					</tr>
				</tbody>
			</table>
			
				<input type="reset" value="Cancel" />
				
				<input type="submit" value="Add Entry" />
			</form>	
		
		</fieldset>


		<fieldset id="editBox">
			<legend>Update Entry</legend>
			<form method="post" action="mvc.jsp" >
				<input type="hidden" name="m" value="editPetium" />
				<input type="hidden" name="wid" value="<%=wid%>" />
				<input type="hidden" id="epid" name="pid" value="" />
				<input type="hidden" id="wpor" name="wpor" value="" />
			
			<table id="edite">
				<tbody>
					<tr>
						<td>Block Type</td>
						<td>
							<select id="ebt" name="bt">
								<option value="inline">inline</option>
								<option value="p">new line</option>
								<option value="h1">Heading 1</option>
								<option value="h2">Heading 2</option>
								<option value="h3">Heading 3</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Alignment</td>
						<td>
							<select id="eali" name="ali">
								<option value="default">default</option>
								<option value="left">left</option>
								<option value="center">center</option>
								<option value="right">right</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Original</td>
						<td>
							<input type="text" id="eorig" name="orig" size="100" class="rtl" />
						</td>
					</tr>
					<tr>
						<td>Translation</td>
						<td>
							<input type="text" id="etran" name="tran" size="100" />
						</td>
					</tr>
					<tr>
						<td>Order</td>
						<td>
							<input name="por" id="epor" type="number" min="1" step="1" size="3" style="width:45px;" value="999" />
						</td>
					</tr>
				</tbody>
			</table>
			
				<button id="canc" type="button">Cancel</button>
				
				<input type="submit" value="Update Entry" />
				
				&nbsp; &nbsp;
				<button id="rem" type="button">Remove Entry</button>
			</form>	
			
			
		</fieldset>
	</div>

</body>
</html>
<%
} else {
	response.sendRedirect("index.jsp");
	}
%>