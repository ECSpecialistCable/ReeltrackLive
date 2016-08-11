<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a set of fields for filling out a date on a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="label" required="true" %>
<%@ attribute name="name" required="false" %>

<%@ attribute name="value" required="false" %>
<%@ attribute name="start" required="false" %>
<%@ attribute name="required" required="false" %>

<tr>
    <form:label name="${name}" label="${label}"/>
    <td >
       <input style="width:70px;" type="text" rel="${start}" id="${name}" name="${name}" value="${value}" class="input_date_picker" />
	</td>
</tr>