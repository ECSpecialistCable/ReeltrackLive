<%@ tag body-content="empty" %>
<%@ tag description="Outputs a submit button for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%@ attribute name="name" required="true" %>

<button type="button" class="btn btn-primary btn-xs" onclick="document.getElementById('${name}').reset();">CLEAR</button> 

