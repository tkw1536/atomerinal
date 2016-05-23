{CompositeDisposable} = require 'atom'
{dirname} = require 'path'

open_terminal = require './terminal'
atomproject = require './atomproject'

module.exports = Atomerinal =
  subscriptions: null

  activate: (state) ->
    # register all the commands.
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomerinal:open-terminal-here': => @openhere()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomerinal:open-terminal-in-root': => @openroot()

    @subscriptions.add atom.commands.add 'atom-workspace', 'atomerinal:open-terminal-treeview': => @opentree()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atomerinal:open-terminal-treeview-root': => @opentreeroot()

  deactivate: ->
    # Unregister commands
    @subscriptions.dispose()

  # We have no serialisation.
  serialize: -> {}

  # opens a terminal on the currently opened file
  openhere: ->
    [fn, pth] = atomproject.active_file_and_path()
    if pth
      open_terminal pth, fn
    else
      atom.notifications.addWarning('You need to have an open file or selected folder to open a terminal on it. ')

  # opens a terminal in the root of the project
  openroot: ->
    open_terminal atomproject.active_root_path()

  # opens a terminal on the currently selected tree view item
  opentree: ->
    [fn, pth] = atomproject.marked_file_and_path()
    if pth
      open_terminal pth, fn
    else
      atom.notifications.addWarning('You need to select a file or folder in tree-view to open a terminal on it. ')

  # opens a terminal on the currently selected tree view root item
  opentreeroot: ->
    open_terminal atomproject.tree_root_path()

module.exports.config = require './config'
