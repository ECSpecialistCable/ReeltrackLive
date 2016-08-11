<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning of select box for a form" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" %>
<%@ attribute name="onchange" required="false" %>

<select class="form-control" id="${name}" name="${name}" <% if(onchange!=null) { %>onchange="${onchange}"<% } %>>