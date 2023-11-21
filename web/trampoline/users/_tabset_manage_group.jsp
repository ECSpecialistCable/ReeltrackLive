<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%  
    String param = "content_id_for_tabset";    
    String paramstring = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}	    
%>

<admin:tab url="users/groups.jsp" text="< < <" />
<admin:tab url="users/edit_group.jsp" text="edit group" params="<%= paramstring %>"/>

<admin:set_moduleactions url="users/_moduleactions.jsp" />
