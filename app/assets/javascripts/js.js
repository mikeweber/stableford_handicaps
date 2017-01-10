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
console.log('loaded')

function isBlank(val) {
  return typeof val === 'undefined' || val === null || val === ''
}

function isDirty() { return $('.changed').length > 0  }

