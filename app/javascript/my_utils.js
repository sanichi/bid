$(function () {
  // Auto-submit on change.
  $('form .auto-submit').change(function () {
    var form = $(this).parents('form');
    form.submit();
  });
});
