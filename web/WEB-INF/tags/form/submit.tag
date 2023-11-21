<%@ tag body-content="empty" %>
<%@ tag description="Outputs a submit button for a form" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="id" required="false" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="action" required="true" %>
<%@ attribute name="align" required="false" %>
<%@ attribute name="button" required="false" %>
<%@ attribute name="waiting" required="false" %>

<form:fieldset name="${name}" label="${label}" align="${align}">
    <form:submit_inline id="${id}" name="${name}" action="${action}" button="${button}" waiting="${waiting}" />
</form:fieldset>
