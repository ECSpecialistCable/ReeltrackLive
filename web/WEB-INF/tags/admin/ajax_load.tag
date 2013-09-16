<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html and js to do an ajax page load in the admin" pageEncoding="UTF-8"%>
<%@ attribute name="url" required="true"%>
<%@ attribute name="label" required="true"%>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="autoOpen" required="false"%>


<a href="${url}" class="<% if(cssClass!=null) { %>${cssClass} <% } %><% if(autoOpen!=null && autoOpen.equals("true")) { %>auto_open_module_action <% } %>ajax_loadable" >
${label}</a>
