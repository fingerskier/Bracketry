<cfif thisTag.executionMode is 'start'>
	<h1>global action start</h1>
<cfelseif thisTag.executionMode is 'end'>
	<h1>global action end</h1>
<cfelse>
	<cfexit method="exittag">
</cfif>
