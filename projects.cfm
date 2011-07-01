<cfset projects = entityload("project")>

<cfoutput>
	Projects
	<br>
	<br>
	<cfloop array="#projects#" index="project">
		<a class="projectLink" href="project.cfm?projectID=#project.getID()#">#project.getName()#</a>
		<br>
	</cfloop>
	<br>
	<a class="projectLink" href="project.cfm?projectID=-7">New Project</a>
</cfoutput>
