{CompositeDisposable} = require 'atom'
{dirname} = require 'path'

open_terminal = require './terminal'

module.exports = Atomerinal =
  subscriptions: null

  activate: (state) ->
    # register all the commands. 
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomerinal:open-terminal-here': => @openhere()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomerinal:open-terminal-in-root': => @openroot()

  deactivate: ->
    # Unregister commands
    @subscriptions.dispose()

  # We have no serialisation. 
  serialize: -> {}
  
  # opens a terminal on the current file. 
  openhere: -> 
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer?.file
    filepath = file?.path
    if filepath
      open_terminal dirname(filepath), filepath
    else
      atom.notifications.addWarning('You need to open a file to open a terminal on it. ')
  
  # opens a terminal in all the root folders of the current project. 
  openroot: ->
    open_terminal path,null for path in atom.project.getPaths()

module.exports.config = require './config'