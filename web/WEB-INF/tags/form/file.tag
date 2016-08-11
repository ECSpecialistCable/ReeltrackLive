<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a text field for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="url" required="false" %>
<%@ attribute name="filename" required="false" %>
<%@ attribute name="required" required="false" %>
<%@ attribute name="urldescription" required="false" %>
<%@ attribute name="reloption" required="false" %>
<%@ attribute name="cssClass" required="false" %>


<%--
<table:row>
	<form:label name="${name}" label="${label}"/>
	<table:cell>
	    <form:file_inline name="${name}" id="${name}" url="${url}" filename="${filename}" required="${required}" urldescription="${urldescription}" reloption="${reloption}" cssClass="${cssClass}"  />
	</table:cell>
</table:row>
--%>

<div class="form-group">
<label style="padding-right:0;color:#333333;" for="${name}" class="col-sm-3 control-label">${label}</label>
<div class="col-sm-9">
  <input type="file" name="${name}" id="${name}">

  <c:if test="${not empty filename}">
        <p class="help-block" style="margin-bottom:0;color:darkgray;">
        <c:choose>
	    <c:when test="${not empty url}">
	        <a target="_blank" href="<c:out value='${url}/${filename}'/>" rel="<c:out value='${reloption}'/>" class="<c:out value='${cssClass}'/>">
            </c:when>
            <c:otherwise>
                <a target="_blank" href="<c:out value='${filename}'/>">
            </c:otherwise>
        </c:choose>        
        <c:choose>
	        <c:when test="${not empty urldescription}">
	            ${urldescription}
            </c:when>
            <c:otherwise>
                View existing file
            </c:otherwise>
        </c:choose>
        </a>
        </p>
	</c:if>

</div>
</div>