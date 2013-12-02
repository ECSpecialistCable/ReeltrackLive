<%@page import="java.util.Enumeration"%>
<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%  
    String param = "content_id_for_tabset";    
    String paramstring = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}
	boolean isReelTrack = false;	
	if(request.getParameter("isReelTrack").equals("true")) {
		isReelTrack = true;
	}
%>

<% if(isReelTrack) { %>
	<admin:tab url="glossary/reeltrack_glossary.jsp" text="< < <" />
<% } else { %>
	<admin:tab url="glossary/job_glossary.jsp" text="< < <" />
<% } %>
<admin:tab url="glossary/edit.jsp" text="edit" params="<%= paramstring %>"/>

<admin:set_moduleactions url="glossary/_moduleactions.jsp" />
