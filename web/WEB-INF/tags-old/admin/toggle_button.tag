<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary html to have a toggle button" pageEncoding="UTF-8"%>

<%@ attribute name="attachToID" required="true"%>


<div id="toggle_btn" rel="${attachToID}">
	<a>
		<img id="toggle_plus" class="toggle_img" src="common/images/toggle_plus.gif" width="18" height="19" alt="Toggle Plus" border="0" />
		<img id="toggle_minus" class="toggle_img" src="common/images/toggle_minus.gif" width="18" height="19" alt="Toggle Minus" border="0" />
	</a>
</div>
