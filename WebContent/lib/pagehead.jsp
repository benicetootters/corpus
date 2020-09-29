<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <header>
    	<span class="hd">Corpus</span>
    	<nav>
    		<ul>
    		<li><a href="Catalog.jsp">Public Catalog</a> (Campus only) |</li>
<%
    
String adm = (String) session.getAttribute("adm");
String bwdn = (String) session.getAttribute("bwdn");
if(null != adm && !(adm.equals("-999"))) {
%>    		  		
    			<li><a href="Works.jsp">Admin Dashboard</a> |</li>
    			<li><a href="exit.jsp">Sign out</a> (<%=bwdn %>)</li>
<%
} 
%>

   			
    		</ul>
    	</nav>
    
    </header>


