<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="row" required="false" %>
<%@ attribute name="id" required="false" %>
<%@ attribute name="style" required="false" %>

<%@ attribute name="cssClass" required="false"%>


<%
String rowtype = "even";

if(row!=null) {
    int rowInt = new Integer(row).intValue();
    if(rowInt%2==0) {
        rowtype = "even";
    } else {
        rowtype = "color";
    }
}
%>

<tr id="${id}" style="${style}" <%if(cssClass != null){ %> class="${cssClass} <%= rowtype %> listing_row" <% } else { %> class="<%= rowtype %> listing_row"<% } %>>