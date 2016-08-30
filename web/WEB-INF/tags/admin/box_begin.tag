<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the start of an shaded box" pageEncoding="UTF-8"%>

<%@ attribute name="color" required="false"%>
<%@ attribute name="id" required="false"%>

<%@ attribute name="cssClass" required="false"%>

<%@ attribute name="toggleRecipient" required="false"%>

<%@ attribute name="cb_content" required="false"%>

<%@ attribute name="text" required="false"%>
<%@ attribute name="name" required="false"%>
<%@ attribute name="pages" required="false"%>
<%@ attribute name="pageNum" required="false"%>
<%@ attribute name="url" required="false"%>
<%@ attribute name="open" required="false"%>

<div class="panel panel-primary" <% if(color!=null) { %>style="border-color:${color};"<% } %>>
  <div class="panel-heading blue_bg" <% if(color!=null) { %>style="background-color:${color};border-color:${color};"<% } %>>
    <h3 class="panel-title"><a onclick="saveCollapseState('${name}')" data-toggle="collapse" href="#${name}">${text}</a>
    <% if(pages!=null && pageNum!=null) { %>
    <% int howMany = Integer.parseInt(pages); %>
    <% int selectedPage = Integer.parseInt(pageNum); %>
		<ul class="pagination pagination-sm pull-right" style="margin-top:-6px; padding:0;">
			<% for(int x=1; x<=howMany; x++) { %>

				<% if(selectedPage==x) { %>
					<% if(url.contains("?")) { %>
						<li style="cursor: default;"><a href="javascript:loadTab('${url}&pageNum=<%= x %>');"><%= x %></a></li>
					<% } else { %>
						<li style="cursor: default;"><a href="javascript:loadTab('${url}?pageNum=<%= x %>');"><%= x %></a></li>
					<% } %>
				<% } else { %>
					<% if(url.contains("?")) { %>
						<li class="active" style="cursor: default;"><a href="javascript:loadTab('${url}&pageNum=<%= x %>');"><%= x %></a></li>
					<% } else { %>
						<li class="active" style="cursor: default;"><a href="javascript:loadTab('${url}?pageNum=<%= x %>');"><%= x %></a></li>
					<% } %>

				<% } %>
	        <% } %>
	    </ul>
	    <div class="clearfix"></div>
	<% } %>
    </h3>
  </div>
  <div class="panel-collapse collapse <% if(open==null || !open.equals("false")) { %>in<% } %>" id="${name}">
