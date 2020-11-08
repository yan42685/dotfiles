GIT_AUTO_FETCH_INTERVAL=${GIT_AUTO_FETCH_INTERVAL:=60}

function git-fetch-all {
  (`command git rev-parse --is-inside-work-tree 2>/dev/null` &&
  dir=`command git rev-parse --git-dir` &&
  [[ ! -f $dir/NO_AUTO_FETCH ]] &&
  (( `date +%s` - `date -r $dir/FETCH_LOG +%s 2>/dev/null || echo 0` > $GIT_AUTO_FETCH_INTERVAL )) &&
  GIT_SSH_COMMAND="command ssh -o BatchMode=yes" \
    command git fetch --all 2>/dev/null &>! $dir/FETCH_LOG &)
}
