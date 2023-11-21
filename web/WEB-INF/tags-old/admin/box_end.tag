<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the end of an shaded box" pageEncoding="UTF-8"%>

<%@ attribute name="color" required="false"%>
<%@ attribute name="cb_content" required="false"%>

<% if(color!=null && color.equals("false")) { %>
</div>
<img class="adminbox_bottom_white" 
	<% if(cb_content == null){ %>
 src="common/images/blank.gif"
	<% } else { %>
 src="../common/images/blank.gif"
	<% } %>
 width="728" height="10" alt="" border="0" />
</div>
<% } else { %>
</div>
<img class="adminbox_bottom"
	<% if(cb_content == null){ %>
 src="common/images/blank.gif"
	<% } else { %>
 src="../common/images/blank.gif"
	<% } %>
 width="728" height="10" alt="" border="0" />
</div>    
<% } %>