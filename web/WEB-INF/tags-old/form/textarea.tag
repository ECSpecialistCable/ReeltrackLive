<%@ tag body-content="empty" %>
<%@ tag description="Outputs a text area for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>

<%@ attribute name="cols" required="false" %>
<%@ attribute name="rows" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="htmleditor" required="false" %>
<%@ attribute name="required" required="false" %>
<%@ attribute name="pixelwidth" required="false" %>



<form:fieldset name="${name}" label="${label}">
    <form:textarea_inline name="${name}" cols="${cols}" rows="${rows}" value="${value}" htmleditor="${htmleditor}" required="${required}" pixelwidth="${pixelwidth}" />
</form:fieldset>
