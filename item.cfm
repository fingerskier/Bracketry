<cfset doItemAction = len(request.itemAction)>
<cfset doItemView = len(request.itemView)>

<cfoutput>
	<cfif doItemAction and doItemView>
		<cfmodule template="/auto-driller/#request.itemAction#">
 			<cfmodule template="/auto-driller/#request.itemView#" />
		</cfmodule>
	<cfelseif doItemAction>
		<cfmodule template="/auto-driller/#request.itemAction#" />
	<cfelse>
		<cfmodule template="/auto-driller/#request.itemView#" />
	</cfif>
</cfoutput>

<cfexit method="exittag">
