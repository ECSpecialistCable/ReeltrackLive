<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a text field for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="false" %>
<%@ attribute name="label" required="false" %>

<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>


<c:if test="${label != ''}">
    <label for="${name}">${label}</label>
</c:if>
