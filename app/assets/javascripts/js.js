var form_submitting = false
var confirmation_message = 'You have unsaved changes.';

$(document).on('change', '.track_changes', function() {
  var $this = $(this), fn
  if ($this.val() === $this.attr('value') || isBlank($this.attr('value')) === isBlank($this.val())) {
    fn = 'removeClass'
  } else {
    fn = 'addClass'
  }
  $this[fn]('changed')
})

$(document).on('click', '.medical.toggle', function() {
  var $this = $(this)
  var id = $this.data('golfer-id')
  var medical = $this.data('medical')
  var $icon = $('#medical-icon-' + id)
  var $status_field = $('#golfer_' + id + '_medical_status')

  if (medical) {
    $icon.addClass('disabled')
    $this.data('medical', false)
    $status_field.val(false)
  } else {
    $icon.removeClass('disabled')
    $this.data('medical', true)
    $status_field.val(true)
  }
})

$(document).on('submit', 'form', function() {
  form_submitting = true
})

$(window).on('beforeunload', function(e) {
  if (form_submitting || !isDirty()) return undefined
  form_submitting = false

  return confirmation_message
})

$(window).on('page:before-change', function(e) {
  if (form_submitting || !isDirty()) return undefined
  form_submitting = false

  return confirm(confirmation_message)
})

function isBlank(val) {
  return typeof val === 'undefined' || val === null || val === ''
}

function isDirty() { return $('.changed').length > 0  }

