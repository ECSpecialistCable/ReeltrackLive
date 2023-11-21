<%@ tag body-content="scriptless"%>
<%@ tag description="Outputs a table cell" pageEncoding="UTF-8"%>
<%@ attribute name="align" required="false" %>

<td valign="top" align="${align}">
	<jsp:doBody />
</td>