<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html and js to do an ajax redirect" pageEncoding="UTF-8"%>
<%@ attribute name="redirect" required="true"%>

<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>

<%  
// i need to send the redirect, but via javascript ajax call
// each action needs to know what page to redirect to,
// then a call to ADMIN.load.page(whichpage, fn)
%>
<html:begin />
	<script type="text/javascript" language="javascript">
	  // <![CDATA[
			parent.ADMIN.load.page('${ redirect }');
	  // ]]>
	</script>
<html:end />