SPACESHIP_PROMPT_ORDER=(
  time          # Time stampts section
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  line_sep      # Line break
  # vi_mode       # Vi-mode indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_RPROMPT_ORDER=(
  node          # Node.js section
  ruby          # Ruby section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift         # Swift section
  golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia         # Julia section
  docker        # Docker section
  venv          # virtualenv section
  python        # was Pyenv section
  jobs
  nix_shell
  # dotnet        # .NET section
  # ember         # Ember.js section
  exec_time     # Execution time
)

SPACESHIP_NIX_SHELL_SHOW=true

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=true
SPACESHIP_PROMPT_SUFFIXES_SHOW=false
SPACESHIP_PROMPT_DEFAULT_PREFIX='\0'
SPACESHIP_PROMPT_DEFAULT_SUFFIX=' '
SPACESHIP_DIR_TRUNC=2
SPACESHIP_CHAR_SYMBOL='➜ '
SPACESHIP_EXEC_TIME_PREFIX=' '

SPACESHIP_GIT_PREFIX='‹'
SPACESHIP_GIT_SUFFIX='›'
SPACESHIP_GIT_SYMBOL='\0'
SPACESHIP_GIT_STATUS_PREFIX="["
SPACESHIP_GIT_STATUS_SUFFIX="] "

SPACESHIP_DOCKER_SHOW=false
SPACESHIP_DOCKER_PREFIX='\0'
SPACESHIP_DOCKER_SYMBOL=''

SPACESHIP_PYTHON_PREFIX='›'
SPACESHIP_PYTHON_SYMBOL=' '

SPACESHIP_VENV_SHOW=true

SPACESHIP_RUBY_PREFIX='›'
SPACESHIP_RUBY_SYMBOL='\0'

SPACESHIP_NODE_SYMBOL="\0"
SPACESHIP_GOLANG_SYMBOL='\0'
SPACESHIP_PACKAGE_SYMBOL='\0'
SPACESHIP_PACKAGE_PREFIX='\0'

SPACESHIP_JOBS_SHOW=true
SPACESHIP_JOBS_AMOUNT_THRESHOLD=0
