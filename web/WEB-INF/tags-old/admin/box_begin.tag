<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the start of an shaded box" pageEncoding="UTF-8"%>

<%@ attribute name="color" required="false"%>
<%@ attribute name="id" required="false"%>

<%@ attribute name="cssClass" required="false"%>

<%@ attribute name="toggleRecipient" required="false"%>

<%@ attribute name="cb_content" required="false"%>

<% if(color!=null && color.equals("false")) { %>
<div class="adminbox_container_white <% if(cssClass != null){ %>${cssClass} <% } %><% if(toggleRecipient != null){ %>${toggleRecipient} <% } %>" 
	<% if(id != null){ %> id="${id}" <% } %> 
	>
    <img class="adminbox_top_white" 
		<% if(cb_content == null){ %>
 src="common/images/blank.gif"
		<% } else { %>
 src="../common/images/blank.gif"
		<% } %>
 width="728" height="10" alt="" border="0" />
    <div class="adminbox_white">
    <% } else { %>

<div class="adminbox_container <% if(cssClass != null){ %>${cssClass} <% } %><% if(toggleRecipient != null){ %>${toggleRecipient} <% } %>"
	<% if(id != null){ %> id="${id}" <% } %>   
	>
    <img class="adminbox_top" 
		<% if(cb_content == null){ %>
 src="common/images/blank.gif"
		<% } else {  %>
 src="../common/images/blank.gif"
		<% } %>
 width="728" height="10" alt="" border="0" />
    <div class="adminbox">    
    <% } %>