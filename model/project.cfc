component persistent="true" {
	property name="ID" fieldtype="id" generated="always" generator="increment" ormtype="integer" type="numeric";
	property name="created" fieldtype="timestamp" ormtype="timestamp" setter="false";
	property name="updated" ormtype="timestamp" setter="false";

	property name="name" default="" ormtype="string";
	property name="path" ormtype="string";

	private function preUpdate(Struct oldData) {
		variables.updated = createODBCDateTime(now());
	}
}
