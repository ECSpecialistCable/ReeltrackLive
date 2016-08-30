<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a text field for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" %>

<%@ attribute name="pixelwidth" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="required" required="false" %>

<div class="input-group col-sm-12" style="padding-left:0px;">
	<input type="text" name="${name}" id="${name}" <c:if test="${value != ''}">value="${value}"</c:if> class="form-control" placeholder="">
	<span class="input-group-btn">
		<input style="background-color:#EEEEEE;color:#555555;" class="btn btn-default" type="submit" value="SAVE">
	</span>
</div>
