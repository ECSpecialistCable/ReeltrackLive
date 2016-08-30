<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%
    String param = "content_id_for_tabset";
    String paramstring = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}
%>

<admin:tab url="pick_lists/search.jsp" text="<span class='glyphicon glyphicon-chevron-left'></span>" />
<admin:tab url="pick_lists/edit.jsp" text="Edit" params="<%= paramstring %>"/>

<admin:set_moduleactions url="manage_reels/_moduleactions.jsp" />
