'use strict';
//  Author: AdminDesigns.com
//
//  This file is reserved for changes made by the user
//  as it's often a good idea to seperate your work from
//  the theme. It makes modifications, and future theme
//  updates much easier
//

//  Place custom scripts below this line
///////////////////////////////////////

Mousetrap.bind("?", function() { console.log('show shortcuts!'); });
Mousetrap.bind("/", function() { console.log('go to search!'); });
Mousetrap.bind('t s', function() {
  $('body').toggleClass('sidebar-hidden');
});

Mousetrap.bind('f s', function(){
  console.log('toggle sidebar between fixed and not fixed');
  $('body #sidebar_left').toggleClass('affix')
})
Mousetrap.bind('t h', function() {
  console.log('toggle header between fixed and not fixed');
  $('body header').toggleClass('navbar-fixed-top');
});

