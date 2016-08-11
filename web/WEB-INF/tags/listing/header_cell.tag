<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" %>
<%@ attribute name="align" required="false" %>
<%@ attribute name="url" required="false" %>
<%@ attribute name="ascending" required="false" %>
<%@ attribute name="first" required="false" %>
<%@ attribute name="column" required="false" %>
<%@ attribute name="match" required="false" %>
<%@ attribute name="width" required="false" %>
<%@ attribute name="colspan" required="false" %>
<%@ attribute name="cssClass" required="false" %>
<%@ attribute name="toggleTarget" required="false" %>
<%@ attribute name="toggleOpen" required="false" %>
<%@ attribute name="id" required="false" %>
<%@ attribute name="setWidth" required="false" %>


<%if(url!=null){%>
	<%boolean selected = false;%>
	<%if(column!=null && match!=null && column.equals(match)) {%>
		<%selected = true;%>
	<%}%>
	<%String operator = "?";%>
	<%if(url.contains("?")) {%>
		<%operator = "&";%>
	<%}%>

	<%if(selected) {%>
        <%if(ascending.equals("true")) {%>
        	<th><i class="glyphicon glyphicon-sort-by-attributes"></i><a style="text-decoration:none;color:black;" href="javascript:loadTab('${url}<%= operator + "column=" + column + "&ascending=false" %>');"> ${name}</a></th>
        <%} else {%>
        	<th><i class="glyphicon glyphicon-sort-by-attributes-alt"></i><a style="text-decoration:none;color:black;" href="javascript:loadTab('${url}<%= operator + "column=" + column + "&ascending=true" %>');"> ${name}</a></th>
        <%}%>
    <%} else {%>
        <th><a style="text-decoration:none;color:black;" href="javascript:loadTab('${url}<%= operator + "column=" + column + "&ascending=true" %>');">${name}</a></th>
    <%}%>
<%}else{%>
	<th <% if(setWidth!=null) { %>style="width:${setWidth}px;"<% } %>>${name}</th>
<%}%>