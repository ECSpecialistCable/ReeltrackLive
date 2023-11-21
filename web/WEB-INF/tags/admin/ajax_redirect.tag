<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html and js to do an ajax redirect" pageEncoding="UTF-8"%>
<%@ attribute name="redirect" required="true"%>
<%
if(application.getInitParameter("protocol")!=null && application.getInitParameter("protocol").equalsIgnoreCase("https")) {
    StringBuilder url = new StringBuilder();
    url.append("https").append("://").append(request.getServerName());
    url.append(redirect);
    redirect = url.toString();
}
%>
<% response.sendRedirect(redirect); %>
