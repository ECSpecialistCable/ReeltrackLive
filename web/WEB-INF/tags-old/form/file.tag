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


<table:row>
	<form:label name="${name}" label="${label}"/>
	<table:cell>
	    <form:file_inline name="${name}" id="${name}" url="${url}" filename="${filename}" required="${required}" urldescription="${urldescription}" reloption="${reloption}" cssClass="${cssClass}"  />
	</table:cell>
</table:row>