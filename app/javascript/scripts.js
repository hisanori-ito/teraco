/* global $ */
/* global $preview */
/* global reader */
/* global $fileField */
/* global file */
$(function() {
  $('#up a').on('click',function(event){
    $('body, html').animate({
      scrollTop:0
    }, 800);
    event.preventDefault();
  });
});

document.addEventListener("turbolinks:load", function() {
  $(function() {
    function readURL(input) {
        if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
    $('#prev').attr('src', e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
        }
    }
    $("#file").change(function(){
        readURL(this);
    });
  });
})

$(document).on('turbolinks:load', function() {
  $fileField = $('#file_video');

  $($fileField).on('change', $fileField, function(e) {

      file = e.target.files[0];
      reader = new FileReader(),
      $preview = $("#prev_video");

      reader.onload = (function(file) {
        return function(e) {
          $preview.empty();
          $preview.append($('<video>').attr({
            src: e.target.result,
            controls: true,
          }));
        };
      })(file);
      reader.readAsDataURL(file);
    });
  });