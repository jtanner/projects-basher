function each-project {
  # setup
  history -a
  history -c
  touch ~/.projectlist.history
  touch ~/.projectcommand.history
  trap 'history -r; trap - INT TERM EXIT; return 0' INT TERM EXIT

  local DSPROJECTS='ad da ds ld le lg lr om rp tx'
  local COMMAND=''

  # get project list
  history -r ~/.projectlist.history
  echo -e "\033[1;31mFor each project alias \033[0m(default: " $DSPROJECTS "):"
  while read -p '> ' -e PROJECTLIST
  do
    case "$PROJECTLIST" in
      exit) kill $$ ;;
      quit) kill $$ ;;
      q)    kill $$ ;;
      history) history ;;
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
  while echo -e "\033[1;31mrun command: \033[0m" && read -p '> ' -e COMMAND
  do
    case "$COMMAND" in
      exit) kill $$ ;;
      quit) kill $$ ;;
      q)    kill $$ ;;
      history) history ;;
      *)
        history -s "$COMMAND"
        for a in $DSPROJECTS
        do
          local MYDIR=`pwd`
          eval $a
          if [ $? -eq 0 ]; then # alias worked
            echo -e "\033[1;32m"`pwd`"\033[0m" "[\033[1;33m"$a"\033[0m]"
            eval $COMMAND
          fi
          echo
          cd $MYDIR
        done
    esac
  done
  history -w ~/.projectcommand.history
  history -c
  
  # cleanup
  history -r
  trap - INT TERM EXIT
}
