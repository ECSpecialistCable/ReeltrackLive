<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html and js to do an ajax redirect" pageEncoding="UTF-8"%>
<%@ attribute name="redirect" required="true"%>

<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<a class="specials" href="#" onclick="javascript:window.location='${ redirect }'"></a>
