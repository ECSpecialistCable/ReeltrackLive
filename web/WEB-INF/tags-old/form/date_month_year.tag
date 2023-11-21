<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a set of fields for filling out a date on a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="label" required="true" %>
<%@ attribute name="name" required="false" %>

<%@ attribute name="defaultCalendar" required="false" type="java.util.GregorianCalendar"%>

<% 
    boolean has_default = true;

    if(defaultCalendar == null){
        defaultCalendar = new java.util.GregorianCalendar();
        has_default = false;
    }
    
    int current_year = (new java.util.GregorianCalendar()).get(java.util.GregorianCalendar.YEAR);
    
    String[] month_names = {
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
    };
    
%>

<tr>
	<form:label name="${name}" label="${label}"/>
	<td valign="top">
        <select name="${name}month">
            <% if(has_default) { %>
                <option value="<%= defaultCalendar.get(java.util.GregorianCalendar.MONTH) %>"><%= month_names[defaultCalendar.get(java.util.GregorianCalendar.MONTH)] %></option>
                <option value="<%= defaultCalendar.get(java.util.GregorianCalendar.MONTH) %>">--</option>                
            <% } %>
    
            <% for(int i=0; i<12; i++){ %>
                <option value="<%= i %>"><%= month_names[i] %></option>
            <% } %>
        </select>
        /
        <select name="${name}year">
            <% if(has_default) { %>
                <option value="<%= defaultCalendar.get(java.util.GregorianCalendar.YEAR) %>"><%= defaultCalendar.get(java.util.GregorianCalendar.YEAR) %></option>
                <option value="<%= defaultCalendar.get(java.util.GregorianCalendar.YEAR) %>">--</option>                
            <% } %>
    
            <% for(int k=current_year-2; k<=current_year+5; k++){ %>
                <option value="<%= k %>"><%= k %></option>
            <% } %>
        </select>	    
 
	</td>
</tr>