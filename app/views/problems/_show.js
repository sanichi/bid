$(function() {
  // allow keys to be used instead of clicking next and prev links
  $(window).keydown(function(e) {
    var link;
    switch (e.keyCode) {
      case 39: // right arrow
      case 78: // 'n' for next
        link = $('#next_link').get(0);
        break;
      case 37: // left arrow
      case 80: // 'p' for previous
        link = $('#prev_link').get(0);
        break;
    }
    if (link !== undefined) link.click();
  });
});
