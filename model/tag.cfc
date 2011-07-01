component persistent="true" {
	property name="ID" fieldtype="id" generated="always" generator="increment" ormtype="integer" type="numeric";
	property name="created" fieldtype="timestamp" ormtype="timestamp" setter="false";
	property name="updated" ormtype="timestamp" setter="false";

	property name="module" cfc="module" fieldtype="many-to-one" fkcolumn="moduleID";

	property name="name" ormtype="string";
}
