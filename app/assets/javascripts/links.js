// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

// function sort_by_date(a,b){
//   return parseInt($('a', a).first().data('date')) > parseInt($('a', b).first().data('date')) ? -1 : 1;
// };

function sort_by_date(a,b){
  return parseInt($('td', a).first().data('date')) > parseInt($('a', b).first().data('date')) ? -1 : 1;
};

// function sort_by_hits(a,b){
//   return parseInt($('span', a).html()) > parseInt($('span', b).html()) ? -1 : 1;
// };

function sort_by_hits(a,b){
  return parseInt($('td', a).first().html()) > parseInt($('td', b).first().html()) ? -1 : 1;
};

var time_options = {
  0: "15 min.",
  1: "1 hr.",
  2: "4 hrs.",
  3: "1 day",
  4: "Never"
};

function update_time_label() {
  $('#time_label').text("Expires: " + time_options[$('#time_slider').val()]);
};

jQuery.fn.selectText = function(){
    var doc = document
        , element = this[0]
        , range, selection
    ;
    if (doc.body.createTextRange) {
        range = document.body.createTextRange();
        range.moveToElementText(element);
        range.select();
    } else if (window.getSelection) {
        selection = window.getSelection();
        range = document.createRange();
        range.selectNodeContents(element);
        selection.removeAllRanges();
        selection.addRange(range);
    }
};

// $('#by_hits').click(function() {
//   $('#link_list li').sort(sort_by_hits).appendTo('#link_list');
// });

$('#by_hits').click(function() {
  $('#link_list tbody tr').sort(sort_by_hits).appendTo('#link_list tbody');
});

$('#by_date').click(function() {
  $('#link_list tbody tr').sort(sort_by_date).appendTo('#link_list');
});

$('#time_slider').change(update_time_label);

$('#shortened_link').click(function() {
  $('#shortened_link').selectText();
});

$(document).ready(function() {
  setTimeout(function() {
    $('.flash').slideUp();
  }, 3000);
});