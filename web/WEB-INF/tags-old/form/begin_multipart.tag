<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="action" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="submit" required="false" %>
<%@ attribute name="cssClass" required="false"%>

<% if(submit!=null) { %>
    <form:begin_inline enctype="multipart/form-data" submit="${submit}" action="${action}" name="${name}" />
<% } else { %>
    <form:begin_inline enctype="multipart/form-data" action="${action}" name="${name}" />
<% } %>
    <table:begin />
        