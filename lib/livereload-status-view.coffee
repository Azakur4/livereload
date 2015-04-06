class LivereloadStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    @classList.add('livereload-status', 'inline-block')

    # Create message element
    @link = document.createElement('a')
    @link.classList.add('inline-block')
    @appendChild(@link)

  attach: ->
    @tile = @statusBar.addRightTile(priority: 13, item: this)

  destroy: ->
    @tile?.destroy()

  update: (serverStatus) ->
    if serverStatus
      @link.textContent = serverStatus.text
      @link.href = serverStatus.href

      @attach()
    else
      @destroy()

module.exports = document.registerElement('livereload-status', prototype: LivereloadStatusView.prototype)
