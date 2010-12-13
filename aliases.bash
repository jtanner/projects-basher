function create-basher-aliases {
  for pair in $BASHER_LIST; do
    local -a pair_parts=(`echo $pair | tr -s ',' ' '`)
    local   dir_name=${pair_parts[0]}
    local alias_name=${pair_parts[1]}
    eval "alias $alias_name=\"cd $BASHER_ROOT/$dir_name\""
  done
}
create-basher-aliases

alias pa="alias | grep '`dirname \"$BASHER_ROOT/foo\"`' | grep -v grep" # show project aliases
