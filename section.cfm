<cfif thisTag.executionMode is 'start'>
	<cfset doSectionAction = len(request.sectionAction)>
	<cfset doSectionLayout = len(request.sectionLayout)>

	<cfif doSectionAction and doSectionLayout>
		<cfmodule template="/auto-driller/#request.sectionAction#">
			<cfmodule template="/auto-driller/#request.sectionLayout#">
				<cf_item />
			</cfmodule>
		</cfmodule>
	<cfelseif doSectionAction>
		<cfmodule template="/auto-driller/#request.sectionAction#">
			<cf_item />
		</cfmodule>
	<cfelseif doSectionLayout>
		<cfmodule template="/auto-driller/#request.sectionLayout#">
			<cf_item />
		</cfmodule>
	<cfelse>
		<cf_item />
	</cfif>
<cfelseif thisTag.executionMode is 'end'>
<cfelse>
	<cfexit method="exittag">
</cfif>
