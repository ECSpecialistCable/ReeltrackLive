<%@ tag body-content="empty" %>
<%@ tag description="Outputs a text area for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>

<%@ attribute name="cols" required="false" %>
<%@ attribute name="rows" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="htmleditor" required="false" %>
<%@ attribute name="required" required="false" %>
<%@ attribute name="pixelwidth" required="false" %>

<%@ attribute name="helpText" required="false" %>

<div class="form-group">
<label style="padding-right:0;color:#333333;" for="${name}" class="col-sm-3 control-label">${label}</label>
<div class="col-sm-9">
  <textarea class="form-control" name="${name}" id="${name}" rows="${rows}"><c:if test="${value != ''}">${value}</c:if></textarea>
  <c:if test="${helpText != ''}">
  <p class="help-block" style="margin-bottom:0;color:darkgray;">${helpText}</p>
  </c:if>
</div>
</div>
