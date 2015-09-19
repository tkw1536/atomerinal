{platform} = require 'os'
{exec} = require 'child_process'

replace_variable = (str, variable, value) -> str.replace(new RegExp("\\$#{variable}\\b", 'gi'), value)
replace_variables = (str, obj) ->
  if !str
    return ''
  for variable,value of obj
    str = replace_variable str,variable,value
  str

parse_environment = (str, env, obj) ->
  nenv = {}
  for k,v of env
    nenv[k] = v
  for k,v of str.split ','
    [key, value] = v.split '='
    nenv[key] = replace_variables value, obj
  nenv
module.exports = (dirname, filename) ->
  # app and arguments
  app = atom.config.get('atomerinal.app')
  args = replace_variables atom.config.get('atomerinal.args'), {'directory': "\"#{dirname}\"", 'file': "\"#{filename}\""}
  
  # additional config settings
  setWorkingDirectory = atom.config.get('atomerinal.setWorkingDirectory')
  unwrapCommand = atom.config.get('atomerinal.unwrapCommand')
  
  # Start assembling the command line
  command = "\"#{app}\" #{args}"
  
  # On Mac (darwin) we need to wrap the command with open -a
  if platform() == "darwin" && !unwrapCommand
    command = "open -a " + command

  # For Windows (win32) we need to wrap the command with start
  if platform() == "win32" && !unwrapCommand
    command = "start \"\" " + command
  
  # environment for the process to call
  environment = parse_environment atom.config.get('atomerinal.environmentVariables'), process.env, {'directory': "#{dirname}", 'file': "#{dirname}"}
  
  # For debugging enable this line. 
  # console.log("atomerinal executing: ", command, environment)

  # Set the working directory if configured
  if setWorkingDirectory
    exec command, cwd: dirname, env: environment if dirname?
  else
    exec command, env: environment if dirpath?