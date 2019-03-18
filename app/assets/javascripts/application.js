// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require turbolinks
//= require bootstrap
//= require rails-ujs
//= require jquery-ui  
//= require activestorage
//= require moment
//= require moment/it.js
// If you require timezone data (see moment-timezone-rails for additional file options)
//= require moment-timezone-with-data
//= require tempusdominus-bootstrap-4  
//= require_tree .


$(function() {
	$('#datetimepicker_after').datetimepicker({
		format: 'YYYY-MM-DD'
	});
	$('#datetimepicker_before').datetimepicker({
		format: 'YYYY-MM-DD'
	});
});
