<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%  
    String param = "content_id_for_tabset";    
    String paramstring = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}	    
%>

<admin:tab url="reels/search.jsp" text="Search All" />
<admin:tab url="reels/cable_data.jsp" text="Cable Data" params="<%= paramstring %>"/>
<admin:tab url="reels/status.jsp" text="status" params="<%= paramstring %>"/>
<admin:tab url="reels/edit.jsp" text="edit" params="<%= paramstring %>"/>
<admin:tab url="reels/quantity.jsp" text="quantity" params="<%= paramstring %>"/>
<admin:tab url="reels/circuits.jsp" text="circuits" params="<%= paramstring %>"/>
<admin:tab url="reels/issues.jsp" text="Issues" params="<%= paramstring %>"/>
<admin:tab url="reels/notes.jsp" text="Notes" params="<%= paramstring %>"/>
<admin:tab url="reels/log.jsp" text="Log" params="<%= paramstring %>"/>
<admin:tab url="reels/reel_data.jsp" text="Reel Data" params="<%= paramstring %>"/>


<admin:set_moduleactions url="reel_inventory/_moduleactions.jsp" />
