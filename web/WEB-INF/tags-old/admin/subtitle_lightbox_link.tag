<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs an h2" pageEncoding="UTF-8"%>
<%@ attribute name="text" required="true" %>

<%@ attribute name="cssClass" required="false" %>
<%@ attribute name="toggleTarget" required="false" %>
<%@ attribute name="id" required="false" %>
<%@ attribute name="url" required="true"%>

<h2 class="${cssClass}" <% if(cssClass=="toggle_trigger"){ %> rel=".${toggleTarget}" <% } %> <% if(id!=null) { %>id="${id}"<% } %> >
<a href="${url}" class="lightbox_link" target="_blank">${text}</a>
</h2>