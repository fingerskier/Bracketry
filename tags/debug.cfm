<cfparam name="application.debugLog" default="#arrayNew(1)#" type="array">

<cfloop collection="#attributes#" item="I">
	<cfset tuple = structNew()>
	<cfset tuple.name = "#I#">
	<cfset tuple.value = evaluate("attributes.#I#")>

	<cfset arrayAppend(application.debugLog, tuple)>
</cfloop>

<cfexit method="exittag">
