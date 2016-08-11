<%@ tag body-content="empty" %>
<%@ tag description="Outputs a submit button for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%@ attribute name="name" required="true" %>
<%@ attribute name="action" required="true" %>
<%@ attribute name="button" required="false" %>
<%@ attribute name="waiting" required="false" %>
<%@ attribute name="cb_content" required="false"%>
<%@ attribute name="warning" required="false" %>
<%@ attribute name="message" required="false" %>

<input type="hidden" name="submit_action" value="${action}" />
<!-- <input type="submit" value="[${fn:toUpperCase(name)}]" style="display: none;" /> -->
<%--
<input type="submit" value="${fn:toUpperCase(name)}" /> 
<a <% if(button==null) { %>class="submitbutton"<% } %> href="#" onclick="javascript:ADMIN.util.submit_via_link(this); alert(submit); return false;">
--%>

<% if(button!=null) { %>
<a href="#" onclick="javascript:return false;">
		<% if(button=="login") { %> 
			<button type="button"	class="btn btn-primary btn-xs loginButton" onclick="this.innerHTML='.....';">${fn:toUpperCase(name)}</button>
		<% } else { %> 
			<%-- no longer using ajax_submitable_button --%>
			<%-- class="${button}Button ajax_submitable_button" --%>
			<button type="button"
			<% if(warning!=null && warning.equals("true")) { %>
				class="btn btn-primary btn-xs warning_msg ajax_submitter"
    			rel="${message}"
		    <% } else { %>
					class="btn btn-primary btn-xs ajax_submitter"
			<% } %>
			onclick="this.innerHTML='.....';">${fn:toUpperCase(name)}</button> 
		<% } %>
</a>	    
		
<% } else { %>
	<input type="submit" style="color: #0e6dc6;text-decoration: none;" value="${fn:toUpperCase(name)}" />    
<% } %>
