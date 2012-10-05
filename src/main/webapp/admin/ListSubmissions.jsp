<%@ page import="java.util.*" %>
<%@ page import="edu.ucsf.mousedatabase.*" %>
<%@ page import="edu.ucsf.mousedatabase.objects.*" %>
<%@page import="static edu.ucsf.mousedatabase.HTMLGeneration.*" %>
<%=getPageHeader(null,false,true) %>
<%=getNavBar("ListSubmissions.jsp", true) %>
<%@ include file='SendMailForm.jspf' %>
<%

  String orderBy = request.getParameter("orderby");
  String entered = request.getParameter("entered");
  String status = request.getParameter("status");

  if (orderBy == null) {
    orderBy = "submittedmouse.id";
  }

  if (entered!= null && entered.equalsIgnoreCase("null")) {
    entered = null;
  }


    /******/
  if (status == null) {
    if ((status = (String)session.getAttribute("listSubmissionStatus")) == null) {
      status = "new";
    }
  }
  if (status.equalsIgnoreCase("need")) {
      status = "need more info";
  }
  session.setAttribute("listSubmissionStatus",status);
  session.setAttribute("listSubmissionOrderBy",orderBy);

  ArrayList<SubmittedMouse> submissions = DBConnect.getMouseSubmissions(status, entered, orderBy);

  String[] sortOptions = new String[] {"submittedmouse.id","date","date DESC","mouse.id","mouse.id DESC", "firstname","lastname"};
  String[] sortOptionNiceNames = new String[] {"Submission #", "Submission date","Reverse Submission date", "Record #", "Reverse Record #","Submitter first name", "Submitter last name"};

  String[] filterOptions = new String[] {"new","need more info","rejected","accepted","all"};
  String[] filterOptionNiceNames = new String[] {"New", "Hold", "Rejected","Converted to records","All"};

  int kount = submissions.size();


  String table = getSubmissionTable(submissions, status, entered);

  StringBuffer sortBuf = new StringBuffer();
  sortBuf.append("<form class='view_opts' action='ListSubmissions.jsp' method='get'>");
  sortBuf.append("&nbsp;Show: ");
  sortBuf.append(genSelect("status",filterOptions,filterOptionNiceNames, status,""));
  sortBuf.append("&nbsp;Sort by: ");
  sortBuf.append(genSelect("orderby",sortOptions,sortOptionNiceNames, orderBy,""));
  sortBuf.append("<input type='hidden' name='entered' value='" + entered +"'>");
  sortBuf.append("</form>");


  String statusString = status + " submissions";
  if(status.startsWith("need")) {
    statusString = "submissions on hold";
    status="need";
  }
  else if(status.startsWith("accepted"))
  {
    statusString = "submissions that have been converted to records";
  }
  session.setAttribute("listSubmissionsLastQuery","?status=" + status + "&orderby=" + orderBy);
  session.setAttribute("listSubmissionsLastTitle",statusString);
  statusString = "Listing " + statusString;
%>

<div class="site_container">
<h2><%= statusString %></h2>
<h4><%= kount %> found.</h4>
<%= sortBuf.toString()%>
<%= table%>
</div>
