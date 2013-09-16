<%@ page language="java" %>		
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<jsp:useBean id="secureUserLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr"/>
<% secureUserLoginMgr.init(pageContext); %>
<%-- 

	only_users protect accessing a page when not logged in.
	guards against calling a page directly
	as well as via ajax within the interface

--%>
<% if(!secureUserLoginMgr.isLoggedIn()) { %>
	<script type="text/javascript" language="javascript">
			// first, if we're in the _submissionFrame, call window location on the parent
			parent.window.location = "<%= request.getContextPath() %>/trampoline/index.jsp";
	
			// otherwise, we'll be doing this on this window
			window.location = "<%= request.getContextPath() %>/trampoline/index.jsp";
	</script>
<% } %>
<% if(!secureUserLoginMgr.isLoggedIn()) return; %>
