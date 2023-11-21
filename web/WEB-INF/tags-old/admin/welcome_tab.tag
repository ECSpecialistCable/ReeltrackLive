<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary js to load proper UI elements for this jsp page" pageEncoding="UTF-8"%>

<%@ attribute name="text" required="true"%>

<%@ attribute name="action" required="false"%>
<%@ attribute name="name" required="false" %>

<%@ attribute name="align" required="false" %>
<%@ attribute name="valign" required="false" %>



<div id="welcome_tab" class="<% if(valign != null && valign != "top") {%> bottomWelcomeTab <% } %><% if(align != null && align != "left") {%> rightWelcomeTab <% }else{ %> leftWelcomeTab <% } %>">  

<% if(action != null){ %>
<a href="${action}">
<% } else { %>
<a>
<% } %>
    <div class="t"></div>
    <div class="content">
		<% if(name == null){ %>
			<img width="14" height="14"  alt="" border="0" class="LogoutTabButton" src="common/images/blank.gif" />
		<% } %>
          <!-- Your content goes here -->
          ${text}
		<% if(action != null){ %>
			<% if(name != null){ %>
				<em>[${name}]</em>
			<% } %>
		<% } %>
    </div>
</a>

</div>