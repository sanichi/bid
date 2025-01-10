$(function () {
  // Auto-submit on change.
  $('form .auto-submit').change(function () {
    $(this).parents('form').get(0).requestSubmit();
  });
});
