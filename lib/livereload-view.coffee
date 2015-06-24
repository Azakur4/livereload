{Emitter} = require 'event-kit'
livereload = require 'livereload'

defaultPort = 35729

module.exports =
class LivereloadView
  server: null # livereload server
  port: defaultPort

  initialize: (serializeState) ->
    @emitter = new Emitter

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()
    @closeServer()

  onServerStatusChange: (callback) ->
    @emitter.on 'livereload-status-change', callback

  startServer: ->
    @emitter.emit 'livereload-status-change', {text: 'LiveReload: ...', href: '#'}

    @server = livereload.createServer {
      port: @port,
      exclusions: ['.DS_Store'],
      exts: atom.config.get('livereload.exts'),
    }

    @server.config.server
      .on 'error', (err) =>
        if err.code == 'EADDRINUSE'
          console.log "LiveReload: port #{@port} already in use. Trying port #{++@port}..."

          try @server.close()
          @server = null

          setTimeout @startServer.bind(@), 1000
      .on 'listening', () =>
        console.log "LiveReload: listening on port #{@port}."

        @port = defaultPort
        @emitter.emit 'livereload-status-change', {text: "LiveReload: #{@port}", href: "http://localhost:#{@port}/livereload.js"}

    if path = atom.project.getPaths()[0]
      @server.watch path

  closeServer: ->
    try
      @server.config.server.close () =>
        @emitter.emit 'livereload-status-change', false
        @server = null

  toggle: ->
    if @server
      @closeServer()
    else
      @startServer()
