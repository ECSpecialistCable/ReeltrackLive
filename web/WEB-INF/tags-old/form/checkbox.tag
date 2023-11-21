<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs an option tag for a select box in a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="id" required="false" %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="selected" required="false" %>
<%@ attribute name="match" required="false" %>
<%@ attribute name="onclick" required="false" %>
<input <% if(id==null) { %>id="${name}"<% } else { %>id="${id}"<% } %> <c:if test="${(!empty onclick)}">class="ajax_submitter"</c:if> name="${name}" type="checkbox" value="${value}" 
<% if((selected!=null && selected.equals("true")) || (match!=null && match.equals(value))) { %>
 checked="checked"
<% } %>
/> ${label}