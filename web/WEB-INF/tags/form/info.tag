<%@ tag body-content="tagdependent" %>
<%@ tag description="Outputs a text with a label" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="label" required="true" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="helpText" required="false" %>

<div class="form-group">
<label style="padding-right:0;color:#333333;" for="${name}" class="col-sm-3 control-label">${label}</label>
<div class="col-sm-9">
  <div style="padding-top:7px;">${text}</div>
  <c:if test="${helpText != ''}">
  <p class="help-block" style="margin-bottom:0;color:darkgray;">${helpText}</p>
  </c:if>
</div>
</div>