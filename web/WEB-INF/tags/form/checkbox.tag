<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs an option tag for a select box in a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="label" required="false" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="id" required="false" %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="text" required="false" %>
<%@ attribute name="selected" required="false" %>
<%@ attribute name="match" required="false" %>
<%@ attribute name="onclick" required="false" %>
<%@ attribute name="onchange" required="false" %>


<% if(label!=null) { %>
  <div class="form-group">
  	<label style="padding-right:0;color:#333333;" for="${id}" class="col-sm-3 control-label">${label}</label>
    <div class="col-sm-9">
      <div class="checkbox">
        <label>
          <input type="checkbox" name="${name}" id="${id}" value="${value}"> ${text}
          <p class="help-block" style="margin-bottom:0;color:darkgray;">${helpText}</p>
        </label>
      </div>
      
    </div>
  </div>
<% } else { %>
	<input type="checkbox" value="${value}" name="${name}" <% if(id!=null) { %>id="${id}"<% } %> <% if(onchange!=null) { %>onchange="${onchange}"<% } %>
<% if((selected!=null && selected.equals("true")) || (match!=null && match.equals(value))) { %>
 checked="checked"
<% } %>
	>
<% } %>