<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs an h2" pageEncoding="UTF-8"%>
<%@ attribute name="text" required="true" %>

<%@ attribute name="cssClass" required="false" %>

<%@ attribute name="id" required="false" %>

<%@ attribute name="toggleTarget" required="false" %>
<%@ attribute name="toggleOpen" required="false" %>

<%@ attribute name="lightboxLink" required="false" %>
<%@ attribute name="url" required="false" %>



<h2 class="${cssClass} <% if(toggleTarget!=null) {%> toggle_trigger <% if(toggleOpen != null && toggleOpen == "true"){ %> toggleIsOpen <% } else {%> toggleIsClosed <% } %> <% } %>"
	
	<% if(toggleTarget!=null){ %> 
		rel=".${toggleTarget}"
	<% } %> 
	
	<% if(id!=null) { %>
	 	id="${id}"
	<% } %> 
	>
	
	<% if(lightboxLink != null && lightboxLink == "true"){ %>
		<a href="${url}" class="lightbox_link" target="_blank">
	<% } %>
${text}
	<% if(lightboxLink != null && lightboxLink == "true"){ %>
	</a>
	<% } %>
</h2>