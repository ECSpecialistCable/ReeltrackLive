<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the tag and script for the notifier"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="message" required="false" %>
<%@ attribute name="type" required="false" %>

<% if(message!=null && !message.equals("")) { %>
	<% if(type==null || type.equals("info")) { %>
		<script>trampInfoAlert('<%= message %>');</script>
	<% } else if(type.equals("error")) { %>
		<script>trampErrorAlert('<%= message %>');</script>
	<% } %>
<% } %>

