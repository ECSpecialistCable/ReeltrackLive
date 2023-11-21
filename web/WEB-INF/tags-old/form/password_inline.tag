<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a text field for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" %>

<%@ attribute name="pixelwidth" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="required" required="false" %>

<input type="password" class="withborder" 
    name="${name}" 
    id="${name}" 
    <c:if test="${value != ''}">
        value="${value}" 
    </c:if>     
    <c:if test="${pixelwidth != ''}">
        style="width: ${pixelwidth}px;"
    </c:if>     
    <c:if test="${required}">
        required="${required}"
    </c:if>	        
    <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>
/>	        
