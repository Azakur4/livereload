livereloadView = null
livereloadStatusView = null
eventSubscription = null

module.exports =
  config:
    exts:
      type: 'array'
      default: ['']
      items:
        type: 'string'
        default: ''

  livereloadView: null

  activate: (state) ->
    unless livereloadView?
      LivereloadView = require './livereload-view'
      livereloadView = new LivereloadView()
      livereloadView.initialize()
      eventSubscription = livereloadView.onServerStatusChange (serverStatus) ->
        livereloadStatusView.update(serverStatus)
    atom.commands.add 'atom-workspace', 'livereload:toggle', => @toggle()

  consumeStatusBar: (statusBar) ->
    LivereloadStatusView = require './livereload-status-view'
    livereloadStatusView = new LivereloadStatusView()
    livereloadStatusView.initialize(statusBar)
    livereloadStatusView.attach()

  deactivate: ->
    eventSubscription?.dispose()
    eventSubscription = null

    livereloadStatusView?.destroy()
    livereloadStatusView = null

    livereloadView?.destroy()
    livereloadView = null

  serialize: ->
    LivereloadView: @livereloadView.serialize()

  toggle: ->
    livereloadView.toggle()
