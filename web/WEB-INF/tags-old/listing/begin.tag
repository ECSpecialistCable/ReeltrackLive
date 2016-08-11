<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="cssClass" required="false" %>

<%@ attribute name="toggleTarget" required="false" %>
<%@ attribute name="toggleOpen" required="false" %>

<%@ attribute name="toggleRecipient" required="false"%>

<%@ attribute name="id" required="false" %>

<%@ attribute name="rel" required="false" %>

<div 
	<% if(id!=null) { %> 
		id="${id}" 
	<% } %> 
 class="adminbox_white <% if(toggleTarget != null ) { %>toggle_trigger <% if(toggleOpen != null && toggleOpen == "true"){ %>toggleIsOpen <% } else {%>toggleIsClosed <% } %><% } %><% if(toggleRecipient != null){ %>${toggleRecipient} <% } %><% if(cssClass!=null) { %>${cssClass} <% } %> " 
	
	<% if(toggleTarget != null ) { %> 
		rel=".${toggleTarget}"
	<% } %> >
	
	
<table border="0" cellspacing="0" cellpadding="0" class="listing" <% if(rel!=null) { %> rel="${rel}" <% } %> >