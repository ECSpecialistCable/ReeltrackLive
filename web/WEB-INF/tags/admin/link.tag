<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html and js to do an ajax page load in the admin" pageEncoding="UTF-8"%>
<%@ attribute name="url" required="true"%>
<%@ attribute name="text" required="false"%>
<%@ attribute name="img" required="false"%>
<%@ attribute name="style" required="false"%>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="external" required="false"%>
<%@ attribute name="lightboxLink" required="false"%>

<a href="javascript:loadTab('${url}');">
    ${text}
</a>