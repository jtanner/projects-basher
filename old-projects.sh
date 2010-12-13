# Projects
PROJECTS='ad da ds ld le lg lr mk om rp tx'
alias ad='cd ~/lmp/admin'
alias da='cd ~/lmp/duplicateapi'
alias ds='cd ~/lmp/degreesearch'
alias ld='cd ~/lmp/lead_delivery'
alias le='cd ~/lmp/leadgen_events'
alias lg='cd ~/lmp/lead_gateway'
alias lr='cd ~/lmp/lead_resale'
alias mk='cd ~/lmp/market'
alias om='cd ~/lmp/offer_match'
alias rp='cd ~/lmp/reports'
alias tx='cd ~/lmp/transporter'
# project helpers
alias pa='alias | grep lmp' # show project aliases
# print the git status for all my project aliases
alias gsta='for a in ad da ds ld le lg lr mk om rp tx
do
  mydir=$pwd
  eval $a
  echo -e "\033[1;33m"`pwd`"\033[0m"
  git status
  echo
  cd $mydir
done'

function each-project {
  # setup
  history -a
  history -c
  touch ~/.projectlist.history
  touch ~/.projectcommand.history
  trap 'echo; history -r; return 0' INT TERM EXIT

  DSPROJECTS='ad da ds ld le lg lr om rp tx'
  COMMAND=''

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
        PL_SIZE=0
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
          MYDIR=`pwd`
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
