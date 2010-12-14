function each-project {
  # setup
  history -a
  history -c
  touch ~/.projectlist.history
  touch ~/.projectcommand.history
  trap 'echo; history -r; return 0' INT TERM EXIT

  local DSPROJECTS='ad da ds ld le lg lr om rp tx'
  local COMMAND=''

  # get project list
  history -r ~/.projectlist.history
  while true
  do
    echo "For each project alias (default: " $DSPROJECTS "):"
    read -p '> ' -e PROJECTLIST
    case "$PROJECTLIST" in
      stop) break
        ;;
      history) history
        ;;
      *)
        local PL_SIZE=0
        for a in $PROJECTLIST; do PL_SIZE=$[PL_SIZE+1]; done
        if (($PL_SIZE > 0)); then
          DSPROJECTS=$PROJECTLIST
          history -s "$PROJECTLIST"
        fi
        break
    esac
  done
  history -w ~/.projectlist.history
  history -c

  # get and run command
  history -r ~/.projectcommand.history
  while true
  do
    echo "run command:"
    read -p '> ' -e COMMAND
    case "$COMMAND" in
      stop) break
        ;;
      history) history
        ;;
      *)
        history -s "$COMMAND"
        for a in $DSPROJECTS
        do
          local MYDIR=`pwd`
          eval $a
          echo -e "\033[1;32m"`pwd`"\033[0m" "[\033[1;33m"$a"\033[0m]"
          eval $COMMAND
          echo
          cd $MYDIR
        done
        break
    esac
  done
  history -w ~/.projectcommand.history
  history -c
  
  # cleanup
  history -r
  trap - INT TERM EXIT
}
