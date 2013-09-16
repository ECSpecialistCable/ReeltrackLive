<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a text area for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="name" required="true" %>

<%@ attribute name="cols" required="false" %>
<%@ attribute name="rows" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="htmleditor" required="false" %>
<%@ attribute name="required" required="false" %>
<%@ attribute name="pixelwidth" required="false" %>

<textarea class="withborder" 
        name="${name}" 
        id="${name}" 
        cols="${cols}"
        rows="${rows}"
        <c:if test="${pixelwidth != ''}">
            style="width: ${pixelwidth}px;"
        </c:if>             
        <c:if test="${htmleditor}">
            htmleditor="${htmleditor}"
        </c:if>
        <c:if test="${required}">
	        required="${required}"
        </c:if>	        
        <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>
>${value}</textarea>		
