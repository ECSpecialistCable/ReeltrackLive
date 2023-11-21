<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary js to load proper UI elements for this jsp page" pageEncoding="UTF-8"%>

<%@ attribute name="url" required="false"%>
<%@ attribute name="text" required="true"%>
<%@ attribute name="params" required="false"%>

<% if(url!=null) { %>
<li id="${url}"><a href="javascript:tabInfo('${url}${params}')" onclick="javascript:loadTab('${url}${params}');" data-toggle="tab" class="nav_txt">${text}</a></li>
<% } else { %>
<li class="disabled"><a>${text}</a></li>
<% } %>
