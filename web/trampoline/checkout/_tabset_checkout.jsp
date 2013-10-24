<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%  
    String param = "content_id_for_tabset";    
    String paramstring = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}	    
%>

<admin:tab url="checkout/search.jsp" text="< < <" />
<admin:tab url="checkout/checkout.jsp" text="Check OUT" params="<%= paramstring %>"/>

<admin:set_moduleactions url="manage_reels/_moduleactions.jsp" />
