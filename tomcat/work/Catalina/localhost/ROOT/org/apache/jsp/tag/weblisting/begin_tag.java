/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.15
 * Generated at: 2016-08-30 10:36:40 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.tag.weblisting;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class begin_tag
    extends javax.servlet.jsp.tagext.SimpleTagSupport
    implements org.apache.jasper.runtime.JspSourceDependent,
               javax.servlet.jsp.tagext.DynamicAttributes {


  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/WEB-INF/lib/standard.jar", Long.valueOf(1472002170000L));
    _jspx_dependants.put("jar:file:/www/new/tomcat/webapps/../../web/WEB-INF/lib/standard.jar!/META-INF/c.tld", Long.valueOf(1098725490000L));
  }

  private javax.servlet.jsp.JspContext jspContext;
  private java.io.Writer _jspx_sout;
  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public void setJspContext(javax.servlet.jsp.JspContext ctx) {
    super.setJspContext(ctx);
    java.util.ArrayList _jspx_nested = null;
    java.util.ArrayList _jspx_at_begin = null;
    java.util.ArrayList _jspx_at_end = null;
    this.jspContext = new org.apache.jasper.runtime.JspContextWrapper(ctx, _jspx_nested, _jspx_at_begin, _jspx_at_end, null);
  }

  public javax.servlet.jsp.JspContext getJspContext() {
    return this.jspContext;
  }
  private java.util.HashMap _jspx_dynamic_attrs = new java.util.HashMap();
  private java.lang.String cssClass;
  private java.lang.String toggleTarget;
  private java.lang.String toggleOpen;
  private java.lang.String toggleRecipient;
  private java.lang.String id;
  private java.lang.String rel;
  private java.lang.String style;

  public java.lang.String getCssClass() {
    return this.cssClass;
  }

  public void setCssClass(java.lang.String cssClass) {
    this.cssClass = cssClass;
    jspContext.setAttribute("cssClass", cssClass);
  }

  public java.lang.String getToggleTarget() {
    return this.toggleTarget;
  }

  public void setToggleTarget(java.lang.String toggleTarget) {
    this.toggleTarget = toggleTarget;
    jspContext.setAttribute("toggleTarget", toggleTarget);
  }

  public java.lang.String getToggleOpen() {
    return this.toggleOpen;
  }

  public void setToggleOpen(java.lang.String toggleOpen) {
    this.toggleOpen = toggleOpen;
    jspContext.setAttribute("toggleOpen", toggleOpen);
  }

  public java.lang.String getToggleRecipient() {
    return this.toggleRecipient;
  }

  public void setToggleRecipient(java.lang.String toggleRecipient) {
    this.toggleRecipient = toggleRecipient;
    jspContext.setAttribute("toggleRecipient", toggleRecipient);
  }

  public java.lang.String getId() {
    return this.id;
  }

  public void setId(java.lang.String id) {
    this.id = id;
    jspContext.setAttribute("id", id);
  }

  public java.lang.String getRel() {
    return this.rel;
  }

  public void setRel(java.lang.String rel) {
    this.rel = rel;
    jspContext.setAttribute("rel", rel);
  }

  public java.lang.String getStyle() {
    return this.style;
  }

  public void setStyle(java.lang.String style) {
    this.style = style;
    jspContext.setAttribute("style", style);
  }

  public void setDynamicAttribute(java.lang.String uri, java.lang.String localName, java.lang.Object value) throws javax.servlet.jsp.JspException {
    if (uri == null)
      _jspx_dynamic_attrs.put(localName, value);
  }
  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  private void _jspInit(javax.servlet.ServletConfig config) {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(config.getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(config);
  }

  public void _jspDestroy() {
  }

  public void doTag() throws javax.servlet.jsp.JspException, java.io.IOException {
    javax.servlet.jsp.PageContext _jspx_page_context = (javax.servlet.jsp.PageContext)jspContext;
    javax.servlet.http.HttpServletRequest request = (javax.servlet.http.HttpServletRequest) _jspx_page_context.getRequest();
    javax.servlet.http.HttpServletResponse response = (javax.servlet.http.HttpServletResponse) _jspx_page_context.getResponse();
    javax.servlet.http.HttpSession session = _jspx_page_context.getSession();
    javax.servlet.ServletContext application = _jspx_page_context.getServletContext();
    javax.servlet.ServletConfig config = _jspx_page_context.getServletConfig();
    javax.servlet.jsp.JspWriter out = jspContext.getOut();
    _jspInit(config);
    jspContext.getELContext().putContext(javax.servlet.jsp.JspContext.class,jspContext);
    if( getCssClass() != null ) 
      _jspx_page_context.setAttribute("cssClass", getCssClass());
    if( getToggleTarget() != null ) 
      _jspx_page_context.setAttribute("toggleTarget", getToggleTarget());
    if( getToggleOpen() != null ) 
      _jspx_page_context.setAttribute("toggleOpen", getToggleOpen());
    if( getToggleRecipient() != null ) 
      _jspx_page_context.setAttribute("toggleRecipient", getToggleRecipient());
    if( getId() != null ) 
      _jspx_page_context.setAttribute("id", getId());
    if( getRel() != null ) 
      _jspx_page_context.setAttribute("rel", getRel());
    if( getStyle() != null ) 
      _jspx_page_context.setAttribute("style", getStyle());
    _jspx_page_context.setAttribute("attribs", _jspx_dynamic_attrs);
    try {
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<div class=\"table-responsive\">\n");
      out.write("<table class=\"table table-striped\" style=\"border-bottom:1px solid #dddddd;;");
 if(style!=null) { 
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${style}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
 } 
      out.write('"');
      out.write('>');
    } catch( java.lang.Throwable t ) {
      if( t instanceof javax.servlet.jsp.SkipPageException )
          throw (javax.servlet.jsp.SkipPageException) t;
      if( t instanceof java.io.IOException )
          throw (java.io.IOException) t;
      if( t instanceof java.lang.IllegalStateException )
          throw (java.lang.IllegalStateException) t;
      if( t instanceof javax.servlet.jsp.JspException )
          throw (javax.servlet.jsp.JspException) t;
      throw new javax.servlet.jsp.JspException(t);
    } finally {
      jspContext.getELContext().putContext(javax.servlet.jsp.JspContext.class,super.getJspContext());
      ((org.apache.jasper.runtime.JspContextWrapper) jspContext).syncEndTagFile();
    }
  }
}
