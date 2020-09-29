<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="javax.naming.*,javax.sql.DataSource,org.apache.logging.log4j.*,edu.bowdoin.corpus.*,
    edu.bowdoin.nova.*,java.util.*,
    nu.xom.Element" %><%
try {

	request.setCharacterEncoding ("UTF-8");
    String adm = (String) session.getAttribute("adm");
    String method = (String) request.getParameter("m");
    if(null != adm && null != method) {
	    Context initContext = new javax.naming.InitialContext();
		Context envContext  = (Context)initContext.lookup("java:/comp/env");
		DataSource ds = (DataSource)envContext.lookup("jdbc/petium");
	    org.apache.logging.log4j.Logger logger = LogManager.getLogger("edu.bowdoin.corpus");
	
		DataMethods dm = new DataMethods(ds,logger);
		
		int succ = 0;
		
		switch(method) {
		
			case "addWork":
				String lang = (String) request.getParameter("lang");
				String ot = (String) request.getParameter("ot");
				
				String et = (String) request.getParameter("et");
				String oa = (String) request.getParameter("oa");
				String ea = (String) request.getParameter("ea");
				String cite = (String) request.getParameter("cite");
				
				succ = dm.AddWork(et, ot, ea, oa, cite, Integer.parseInt(adm), Integer.parseInt(lang));
				response.sendRedirect("Works.jsp?succ="+succ);
			break;
			
			case "updDetails":
				String wid = (String) request.getParameter("wid");
				ot = (String) request.getParameter("ot");
				et = (String) request.getParameter("et");
				oa = (String) request.getParameter("oa");
				ea = (String) request.getParameter("ea");
				cite = (String) request.getParameter("cite");
				String sta = (String) request.getParameter("sta"); 
				succ = dm.UpdateWorkDetails(wid,et, ot, ea, oa, cite, sta);
				response.sendRedirect("Work.jsp?wid="+wid);
			break;
			
			case "addPetium":
				wid = (String) request.getParameter("wid");
				String bt = (String) request.getParameter("bt");
				
				String ali = (String) request.getParameter("ali");
				String orig = (String) request.getParameter("orig");
				String tran = (String) request.getParameter("tran");
				String por = (String) request.getParameter("por");
				String lng = "1";
				String notes = (String) request.getParameter("notes");
	//			System.out.println("h "+notes);
				succ = dm.AddWorkPetium(wid, bt, ali, orig, tran, por, adm, lng,notes);
				
				response.sendRedirect("Work.jsp?wid="+wid);
				
			break;
			
			case "editPetium":
				wid = (String) request.getParameter("wid");
				String pid = (String) request.getParameter("pid");
				bt = (String) request.getParameter("bt");
				
				ali = (String) request.getParameter("ali");
				orig = (String) request.getParameter("orig");
				tran = (String) request.getParameter("tran");
				String wpor = (String) request.getParameter("wpor");
				por = (String) request.getParameter("por");
				notes = (String) request.getParameter("notes");
				lng = "1";
				succ = dm.EditWorkPetium(wid, pid, bt, ali, orig, tran, wpor, por, adm, lng, notes);
				
				response.sendRedirect("Work.jsp?wid="+wid);
				
			break;
			
			case "removePetium":
				wid = (String) request.getParameter("wid");
				pid = (String) request.getParameter("pid");
 
				succ = dm.RemoveWorkPetium(pid);  
				
				response.sendRedirect("Work.jsp?wid="+wid);
				
			break;
			
			
			
			
		}
	
		

} else {
	response.sendRedirect("index.jsp");
}
} catch(Exception e) {
	out.write("Error "+e);
}
%>