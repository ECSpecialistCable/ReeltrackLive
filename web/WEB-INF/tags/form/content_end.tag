
<%@ attribute name="helpText" required="false" %>

<c:if test="${helpText != ''}">
  <p class="help-block" style="margin-bottom:0;color:darkgray;">${helpText}</p>
</c:if>
</div>