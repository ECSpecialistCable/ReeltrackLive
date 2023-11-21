<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs an h1" pageEncoding="UTF-8"%>
<%@ attribute name="text" required="true" %>
<%@ attribute name="heading" required="false" %>

<h2 class="adminTitle">
<% if(heading!=null && !heading.equals("")) { %>
	<span style="color:silver;">${heading}</span>
<% } %>
${text}</h2>
