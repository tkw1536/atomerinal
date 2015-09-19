{platform} = require 'os'

if platform() == 'darwin'
  app = 'Terminal.app'
else if platform() == 'win32'
  app = 'C:\\Windows\\System32\\cmd.exe'
else
  app = '/usr/bin/x-terminal-emulator'

module.exports =
  app:
    type: 'string'
    description: 'Terminal application to open. '
    default: app
  args:
    type: 'string'
    description: 'Arguments to pass to the terminal application. $directory will be replaced with the directory to be opened. $file will be replaced with the file the command was triggered from (if applicable). '
    default: '$directory'
  environmentVariables:
    type: 'string'
    description: 'Additional environment variables to set. Should be of the form ```key1=var1,key2=var2```. $directory and $file will be replaced on the right hand side of assignments. '
    default: 'ATOMERNIAL_FILE=$file,ATOMERNIAL_DIRECTORY=$directory,NODE_ENV='
  setWorkingDirectory:
    type: 'boolean'
    description: 'Set the working directory of the terminal process to be opened. '
    default: true
  unwrapCommand:
    type: 'boolean'
    description: 'Do not wrap terminal command in ```open -a``` or ```start``` when running on Mac or Windows. '
    default: false
