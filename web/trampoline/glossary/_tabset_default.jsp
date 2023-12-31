<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% String label = user.getCustomerName() + " Files"; %>

<% if(user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
<admin:tab url="glossary/vendor_videos.jsp" text="Vendor Training Videos" />
<admin:tab url="file_cabinets/vendor.jsp" text="Printer Information" />
<% } else { %>
<admin:tab url="file_cabinets/search.jsp" text="ECS Files" />
<admin:tab url="file_cabinets/customer.jsp" text="<%= label %>" />
<admin:tab url="glossary/reeltrack_glossary.jsp" text="Glossary" />
<admin:tab url="glossary/job_glossary.jsp" text="Job Glossary" />
<admin:tab url="glossary/reeltrack_videos.jsp" text="Training" />
<% } %>
<%--<admin:tab url="glossary/import_glossary.jsp" text="Import Glossary" />--%>
<% if(user.isUserType(RTUser.USER_TYPE_ECS)) { %>
<admin:tab url="glossary/vendor_videos.jsp" text="Vendor Portal Training" />
<admin:tab url="file_cabinets/vendor.jsp" text="Printer Info" />
<% } %>

<admin:set_moduleactions url="glossary/_moduleactions.jsp" />
