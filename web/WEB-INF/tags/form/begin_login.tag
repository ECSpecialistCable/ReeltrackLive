<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="action" required="true" %>
<%@ attribute name="name" required="true" %>

<%--
<form onsubmit="ADMIN.util.submit_normal('${name}'); return false;" action="${action}" method="post" name="${name}" id="${name}" <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>>
    <table:begin />
--%>
<form action="${action}" method="post" name="${name}" id="${name}" <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>>
    <table:begin />


