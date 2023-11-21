<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a hidden field for a form" pageEncoding="UTF-8"%>
<%@ attribute name="name" required="true" %>
<%@ attribute name="value" required="true" type="java.lang.Object"%>

		<input type="hidden" name="${name}" id="${name}" value="${value}" />
