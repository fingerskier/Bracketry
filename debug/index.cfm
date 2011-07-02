<cfif NOT isDefined("application.debugLog")>
	<cfset application.debugLog = arrayNew(1)>
</cfif>

<cfif NOT isDefined("application.errorLog")>
	<cfset application.errorLog = arrayNew(1)>
</cfif>

<cfajaximport tags="CFFORM">

<cflayout height="" style="float: left;" type="accordion" width="222">
	<cflayoutarea refreshonactivate="true" source="nav.cfc?method=errorNav" title="Errors" />
	<cflayoutarea refreshonactivate="true" source="nav.cfc?method=debugNav" title="Debugs" />
	<cflayoutarea refreshonactivate="true" source="nav.cfc?method=sessionNav" title="Session" />
	<cflayoutarea refreshonactivate="true" source="nav.cfc?method=clientNav" title="Client" />
	<cflayoutarea refreshonactivate="true" source="nav.cfc?method=applicationNav" title="Application" />
	<cflayoutarea refreshonactivate="true" source="nav.cfc?method=cookieNav" title="Cookies" />
	<cflayoutarea refreshonactivate="true" source="nav.cfc?method=serverNav" title="Server" />
</cflayout>

<cfdiv id="viewer" style="border: thin solid green; float: left; width: 666px;" />
