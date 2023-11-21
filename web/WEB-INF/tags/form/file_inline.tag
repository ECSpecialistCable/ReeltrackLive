<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a text field for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="name" required="true" %>
<%@ attribute name="url" required="false" %>
<%@ attribute name="filename" required="false" %>
<%@ attribute name="required" required="false" %>
<%@ attribute name="urldescription" required="false" %>
<%@ attribute name="reloption" required="false" %>
<%@ attribute name="cssClass" required="false" %>


<input type="file" name="${name}" id="${name}"
    <c:if test="${empty url}">
        required="${required}"
    </c:if>
    <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>
/>
<c:if test="${not empty filename}">
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
                View existing file.
            </c:otherwise>
        </c:choose>
        </a>
</c:if>
