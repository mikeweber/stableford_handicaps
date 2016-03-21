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
})(jQuery)
