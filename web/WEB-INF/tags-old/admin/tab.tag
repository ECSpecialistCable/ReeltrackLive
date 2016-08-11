<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the necessary js to load proper UI elements for this jsp page" pageEncoding="UTF-8"%>

<%@ attribute name="url" required="true"%>
<%@ attribute name="text" required="true"%>
<%@ attribute name="params" required="false"%>

<a class="ajax_loadable" href="${url}${params}">
    <div class="t"></div>
    <div class="content">
          <!-- Your content goes here -->
          ${text}
    </div>
</a>
