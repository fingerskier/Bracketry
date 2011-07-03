$(document).ready(function() {
	$('a.ajax').live('click', function() {
		var my = $(this),
			target = my.attr('target') || 'body',
			url = my.attr('href');
		
		$(target).load(url);
	});
	
	$('button').button();
});

function buttonify() {
	$('input:checkbox').button();
}

function TodoCtrl() {
	var scope = this;
	scope.todos = [
		{text:'learn angular', date:'', done:true},
		{text:'build an angular app', date:'', done:false}
	];
	scope.remaining = scope.todos.length;

	scope.addTodo = function() {
		scope.todos.push({text:scope.todoText, date:scope.todoDate, done:false});
		scope.remaining++;
		scope.todoText = '';
	}
   
	scope.recalc = function() {
		scope.remaining = scope.todos.length;
		angular.forEach(scope.todos, function(todo) {
			if (todo.done) scope.remaining--;
		});
	}
	scope.recalc();
   
	scope.removeDone = function() {
		for (var i = 0; i < scope.todos.length; i++) {
			if (scope.todos[i].done) scope.todos.splice(i--, 1);
		}
	};
}
