/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.15
 * Generated at: 2016-08-30 10:38:16 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.trampoline.reels;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.monumental.trampoline.component.*;
import com.monumental.trampoline.security.*;
import com.reeltrack.reels.*;
import com.reeltrack.users.*;

public final class _005ftabset_005fmanage_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/tags/admin/tab.tag", Long.valueOf(1472002192000L));
    _jspx_dependants.put("/WEB-INF/tags/admin/set_moduleactions.tag", Long.valueOf(1472002192000L));
  }

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

final java.lang.String _jspx_method = request.getMethod();
if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET POST or HEAD");
return;
}

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      com.monumental.trampoline.datasources.DbResources dbResources = null;
      dbResources = (com.monumental.trampoline.datasources.DbResources) _jspx_page_context.getAttribute("dbResources", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (dbResources == null){
        dbResources = new com.monumental.trampoline.datasources.DbResources();
        _jspx_page_context.setAttribute("dbResources", dbResources, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
      com.reeltrack.reels.ReelMgr reelMgr = null;
      reelMgr = (com.reeltrack.reels.ReelMgr) _jspx_page_context.getAttribute("reelMgr", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (reelMgr == null){
        reelMgr = new com.reeltrack.reels.ReelMgr();
        _jspx_page_context.setAttribute("reelMgr", reelMgr, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
 reelMgr.init(pageContext,dbResources); 
      out.write('\n');
      out.write('\n');

    String param = "content_id_for_tabset";
    String paramstring = "";
    String paramstring2 = "";
    String paramstring3 = "";
    String paramstring4 = "";
	if(request.getParameter(param) != null) {
		paramstring = "?" + param + "=" + request.getParameter(param);
	}

	Reel reel = new Reel();
	reel.setId(Integer.parseInt(request.getParameter(param)));
	reel = reelMgr.getReelByNextCrid(reel);
	if(reel!=null && reel.getId()!=0) {
		paramstring2 = "?" + param + "=" + reel.getId();
	}

	Reel reel2 = new Reel();
	reel2.setId(Integer.parseInt(request.getParameter(param)));
	reel2 = reelMgr.getReelByLastCrid(reel2);
	if(reel2!=null && reel2.getId()!=0) {
		paramstring3 = "?" + param + "=" + reel2.getId();
	}

	Reel reel3 = new Reel();
	reel3.setId(Integer.parseInt(request.getParameter(param)));
	reel3 = reelMgr.getReelByPreviousCrid(reel3);
	if(reel3!=null && reel3.getId()!=0) {
		paramstring4 = "?" + param + "=" + reel3.getId();
	}



      out.write('\n');
 dbResources.close(); 
      out.write('\n');
      out.write('\n');
      if (_jspx_meth_admin_005ftab_005f0(_jspx_page_context))
        return;
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f1 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f1);
      _jspx_th_admin_005ftab_005f1.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(49,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f1.setUrl("reels/cable_data.jsp");
      // /trampoline/reels/_tabset_manage.jsp(49,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f1.setText("Cable Data");
      // /trampoline/reels/_tabset_manage.jsp(49,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f1.setParams( paramstring );
      _jspx_th_admin_005ftab_005f1.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f1);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f2 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f2);
      _jspx_th_admin_005ftab_005f2.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(50,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f2.setUrl("reels/status.jsp");
      // /trampoline/reels/_tabset_manage.jsp(50,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f2.setText("Status");
      // /trampoline/reels/_tabset_manage.jsp(50,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f2.setParams( paramstring );
      _jspx_th_admin_005ftab_005f2.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f2);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f3 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f3);
      _jspx_th_admin_005ftab_005f3.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(51,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f3.setUrl("reels/edit.jsp");
      // /trampoline/reels/_tabset_manage.jsp(51,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f3.setText("Edit");
      // /trampoline/reels/_tabset_manage.jsp(51,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f3.setParams( paramstring );
      _jspx_th_admin_005ftab_005f3.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f3);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f4 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f4);
      _jspx_th_admin_005ftab_005f4.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(52,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f4.setUrl("reels/quantity.jsp");
      // /trampoline/reels/_tabset_manage.jsp(52,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f4.setText("Quantity");
      // /trampoline/reels/_tabset_manage.jsp(52,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f4.setParams( paramstring );
      _jspx_th_admin_005ftab_005f4.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f4);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f5 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f5);
      _jspx_th_admin_005ftab_005f5.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(53,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f5.setUrl("reels/circuits.jsp");
      // /trampoline/reels/_tabset_manage.jsp(53,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f5.setText("Circuits");
      // /trampoline/reels/_tabset_manage.jsp(53,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f5.setParams( paramstring );
      _jspx_th_admin_005ftab_005f5.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f5);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f6 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f6);
      _jspx_th_admin_005ftab_005f6.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(54,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f6.setUrl("reels/issues.jsp");
      // /trampoline/reels/_tabset_manage.jsp(54,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f6.setText("Issues");
      // /trampoline/reels/_tabset_manage.jsp(54,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f6.setParams( paramstring );
      _jspx_th_admin_005ftab_005f6.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f6);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f7 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f7);
      _jspx_th_admin_005ftab_005f7.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(55,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f7.setUrl("reels/notes.jsp");
      // /trampoline/reels/_tabset_manage.jsp(55,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f7.setText("Notes");
      // /trampoline/reels/_tabset_manage.jsp(55,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f7.setParams( paramstring );
      _jspx_th_admin_005ftab_005f7.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f7);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f8 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f8);
      _jspx_th_admin_005ftab_005f8.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(56,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f8.setUrl("reels/log.jsp");
      // /trampoline/reels/_tabset_manage.jsp(56,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f8.setText("Log");
      // /trampoline/reels/_tabset_manage.jsp(56,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f8.setParams( paramstring );
      _jspx_th_admin_005ftab_005f8.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f8);
      out.write('\n');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f9 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f9);
      _jspx_th_admin_005ftab_005f9.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(57,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f9.setUrl("reels/reel_data.jsp");
      // /trampoline/reels/_tabset_manage.jsp(57,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f9.setText("Reel Data");
      // /trampoline/reels/_tabset_manage.jsp(57,0) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f9.setParams( paramstring );
      _jspx_th_admin_005ftab_005f9.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f9);
      out.write('\n');
 if(reel3!=null && reel3.getId()!=0) { 
      out.write('\n');
      out.write('	');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f10 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f10);
      _jspx_th_admin_005ftab_005f10.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(59,1) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f10.setUrl("reels/status.jsp");
      // /trampoline/reels/_tabset_manage.jsp(59,1) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f10.setText("<span class='glyphicon glyphicon-backward'></span>");
      // /trampoline/reels/_tabset_manage.jsp(59,1) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f10.setParams( paramstring4 );
      _jspx_th_admin_005ftab_005f10.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f10);
      out.write('\n');
 } 
      out.write('\n');
 if(reel!=null && reel.getId()!=0) { 
      out.write('\n');
      out.write('	');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f11 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f11);
      _jspx_th_admin_005ftab_005f11.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(62,1) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f11.setUrl("reels/status.jsp");
      // /trampoline/reels/_tabset_manage.jsp(62,1) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f11.setText("<span class='glyphicon glyphicon-forward'></span>");
      // /trampoline/reels/_tabset_manage.jsp(62,1) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f11.setParams( paramstring2 );
      _jspx_th_admin_005ftab_005f11.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f11);
      out.write('\n');
 } 
      out.write('\n');
 if(reel2!=null && reel2.getId()!=0) { 
      out.write('\n');
      out.write('	');
      //  admin:tab
      org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f12 = (new org.apache.jsp.tag.webadmin.tab_tag());
      _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f12);
      _jspx_th_admin_005ftab_005f12.setJspContext(_jspx_page_context);
      // /trampoline/reels/_tabset_manage.jsp(65,1) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f12.setUrl("reels/status.jsp");
      // /trampoline/reels/_tabset_manage.jsp(65,1) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f12.setText("<span class='glyphicon glyphicon-step-forward'></span>");
      // /trampoline/reels/_tabset_manage.jsp(65,1) name = params type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
      _jspx_th_admin_005ftab_005f12.setParams( paramstring3 );
      _jspx_th_admin_005ftab_005f12.doTag();
      _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f12);
      out.write('\n');
 } 
      out.write('\n');
      out.write('\n');
      out.write('\n');
      if (_jspx_meth_admin_005fset_005fmoduleactions_005f0(_jspx_page_context))
        return;
      out.write('\n');
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }

  private boolean _jspx_meth_admin_005ftab_005f0(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  admin:tab
    org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f0 = (new org.apache.jsp.tag.webadmin.tab_tag());
    _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f0);
    _jspx_th_admin_005ftab_005f0.setJspContext(_jspx_page_context);
    // /trampoline/reels/_tabset_manage.jsp(48,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005ftab_005f0.setUrl("reels/search.jsp");
    // /trampoline/reels/_tabset_manage.jsp(48,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005ftab_005f0.setText("<span class='glyphicon glyphicon-search'></span>");
    _jspx_th_admin_005ftab_005f0.doTag();
    _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f0);
    return false;
  }

  private boolean _jspx_meth_admin_005fset_005fmoduleactions_005f0(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  admin:set_moduleactions
    org.apache.jsp.tag.webadmin.set_005fmoduleactions_tag _jspx_th_admin_005fset_005fmoduleactions_005f0 = (new org.apache.jsp.tag.webadmin.set_005fmoduleactions_tag());
    _jsp_instancemanager.newInstance(_jspx_th_admin_005fset_005fmoduleactions_005f0);
    _jspx_th_admin_005fset_005fmoduleactions_005f0.setJspContext(_jspx_page_context);
    // /trampoline/reels/_tabset_manage.jsp(69,0) name = url type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005fset_005fmoduleactions_005f0.setUrl("reel_inventory/_moduleactions.jsp");
    _jspx_th_admin_005fset_005fmoduleactions_005f0.doTag();
    _jsp_instancemanager.destroyInstance(_jspx_th_admin_005fset_005fmoduleactions_005f0);
    return false;
  }
}