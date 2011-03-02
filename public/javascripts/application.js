// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
	$('#flash_error').delay(4000).fadeOut(1000);
	$('#flash_notice').delay(4000).fadeOut(1000);
});
$(document).ready(function(){
		$('#top_menu_buttons_list .dropdown_menu').hover(
        function () {
            //show its submenu
            $('.dropdown_menu ul').slideDown(200);
        }, 
        function () {
            //hide its submenu
            $('.dropdown_menu ul').delay(100).slideUp(200);         
        }
    );	
});
