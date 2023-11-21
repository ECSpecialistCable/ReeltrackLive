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

<%
boolean selected = false;
if(column!=null && match!=null && column.equals(match)) {
    selected = true;
}

boolean arrowAsc = true;

String style = "regular";
if(first!=null && first.equals("true")) {
    style = "first";
}
if(selected) {
    style = style + "On";
}
if(ascending!=null) {
    String start = "?";
    if(url.indexOf("?")!=-1) {
        start = "&";
    }
    if(selected) {
        if(ascending.equals("true")) {
            url = url + start + "column=" + column + "&ascending=false";
        } else {
            arrowAsc = false;
            url = url + start + "column=" + column + "&ascending=true";
        }
    } else {
        url = url + start + "column=" + column + "&ascending=true";
    }
}
%>
<td valign="top"
	class="<%= align %> <%= style %> 
	<% if(toggleTarget != null ) { %> 
 		toggle_trigger
		<% if(toggleOpen != null && toggleOpen == "true"){ %> toggleIsOpen <% } else {%> toggleIsClosed <% } %>
	<% } %> 
	<% if(cssClass!=null) { %> 
		${cssClass} 
	<% } %>" 
	
	
	<% if(toggleTarget != null ) { %> 
		rel=".${toggleTarget}"
	<% } %>
	
	<%if(id != null){ %> id="${id}" <% } %>
	
	colspan="${colspan}" 
	<% if(width!=null) { %> width="${width}"<% } %>    
	
    <% if(url!=null) { %>onclick="ADMIN.load.page('<%= url %>');"<% } %>>
    <strong <% if(ascending!=null) { %>class="sorting"<% } %>>${name}</strong>
    <% if(ascending!=null) { %>
    <% if(arrowAsc) { %>
    <img src="/trampoline/common/images/header_down.gif" width="9" height="8" border="0" align="right" class="header_arrow" />
    <% } else { %>
    <img src="/trampoline/common/images/header_up.gif" width="9" height="8" border="0" align="right" class="header_arrow" />
    <% } %>
    <% } %>    
</td>