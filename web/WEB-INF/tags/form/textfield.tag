<%@ tag body-content="empty" %>
<%@ tag description="Outputs a text field for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>

<%@ attribute name="pixelwidth" required="false" %>

<%@ attribute name="value" required="false" %>
<%@ attribute name="required" required="false" %>

<form:fieldset name="${name}" label="${label}">
    <form:textfield_inline size="${size}" name="${name}" id="${name}" value="${value}" required="${required}" pixelwidth="${pixelwidth}"/>
</form:fieldset>