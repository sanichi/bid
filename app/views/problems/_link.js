var note_modal;

function bind_links(old) {
  if (old) {
    $('a.note-link').off('click');
  }
  $('a.note-link').on('click', function (event) {
    show_modal(event, $(this).attr('href'));
  });
}

function show_modal(event, href) {
  event.preventDefault();
  $.ajax(href, {
    dataType: 'html'
  }).done(function (data) {
    $('#note-modal-content').html(data);
    bind_links(true);
  });
  note_modal.show();
}

$(function () {
  note_modal = new bootstrap.Modal(document.getElementById('note-modal'));
  bind_links(false);
});