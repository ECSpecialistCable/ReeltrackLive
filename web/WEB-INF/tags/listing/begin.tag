<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="cssClass" required="false" %>

<%@ attribute name="toggleTarget" required="false" %>
<%@ attribute name="toggleOpen" required="false" %>

<%@ attribute name="toggleRecipient" required="false"%>

<%@ attribute name="id" required="false" %>

<%@ attribute name="rel" required="false" %>

<%@ attribute name="style" required="false" %>

<div class="table-responsive">
<table class="table table-striped" style="border-bottom:1px solid #dddddd;;<% if(style!=null) { %>${style}<% } %>">