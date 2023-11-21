<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="align" required="false" %>
<%@ attribute name="colspan" required="false" %>
<%@ attribute name="style" required="false" %>
<%@ attribute name="width" required="false" %>
<%@ attribute name="onclick" required="false" %>

<%@ attribute name="cssClass" required="false" %>
<%@ attribute name="toggleTarget" required="false" %>
<%@ attribute name="toggleOpen" required="false" %>

<% if(align!=null) { %>
<td align="${align}" <% if(style!=null) {%> style="${style}" <% } %>>
<% } else { %>
<td <% if(style!=null) {%> style="${style}" <% } %>>
<% } %>