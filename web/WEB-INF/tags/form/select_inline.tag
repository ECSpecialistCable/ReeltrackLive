<%@ tag body-content="tagdependent"%>
<%@ tag description="Outputs a selectbox" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="name" required="true" %>


<select id="${name}" name="${name}">
    <jsp:doBody />
</select>