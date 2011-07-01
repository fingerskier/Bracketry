<!doctype html>
<html xmlns:ng="http://angularjs.org">
	<head>
		<link href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.13/themes/humanity/jquery-ui.css" rel="stylesheet" type="text/css">
	</head>

	<body>
		<div ng:controller="TodoCtrl">
			<input type="text" name="todoText" size="35" placeholder="enter your todo here">
			<input type="text" name="todoDate" size="17" placeholder="due date">
			<button class="ui-state-active ui-corner-all" ng:click="addTodo()">add</button>
			<br>
			<label>{{remaining}} remaining</label>
			<button class="ui-state-active ui-corner-all" ng:click="removeDone()">remove done</button>
			<br>
			<ul ng:repeat="todo in todos" ng:init="$('input:checkbox').button();">
				<li>
					<input type="checkbox" name="todo.done" ng:click="recalc()">
					<span ng:class="'done-' + todo.done">{{todo.text}}</span>
					<span ng:class="'done-' + todo.done">{{todo.date}}</span>
					<br>
				</li>
			</ul>
		</div>

		<script language="JavaScript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js" type="application/javascript"></script>
		<script language="JavaScript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.js" type="application/javascript"></script>
		<script src="http://code.angularjs.org/0.9.17/angular-0.9.17.min.js" ng:autobind></script>
		<script language="JavaScript" src="application.js" type="application/javascript"></script>
	</body>
</html>
