/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.15
 * Generated at: 2016-09-30 11:01:40 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.tag.webadmin;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class subtitle_tag
    extends javax.servlet.jsp.tagext.SimpleTagSupport
    implements org.apache.jasper.runtime.JspSourceDependent,
               javax.servlet.jsp.tagext.DynamicAttributes {


  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

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
  private java.lang.String text;
  private java.lang.String cssClass;
  private java.lang.String id;
  private java.lang.String toggleTarget;
  private java.lang.String toggleOpen;
  private java.lang.String lightboxLink;
  private java.lang.String url;

  public java.lang.String getText() {
    return this.text;
  }

  public void setText(java.lang.String text) {
    this.text = text;
    jspContext.setAttribute("text", text);
  }

  public java.lang.String getCssClass() {
    return this.cssClass;
  }

  public void setCssClass(java.lang.String cssClass) {
    this.cssClass = cssClass;
    jspContext.setAttribute("cssClass", cssClass);
  }

  public java.lang.String getId() {
    return this.id;
  }

  public void setId(java.lang.String id) {
    this.id = id;
    jspContext.setAttribute("id", id);
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

  public java.lang.String getLightboxLink() {
    return this.lightboxLink;
  }

  public void setLightboxLink(java.lang.String lightboxLink) {
    this.lightboxLink = lightboxLink;
    jspContext.setAttribute("lightboxLink", lightboxLink);
  }

  public java.lang.String getUrl() {
    return this.url;
  }

  public void setUrl(java.lang.String url) {
    this.url = url;
    jspContext.setAttribute("url", url);
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
    if( getText() != null ) 
      _jspx_page_context.setAttribute("text", getText());
    if( getCssClass() != null ) 
      _jspx_page_context.setAttribute("cssClass", getCssClass());
    if( getId() != null ) 
      _jspx_page_context.setAttribute("id", getId());
    if( getToggleTarget() != null ) 
      _jspx_page_context.setAttribute("toggleTarget", getToggleTarget());
    if( getToggleOpen() != null ) 
      _jspx_page_context.setAttribute("toggleOpen", getToggleOpen());
    if( getLightboxLink() != null ) 
      _jspx_page_context.setAttribute("lightboxLink", getLightboxLink());
    if( getUrl() != null ) 
      _jspx_page_context.setAttribute("url", getUrl());
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
      out.write("<h2 class=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${cssClass}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write(' ');
 if(toggleTarget!=null) {
      out.write(" toggle_trigger ");
 if(toggleOpen != null && toggleOpen == "true"){ 
      out.write(" toggleIsOpen ");
 } else {
      out.write(" toggleIsClosed ");
 } 
      out.write(' ');
 } 
      out.write("\"\n");
      out.write("\t\n");
      out.write("\t");
 if(toggleTarget!=null){ 
      out.write(" \n");
      out.write("\t\trel=\".");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${toggleTarget}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write('"');
      out.write('\n');
      out.write('	');
 } 
      out.write(" \n");
      out.write("\t\n");
      out.write("\t");
 if(id!=null) { 
      out.write("\n");
      out.write("\t \tid=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${id}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write('"');
      out.write('\n');
      out.write('	');
 } 
      out.write(" \n");
      out.write("\t>\n");
      out.write("\t\n");
      out.write("\t");
 if(lightboxLink != null && lightboxLink == "true"){ 
      out.write("\n");
      out.write("\t\t<a href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${url}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write("\" class=\"lightbox_link\" target=\"_blank\">\n");
      out.write("\t");
 } 
      out.write('\n');
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${text}", java.lang.String.class, (javax.servlet.jsp.PageContext)this.getJspContext(), null));
      out.write('\n');
      out.write('	');
 if(lightboxLink != null && lightboxLink == "true"){ 
      out.write("\n");
      out.write("\t</a>\n");
      out.write("\t");
 } 
      out.write("\n");
      out.write("</h2>");
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
