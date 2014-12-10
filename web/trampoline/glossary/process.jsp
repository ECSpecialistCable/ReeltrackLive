<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>
<%@ page import="com.monumental.trampoline.utilities.forms.multipart.MultipartRequest"%>
<%@ page import="java.io.File"%>
<%@ page import="com.reeltrack.glossary.GlossaryImporter"%>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.glossary.Glossary"%>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="glossaryMgr" class="com.reeltrack.glossary.GlossaryMgr" scope="request"/>
<jsp:useBean id="glossaryImporter" class="com.reeltrack.glossary.GlossaryImporter" scope="request"/>
<% securityMgr.init(dbResources); %>
<% glossaryMgr.init(pageContext,dbResources); %>
<% glossaryImporter.init(pageContext,dbResources); %>
<% CompProperties props = new CompProperties(); %>

<%
MultipartRequest multipart = null; 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

int contid = 0;
Glossary contentUpload = new Glossary();

if(request.getParameter(Glossary.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Glossary.PARAM));
}  else {
    String uploadDir = basePath + contentUpload.getComponentUploadDirectory()  + "/";
    File createDir = new File(uploadDir);
    if(!createDir.exists()) {
        createDir.mkdirs();
    }
    multipart = new MultipartRequest(request,uploadDir,330240000);
    if(multipart.getParameter("submit_action")!=null) {
        action = multipart.getParameter("submit_action");
    }
    if(multipart.getParameter(Glossary.PARAM)!=null) {
        contid = Integer.parseInt(multipart.getParameter(Glossary.PARAM));
    }
}


if(action.equals("create_reeltrack_glossary")) {
    Glossary content = new Glossary();
    content.setJobId(0);
    content.setName(request.getParameter(Glossary.NAME_COLUMN));
    content.setDescription(request.getParameter(Glossary.DESCRIPTION_COLUMN));
	content.setGlossaryType(request.getParameter(Glossary.GLOSSARY_TYPE_COLUMN));
    content.setStatus(Glossary.STATUS_ACTIVE);
    
    contid = glossaryMgr.addGlossary(content);
    //redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid;
    redirect = request.getContextPath() + "/trampoline/" + "glossary/reeltrack_glossary.jsp";
}


if(action.equals("delete_reeltrack_glossary")) {
    Glossary content = new Glossary();
    content.setId(Integer.parseInt(request.getParameter(Glossary.PARAM)));
    glossaryMgr.deleteGlossary(content, null);
    redirect = request.getContextPath() + "/trampoline/" + "glossary/reeltrack_glossary.jsp";
}


if(action.equals("update_reeltrack_glossary")) {
    Glossary content = new Glossary();
    if(request.getParameter(Glossary.PARAM) != null) {
        contid = Integer.parseInt(request.getParameter(Glossary.PARAM));
        if(contid != 0) {
			 content.setName(request.getParameter(Glossary.NAME_COLUMN));
			 content.setDescription(request.getParameter(Glossary.DESCRIPTION_COLUMN));
			 content.setGlossaryType(request.getParameter(Glossary.GLOSSARY_TYPE_COLUMN));
             content.setId(contid);
            
            glossaryMgr.updateGlossary(content);
        }
    }
    redirect = request.getContextPath() + "/trampoline/" + "glossary/edit.jsp?" + Glossary.PARAM + "=" + content.getId() ;
}


if(action.equals("create_job_glossary")) {
	int jobId = 0;
	if(session.getAttribute("LoggedInJobId")!=null) {
		jobId = Integer.parseInt(session.getAttribute("LoggedInJobId").toString());
	}
	if(jobId!=0) {
		Glossary content = new Glossary();
		content.setJobId(jobId);
		content.setName(request.getParameter(Glossary.NAME_COLUMN));
		content.setDescription(request.getParameter(Glossary.DESCRIPTION_COLUMN));
		content.setGlossaryType(request.getParameter(Glossary.GLOSSARY_TYPE_COLUMN));
		content.setStatus(Glossary.STATUS_ACTIVE);

		contid = glossaryMgr.addGlossary(content);
	}
    //redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid;
    redirect = request.getContextPath() + "/trampoline/" + "glossary/job_glossary.jsp";
}


if(action.equals("delete_job_glossary")) {
    Glossary content = new Glossary();
    content.setId(Integer.parseInt(request.getParameter(Glossary.PARAM)));
    glossaryMgr.deleteGlossary(content, null);
    redirect = request.getContextPath() + "/trampoline/" + "glossary/job_glossary.jsp";
}


if(action.equals("update_job_glossary")) {
    int jobId = 0;
	if(session.getAttribute("LoggedInJobId")!=null) {
		jobId = Integer.parseInt(session.getAttribute("LoggedInJobId").toString());
	}
	Glossary content = new Glossary();
    if(jobId!=0 && request.getParameter(Glossary.PARAM) != null) {
        contid = Integer.parseInt(request.getParameter(Glossary.PARAM));
        if(contid != 0) {
		     content.setJobId(jobId);
			 content.setName(request.getParameter(Glossary.NAME_COLUMN));
			 content.setDescription(request.getParameter(Glossary.DESCRIPTION_COLUMN));
			 content.setGlossaryType(request.getParameter(Glossary.GLOSSARY_TYPE_COLUMN));
             content.setId(contid);

            glossaryMgr.updateGlossary(content);
        }
    }
    redirect = request.getContextPath() + "/trampoline/" + "glossary/edit.jsp?" + Glossary.PARAM + "=" + content.getId() ;
}

if(action.equals("import_glossary")) {
	File file = multipart.getFile("glossary_imported_file");
	if(file!=null) {
		try {
			glossaryImporter.getContents(file);
		} catch(Exception e) {e.printStackTrace();}
	}
    redirect = request.getContextPath() + "/trampoline/" + "glossary/reeltrack_glossary.jsp";
}

%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />