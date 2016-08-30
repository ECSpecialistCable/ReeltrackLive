<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%
    String param = "content_id_for_tabset";
    String paramstring = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}
%>

<admin:tab url="customers/search.jsp" text="<span class='glyphicon glyphicon-chevron-left'></span>" />
<admin:tab url="customers/edit.jsp" text="Edit" params="<%= paramstring %>"/>
<admin:tab url="customers/jobs.jsp" text="Jobs" params="<%= paramstring %>"/>
<admin:tab url="customers/users.jsp" text="Users" params="<%= paramstring %>"/>

<admin:set_moduleactions url="customers/_moduleactions.jsp" />
