(function($) {
  $('.track_changes').on('change', function() {
    var $this = $(this), fn
    if ($this.val() == $this.attr('value') || isBlank($this.attr('value')) == isBlank($this.val())) {
      fn = 'removeClass'
    } else {
      fn = 'addClass'
    }
    $this[fn]('changed')
  })

  function isBlank(val) {
    return typeof val === 'undefined' || val === null || val === ''
  }

  var msg = "You have unsaved changes."
  $(window).bind('beforeunload', function() {
    if (hasPendingChange()) return msg
  })
  $(document).on('page:before-change', function() {
    if (hasPendingChange()) return confirm(msg)
  })

  function hasPendingChange() {
    return $('.track_changes.changed').length > 0
  }
})(jQuery)
