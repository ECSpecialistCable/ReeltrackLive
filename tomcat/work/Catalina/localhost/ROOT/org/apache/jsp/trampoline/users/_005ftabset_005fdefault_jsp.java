/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.15
 * Generated at: 2016-08-30 13:04:09 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.trampoline.users;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.reeltrack.users.*;

public final class _005ftabset_005fdefault_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      com.reeltrack.users.RTUserLoginMgr userLoginMgr = null;
      userLoginMgr = (com.reeltrack.users.RTUserLoginMgr) _jspx_page_context.getAttribute("userLoginMgr", javax.servlet.jsp.PageContext.PAGE_SCOPE);
      if (userLoginMgr == null){
        userLoginMgr = new com.reeltrack.users.RTUserLoginMgr();
        _jspx_page_context.setAttribute("userLoginMgr", userLoginMgr, javax.servlet.jsp.PageContext.PAGE_SCOPE);
      }
      out.write('\n');
 userLoginMgr.init(pageContext); 
      out.write('\n');
 RTUser user = (RTUser)userLoginMgr.getUser(); 
      out.write('\n');
      out.write('\n');
      if (_jspx_meth_admin_005ftab_005f0(_jspx_page_context))
        return;
      out.write('\n');
      if (_jspx_meth_admin_005ftab_005f1(_jspx_page_context))
        return;
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
    // /trampoline/users/_tabset_default.jsp(10,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005ftab_005f0.setUrl("users/search.jsp");
    // /trampoline/users/_tabset_default.jsp(10,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005ftab_005f0.setText("Users");
    _jspx_th_admin_005ftab_005f0.doTag();
    _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f0);
    return false;
  }

  private boolean _jspx_meth_admin_005ftab_005f1(javax.servlet.jsp.PageContext _jspx_page_context)
          throws java.lang.Throwable {
    javax.servlet.jsp.PageContext pageContext = _jspx_page_context;
    javax.servlet.jsp.JspWriter out = _jspx_page_context.getOut();
    //  admin:tab
    org.apache.jsp.tag.webadmin.tab_tag _jspx_th_admin_005ftab_005f1 = (new org.apache.jsp.tag.webadmin.tab_tag());
    _jsp_instancemanager.newInstance(_jspx_th_admin_005ftab_005f1);
    _jspx_th_admin_005ftab_005f1.setJspContext(_jspx_page_context);
    // /trampoline/users/_tabset_default.jsp(11,0) name = url type = java.lang.String reqTime = true required = false fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005ftab_005f1.setUrl("users/create.jsp");
    // /trampoline/users/_tabset_default.jsp(11,0) name = text type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005ftab_005f1.setText("Add User");
    _jspx_th_admin_005ftab_005f1.doTag();
    _jsp_instancemanager.destroyInstance(_jspx_th_admin_005ftab_005f1);
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
    // /trampoline/users/_tabset_default.jsp(13,0) name = url type = java.lang.String reqTime = true required = true fragment = false deferredValue = false expectedTypeName = java.lang.String deferredMethod = false methodSignature = null
    _jspx_th_admin_005fset_005fmoduleactions_005f0.setUrl("users/_moduleactions.jsp");
    _jspx_th_admin_005fset_005fmoduleactions_005f0.doTag();
    _jsp_instancemanager.destroyInstance(_jspx_th_admin_005fset_005fmoduleactions_005f0);
    return false;
  }
}
