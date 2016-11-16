<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.reeltrack.users.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />

<% CompProperties props = new CompProperties(); %>

<%
userLoginMgr.init(pageContext, dbResources);
RTUser user = (RTUser)userLoginMgr.getUser();
%>
<% dbResources.close(); %>

<% if(user!=null && user.getId()!=0) { %>
<div class="navbar-header">
  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
    <span class="sr-only">Toggle navigation</span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
  </button>
  <a class="navbar-brand" onClick="javascript:backButtonClicked();"><span class="glyphicon glyphicon-backward"></span></a>
</div>

<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  <ul class="nav navbar-nav">
      <% if(user.getCustomerId()!=0 && !user.getJobCode().equals("") && (user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_CPE) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT) || user.isUserType(RTUser.USER_TYPE_STANDARD) || user.isUserType(RTUser.USER_TYPE_INVENTORY))) { %>
          <% if(!user.isUserType(RTUser.USER_TYPE_INVENTORY)) { %>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Computer Operations <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <% if (user!=null && !user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
                    <li><a href="javascript:loadModule('bill_of_materials/search.jsp');">BOM / Qty Track / QRC Verify</a></li>
                	<% if(!user.isUserType(RTUser.USER_TYPE_STANDARD) && !user.isUserType(RTUser.USER_TYPE_CPE)) { %>
                    <li><a href="javascript:loadModule('import_circuits/search.jsp');">Import Circuits</a></li>
                    <% } %>
                    <li><a href="javascript:loadModule('reeltags/search.jsp');">Generate Reel Tags</a></li>
                    <% if(!user.isUserType(RTUser.USER_TYPE_CPE)) { %>
                    <li><a href="javascript:loadModule('pick_lists/search.jsp');">Manage Pick Lists</a></li>
                    <% } %>
                    <li><a href="javascript:loadModule('issues/search.jsp');">Manage Issues</a></li>
                <% } %>
                <% if (user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
                <li><a href="javascript:loadModule('shipping/search_vendor.jsp?clear=true');">Mark as Shipped</a></li>
                <li><a href="javascript:loadModule('reeltags/search_ordered.jsp');">Generate Reel Tags</a></li>
                <% } %>
            </ul>
          </li>
          <% } %>
          <% if(!user.isUserType(RTUser.USER_TYPE_INVENTORY)) { %>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Multiple Reels <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <% if (user!=null) { %>
              <li><a href="javascript:loadModule('shipping/search.jsp?clear=true');">Mark as Shipped</a></li>
                      <li><a href="javascript:loadModule('receive/search.jsp');">Receive Reels</a></li>
                     	<% if(!user.isUserType(RTUser.USER_TYPE_CPE)) { %>
                        <li><a href="javascript:loadModule('checkout/search.jsp');">Check OUT Reels</a></li>
                        <li><a href="javascript:loadModule('checkin/search.jsp');">Check IN Reels</a></li>
                      <% } %>
                      <li><a href="javascript:loadModule('complete/search.jsp');">Mark as Complete</a></li>
                      <li><a href="javascript:loadModule('scrapped/search.jsp');">Mark as Scrapped</a></li>
              <% } %>
            </ul>
          </li>
          <% } %>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Search for Reels <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <% if (user!=null) { %>
                <li><a href="javascript:loadModule('ordered/search.jsp');">Search Ordered</a></li>
                        <li><a href="javascript:loadModule('received/search.jsp');">Search Received</a></li>
                        <li><a href="javascript:loadModule('reels/search.jsp');">Search All</a></li>
                <% } %>
            </ul>
          </li>
          <% if(user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT) || user.isUserType(RTUser.USER_TYPE_STANDARD)) { %>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Job Set Up <b class="caret"></b></a>
            <ul class="dropdown-menu">
            <% if(!user.isUserType(RTUser.USER_TYPE_INVENTORY) && !user.isUserType(RTUser.USER_TYPE_STANDARD) && !user.isUserType(RTUser.USER_TYPE_CPE)) { %>
                <li><a href="javascript:loadModule('users2/search.jsp');">Manage Users</a></li>
                <li><a href="javascript:loadModule('foremans/search.jsp');">Manage Foremen</a></li>
            <% } %>
            <% if(!user.isUserType(RTUser.USER_TYPE_INVENTORY) && !user.isUserType(RTUser.USER_TYPE_CPE)) { %>
                <li><a href="javascript:loadModule('drivers/search.jsp');">Manage Drivers</a></li>
                <li><a href="javascript:loadModule('whlocations/search.jsp');">Manage Warehouse Locations</a></li>
            <% } %>
            </ul>
          </li>
          <% } %>

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Reports <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li><a href="javascript:loadModule('reports/reports.jsp');">Generate Reports</a></li>
            </ul>
          </li>
    <% } %>
          <li class="dropdown">
            <% if(!user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Extras <b class="caret"></b></a>
            <% } else { %>
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Vendor Portal <b class="caret"></b></a>
            <% } %>
            <ul class="dropdown-menu">
            <% if(!user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>  
              <li><a onclick="changeJob();">Select Job</a></li>
              <li class="divider"></li>
            <% } %>
            <% if(!user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
                <li><a href="javascript:loadModule('file_cabinets/search.jsp');">File Cabinet/Glossary</a></li>
      	     <% } %>
      	    <% if(user.isUserType(RTUser.USER_TYPE_VENDOR) || user.isUserType(RTUser.USER_TYPE_ECS)) { %>
                <li><a href="javascript:loadModule('shipping/search_vendor.jsp?clear=true');">Print Reel Tags</a></li>
                <li><a href="javascript:loadModule('glossary/vendor_videos.jsp');">Training Videos</a></li>
                <li><a href="javascript:loadModule('file_cabinets/vendor.jsp');">Printer Information</a></li>
      	    <% } %>
            </ul>
          </li>
    <% if(user.isUserType(RTUser.USER_TYPE_ECS)) { %>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">ECS Only <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li><a href="javascript:loadModule('customers/search.jsp');">Customers</a></li>
              <li><a href="javascript:loadModule('users/search.jsp');">ECS Users</a></li>
              <%--<li><a href="javascript:loadModule('demo/demo.jsp');">Demo Reset</a></li>--%>
            </ul>
          </li>
    <% } %>

<%--
    <li class="dropdown">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown">Microwork <b class="caret"></b></a>
      <ul class="dropdown-menu">
        <li><a href="javascript:loadModule('queues/eval_queue.jsp');">Evaluation Queue</a></li>
        <li><a href="javascript:loadModule('queues/hit_queue.jsp');">HIT Queue</a></li>
        <% if(!user.getUserType().equals(KredibleUser.USER_TYPE_MICROWORKER)) { %>
          <li><a href="javascript:loadModule('queues/microwork_reports.jsp');">Microwork Reports</a></li>
        <% } %>
        </ul>
    </li>
    <% if(!user.getUserType().equals(KredibleUser.USER_TYPE_MICROWORKER)) { %>
    <li class="dropdown">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown">Content <b class="caret"></b></a>
      <ul class="dropdown-menu">
        <li><a href="javascript:loadModule('content_matrix/search.jsp');">Content Matrices</a></li>
        <li><a href="javascript:loadModule('client_copies/search.jsp');">Client Copy</a></li>
        <li><a href="javascript:loadModule('participant_copies/search.jsp');">Participant Copy</a></li>
        <li><a href="javascript:loadModule('custom_widgets/search.jsp');">Custom Widgets</a></li>
        <li><a href="javascript:loadModule('documents/search.jsp');">Document Sets</a></li>
        <li><a href="javascript:loadModule('books/search.jsp');">Books</a></li>
        <li><a href="javascript:loadModule('book_shelfs/search.jsp');">Book Shelves</a></li>
        <li><a href="javascript:loadModule('showmehow/search.jsp');">Show Me How Videos</a></li>
        <li><a href="javascript:loadModule('messages/search.jsp');">AutoPilot Messages</a></li>
        <li><a href="javascript:loadModule('organization_tags/tags.jsp');">Organization Tags</a></li>
      </ul>
    </li>
    <li class="dropdown">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown">Credibility Factors <b class="caret"></b></a>
      <ul class="dropdown-menu">
        <li><a href="javascript:loadModule('factors/search.jsp');">Credibility Factors</a></li>
        <li><a href="javascript:loadModule('conditions/search.jsp');">CF Conditions</a></li>
        <li><a href="javascript:loadModule('impact_categories/search.jsp');">CF Impact Categories</a></li>
        <li><a href="javascript:loadModule('regex_patterns/search.jsp');">CF Regex Patterns</a></li>
        <li class="divider"></li>
        <li><a href="javascript:loadModule('goals/search.jsp');">Goals</a></li>
        <li><a href="javascript:loadModule('message_events/search.jsp');">AutoPilot Message Events</a></li>
      </ul>
    </li>
    <li class="dropdown">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown">Configuration <b class="caret"></b></a>
      <ul class="dropdown-menu">
        <li><a href="javascript:loadModule('system_icons/search.jsp');">System Icons</a></li>
        <li><a href="javascript:loadModule('industries/listing.jsp');">Industries</a></li>
        <li><a href="javascript:loadModule('proxy_hosts/search.jsp');">Proxy Hosts</a></li>
      </ul>
    </li>
    <li class="dropdown">
      <a href="#" class="dropdown-toggle" data-toggle="dropdown">People <b class="caret"></b></a>
      <ul class="dropdown-menu">
        <li><a href="javascript:loadModule('delivery_managers/search.jsp');">Delivery Managers</a></li>
        <li><a href="javascript:loadModule('users/search.jsp');">Kredible Users</a></li>
        <li><a href="javascript:loadModule('users/search_microworkers.jsp');">Micro Workers</a></li>
        <li><a href="javascript:loadModule('workteams/search.jsp');">Work Teams</a></li>
      </ul>
    </li>
    <% } %>
--%>
  </ul>
</div>

<% } %>
