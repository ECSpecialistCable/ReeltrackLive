<%@ tag body-content="tagdependent" %>
<%@ tag description="Outputs a text with a label" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="label" required="true" %>
<%@ attribute name="text" required="true" %>

<form:fieldset label="${label}">
    ${text}
</form:fieldset>