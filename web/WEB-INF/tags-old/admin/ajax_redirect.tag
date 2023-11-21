<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html and js to do an ajax redirect" pageEncoding="UTF-8"%>
<%@ attribute name="redirect" required="true"%>

<% response.sendRedirect(redirect); %>