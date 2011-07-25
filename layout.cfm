<cfif thisTag.executionMode is 'start'>
	<h1>global layout start</h1>
<cfelseif thisTag.executionMode is 'end'>
	<h1>global layout end</h1>
<cfelse>
	<cfexit method="exittag">
</cfif>
