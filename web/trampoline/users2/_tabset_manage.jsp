<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%  
    String param = "content_id_for_tabset";    
    String paramstring = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}	    
%>

<admin:tab url="users2/search.jsp" text="< < <" />
<admin:tab url="users2/edit.jsp" text="edit user" params="<%= paramstring %>"/>

<admin:set_moduleactions url="users2/_moduleactions.jsp" />
