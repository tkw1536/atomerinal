{lstatSync} = require 'fs'
{dirname} = require 'path'

helpers =
  to_path: (pth) ->
    # HELPER: Returns the directory belonging to a given path
    if pth == null || typeof pth == 'undefined' || lstatSync(pth).isDirectory()
      pth
    else
      dirname(pth)
  get_tree_view: () ->
    # gets the tree-view package object or undefined
    # adapted from https://github.com/magbicaleman/open-in-browser/blob/master/lib/open-in-browser.coffee
    if atom.packages.isPackageLoaded('tree-view') == true
      treeView = atom.packages.getLoadedPackage('tree-view')
      packageObj = treeView.mainModule.treeView
    packageObj

  # gets the project root path associated with pth
  get_root_path: (pth) ->

    dirs = atom.project.getDirectories()
    for rootDirectory in dirs
      if rootDirectory.path == pth || rootDirectory.contains pth
        return rootDirectory.path
    dirs[0]?.path

module.exports = atomproject =
  # gets the currently open file
  open_file: () ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer?.file
    file?.path

  # gets the file currently selected in the tree-view
  marked_file: () ->
    treeView = helpers.get_tree_view()

    if treeView?
      if treeView.selectedPath
        treeView.selectedPath

  # gets the file currently selected in the tree view and the path
  marked_file_and_path: () ->
    fn = @marked_file()

    if fn
      pth = helpers.to_path fn
    else
      fn = null
      pth = null

    [fn, pth]

  # gets the currently selected tree view root path
  tree_root_path: () ->
    [fn, pth] = @marked_file_and_path()
    helpers.get_root_path pth

  # gets the currently active file and path
  active_file_and_path: () ->
    treeView = helpers.get_tree_view()

    if treeView? && treeView.hasFocus
      fn = @marked_file()
    else
      fn = @open_file()

    pth = helpers.to_path fn
    [fn, pth]

  # gets the currently active project root
  active_root_path: () ->
    [fn, pth] = @active_file_and_path()
    helpers.get_root_path pth
