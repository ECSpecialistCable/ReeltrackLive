<%@ tag body-content="empty" %>
<%@ tag description="Outputs a submit button for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%@ attribute name="name" required="false" %>
<%@ attribute name="button" required="false" %>
<%@ attribute name="url" required="true" %>
<%@ attribute name="process" required="false" %>
<%@ attribute name="waiting" required="false" %>
<%@ attribute name="warning" required="false" %>
<%@ attribute name="cb_content" required="false"%>
<%@ attribute name="tooltip" required="false"%>
<%@ attribute name="newtab" required="false"%>

<% if(name.equalsIgnoreCase("duplicate")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;" href="javascript:loadProcess('${url}');"><span class="glyphicon glyphicon-log-in" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;" href="javascript:loadProcess('${url}');"><span class="glyphicon glyphicon-log-in" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("delete")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;" href="javascript:loadProcessWithWarning('${url}',this,'Are you sure you want to Delete?');"><span class="glyphicon glyphicon-remove" style="color:red;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;" href="javascript:loadProcessWithWarning('${url}',this,'Are you sure you want to Delete?');"><span class="glyphicon glyphicon-remove" style="color:red;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("evaluate")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;" href="javascript:loadProcess('${url}',this);"><span class="glyphicon glyphicon-time" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;" href="javascript:loadProcess('${url}',this);"><span class="glyphicon glyphicon-time" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("evaluate_passthru")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}',this);"><span class="glyphicon glyphicon-ok-circle" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}',this);"><span class="glyphicon glyphicon-ok-circle" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("score_passthru")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcessWithWarning('${url}',this, 'Are you sure you want to Run Score?');"><span class="glyphicon glyphicon-record" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcessWithWarning('${url}',this,'Are you sure you want to Run Score?');"><span class="glyphicon glyphicon-record" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("prescore_passthru")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}',this);"><span class="glyphicon glyphicon-retweet" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}',this);"><span class="glyphicon glyphicon-retweet" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("download")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;" href="${url}" target="_new"><span class="glyphicon glyphicon-cloud-download" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;" href="${url}" target="_new"><span class="glyphicon glyphicon-cloud-download" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("edit")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-edit" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-edit" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("reel page")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-edit" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-edit" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("locked")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;"><span class="glyphicon glyphicon-lock" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;cursor: pointer;"><span class="glyphicon glyphicon-lock" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("add")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}');"><span class="glyphicon glyphicon-plus-sign" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}');"><span class="glyphicon glyphicon-plus-sign" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("remove")) { %>
	<%if(tooltip != null) { %>
		<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}');"><span class="glyphicon glyphicon-minus-sign" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
		<a style="padding-left:2px;padding-left:2px;cursor: pointer;" onclick="javascript:loadProcess('${url}');"><span class="glyphicon glyphicon-minus-sign" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("print")) { %>
	<%if(tooltip != null) { %>
	<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" href="${url}" target="_blank"><span class="glyphicon glyphicon-print" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
	<a style="padding-left:2px;cursor: pointer;" href="${url}" target="_blank"><span class="glyphicon glyphicon-print" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("refresh")) { %>
	<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-refresh" style="color:#016b8d;font-size:24px;"></span></a>
<% } else if(name.equalsIgnoreCase("stage")) { %>
	<%if(tooltip != null) { %>
	<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-log-in" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
	<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-log-in" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else if(name.equalsIgnoreCase("checkout")) { %>
	<%if(tooltip != null) { %>
	<a data-toggle="tooltip" title="${tooltip}" style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-new-window" style="color:#016b8d;font-size:24px;"></span></a>
	<%} else { %>
	<a style="padding-left:2px;cursor: pointer;" onclick="javascript:loadTab('${url}');"><span class="glyphicon glyphicon-new-window" style="color:#016b8d;font-size:24px;"></span></a>
	<% } %>
<% } else { %>
	<% if(process!=null && warning!=null) { %>
		<button type="button" class="btn btn-primary btn-sm" onclick="javascript:loadProcessWithWarning('${url}',this,'${warning}');">${name}</button>
	<% } else if(process!=null) { %>
		<button type="button" class="btn btn-primary btn-sm" onclick="javascript:loadProcess('${url}');">${name}</button>
	<% } else if(newtab!=null) { %>
		<a class="btn btn-primary btn-sm" style="cursor: pointer;" href="${url}" target="_blank">${name}</a>
	<% } else { %>
		<button type="button" class="btn btn-primary btn-sm" onclick="javascript:loadTab('${url}');">${name}</button>
	<% } %>
<% } %>
