<%@ tag body-content="scriptless"%>
<%@ tag description="wraps a set of checkboxes" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="label" required="true" %>


<table:row>
    <form:label name="${name}" label="${label}" />
    <table:cell>
        <jsp:doBody />
	</table:cell>
</table:row>