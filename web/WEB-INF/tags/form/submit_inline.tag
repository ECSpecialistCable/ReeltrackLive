<%@ tag body-content="empty" %>
<%@ tag description="Outputs a submit button for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%@ attribute name="id" required="false" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="action" required="true" %>
<%@ attribute name="button" required="false" %>
<%@ attribute name="waiting" required="false" %>
<%@ attribute name="cb_content" required="false"%>

<input type="hidden" name="submit_action" value="${action}" />
<button type="submit" class="btn btn-primary btn-sm" <% if(waiting!=null && waiting.equals("true")) { %>onclick="javascript:waitingSubmit(this);"<% } %>>${name}</button>

