<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html and js to do an ajax page load in the admin" pageEncoding="UTF-8"%>
<%@ attribute name="url" required="true"%>
<%@ attribute name="text" required="false"%>
<%@ attribute name="img" required="false"%>
<%@ attribute name="style" required="false"%>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="external" required="false"%>
<%@ attribute name="lightboxLink" required="false"%>

<a href="${url}" class="<% if(lightboxLink!=null) { %><% if(lightboxLink == "external") { %>lightbox_external_link <% }else if(lightboxLink == "internal") { %>lightbox_internal_link <% }else if(lightboxLink == "image") { %>lightbox_img <% }else{ %>lightbox_link <% } %><% if(cssClass!=null) { %>${cssClass} <% } %><% }else{ %><% if(cssClass!=null) { %>${cssClass} <% if(external==null) { %>ajax_loadable<% } %> <% } else { %><% if(external==null) { %>ajax_loadable<% } %><% } %><% } %> "
	<% if(style!=null) { %>
		style="${style}"
	<% } %>
	<% if(external!=null) { %>
		target="_blank"
	<% } %>
	>
<% if(img!=null) { %>
    <img src="${img}" />		    
<% } else { %>
    ${text}
<% } %>
</a>