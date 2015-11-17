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

jQuery(document).ready(function () {
  "use strict";

  // Init Theme Core
  Core.init();

  // Enable Ajax Loading
  Ajax.init();

  // Enable Ajax Loading
  Customizer.init();

  // Added function for demo purposes. Normally the sidebar background is done without JS via
  // the Psuedo "sidebar:after" selector. However, to have a live visual update we need a selectable
  // class which is actually present in DOM
  var wHeight = $(window).height();
  $('#sidebar_left').height(wHeight);

  // Slide down toggle for option
  $('#custom5').change(function() {
    $(this).parents('.cBox').siblings('.reveal-group').slideToggle('fast');
  });

  // Select all text in CSS Generate Modal
  $('#copy').click(function(e) {
     e.preventDefault();
     $('#skinGenerate textarea').select();
  });

  // Extra Sloppy/pointless function to toggle a cluster of buttons
  // from one color set to another - Just For Demo Purposes
  $('.content-header .pull-left .btn').on('click',function() {
    var btnColor = $(this).data('color');

    // Check if active
    if ($(this).hasClass('active')) {return;}

    // If not remove alternative color set from all sibling buttons
    $(this).siblings('.btn').removeClass('active bg-grey2 bg-purple2 bg-blue2 bg-teal2 bg-orange2 bg-green2');

    // Scroll through each one and apply its original class
    $(this).siblings('.btn').each(function(i,e){
      var btnColor = $(e).data('color');
      $(e).addClass('bg-' + btnColor)
    });

    // Add Active class to clicked button and toggle its color set
    $(this).addClass('active').toggleClass('bg-' + btnColor).toggleClass('bg-' + btnColor + '2')
  });



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

});
