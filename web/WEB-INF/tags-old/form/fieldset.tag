<%@ tag body-content="scriptless"%>
<%@ tag description="wraps a set of fields with a label" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="label" required="false" %>
<%@ attribute name="name" required="false" %>
<%@ attribute name="align" required="false" %>


<table:row>
    <form:label name="${name}" label="${label}"/>
    <table:cell align="${align}">
        <jsp:doBody />
	</table:cell>
</table:row>