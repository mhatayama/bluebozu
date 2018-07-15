$(document).ready(function() {
  $("img").click(function() {
    window.open($(this).attr('src'), '_blank');
  });
});
