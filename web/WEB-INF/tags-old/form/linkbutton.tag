<%@ tag body-content="empty" %>
<%@ tag description="Outputs a submit button for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%@ attribute name="name" required="false" %>
<%@ attribute name="button" required="false" %>
<%@ attribute name="url" required="true" %>
<%@ attribute name="process" required="false" %>
<%@ attribute name="waiting" required="false" %>
<%@ attribute name="warning" required="false" %>
<%@ attribute name="cb_content" required="false"%>
<%@ attribute name="newtab" required="false"%>

<a
<% if(process!=null && process.equals("true")) { %>
    <% if(warning!=null && warning.equals("true")) { %>
			class="warning_msg submitbutton ajax_loadable"
    		rel="Are you sure you want to delete this item?"
    <% } else { %>
		<% if(button==null) { %>
			class="submitbutton ajax_loadable"
		<% } %>
	<% } %>
    target="_submissionFrame"
    href="${url}">	    
<% } else if(newtab!=null) { %>	
	href="${url}" target="_blank">
<% } else { %>	
	href="${url}" class="ajax_loadable">
<% } %>

<% if(button!=null) { %>
<button type="button" class="btn btn-primary btn-xs" onclick="this.innerHTML='.....';">${name}</button>
 </a>	    
<% } else { %>
<button type="button" class="btn btn-primary btn-xs" onclick="this.innerHTML='.....';">${name}</button>
</a>
<% } %>
