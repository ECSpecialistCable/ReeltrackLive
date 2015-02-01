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
	if(request.getParameter("isReelTrack")!=null && request.getParameter("isReelTrack").equals("true")) {
		isReelTrack = true;
	}
	boolean isTraining = false;	
	if(request.getParameter("isTraining")!=null && request.getParameter("isTraining").equals("true")) {
		isTraining = true;
	}
%>

<% if(isReelTrack) { %>
	<admin:tab url="glossary/reeltrack_glossary.jsp" text="< < <" />
<% } else if(isTraining) { %>
	<admin:tab url="glossary/reeltrack_videos.jsp" text="< < <" />
<% } else { %>
	<admin:tab url="glossary/job_glossary.jsp" text="< < <" />
<% } %>
<admin:tab url="glossary/edit.jsp" text="edit" params="<%= paramstring %>"/>

<admin:set_moduleactions url="glossary/_moduleactions.jsp" />
