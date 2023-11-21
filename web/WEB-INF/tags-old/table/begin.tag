<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of a table" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="name" required="false" %>

<table border="0" cellspacing="0" cellpadding="0" name="${name}" id="${name}" <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>>
