<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a set of fields for filling out a time on a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="label" required="true" %>
<%@ attribute name="name" required="false" %>

<%@ attribute name="defaultCalendar" required="false" type="java.util.GregorianCalendar"%>

<% 
    
    String[] ampm = {"AM", "PM"};

    boolean has_default = true;

    if(defaultCalendar == null){
        defaultCalendar = new java.util.GregorianCalendar();
        has_default = false;
    }
    
    int current_hour = defaultCalendar.get(java.util.GregorianCalendar.HOUR);
    int current_minute = defaultCalendar.get(java.util.GregorianCalendar.MINUTE);
    int current_ampm = defaultCalendar.get(java.util.GregorianCalendar.AM_PM);

	String current_toshow = "";
	if(current_ampm == java.util.GregorianCalendar.AM) {
		current_toshow = ampm[0];
	} else {
		current_toshow = ampm[1];
	}
%>

	<form:label name="${name}" label="${label}"/>
	<td valign="top">
        <select name="${name}hour">
            <% if(has_default) { %>
                <option value="<%= current_hour %>"><% if(current_hour != 0) { %><%= current_hour %><% } else { %>12<% } %></option>
                <option value="<%= current_hour %>">--</option>                
            <% } %>
            <% for(int x=1; x<=11; x++){ %>
                <option value="<%= x %>"><%= x %></option>
            <% } %>
				<option value="0">12</option>
        </select>
        :
        <select name="${name}minute">

            <% if(has_default) { %>
                <option value="<%= current_minute %>">
                <% if(current_minute < 10) { %>
                    0<%= current_minute %>
                <% } else { %>
                    <%= current_minute %>
                <% } %>
                </option>
                <option value="<%= current_minute %>">--</option>                
            <% } %>                
            <% for(int y=0; y<=59; y++){ %>
                <option value="<%= y %>">
                    <% if(y < 10) { %>
                        0<%= y %>                
                    <% } else { %>
                        <%= y %>
                    <% } %>
                </option>
            <% } %>
        </select>
        <select name="${name}ampm">
            <% if(has_default) { %>
                <option value="<%= current_toshow %>"><%= current_toshow %></option>
                <option value="<%= current_toshow %>">--</option>                
            <% } %>                            
            <option value="<%= ampm[0] %>"><%= ampm[0] %></option>
            <option value="<%= ampm[1] %>"><%= ampm[1] %></option>
        </select>
	    	    
	</td>
