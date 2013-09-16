<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="action" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="submit" required="false" %>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="notify" required="false" %>

<% if(submit!=null) { %>
    <form:begin_inline submit="${submit}" action="${action}" name="${name}" cssClass="${cssClass}" notify="${notify}" />
<% } else { %>
    <form:begin_inline action="${action}" name="${name}" cssClass="${cssClass}" notify="${notify}"/>
<% } %>
    <table:begin />
