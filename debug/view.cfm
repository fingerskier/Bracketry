<cfif URL.scope contains 'Log'>
	<cfset thisn = evaluate(URL.scope & '[#URL.key#]')>
<cfelse>
	<cfset thisn = evaluate(URL.scope & '.' & URL.key)>
</cfif>

<cfdump var="#thisn#">
