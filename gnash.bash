#!/usr/bin/env bash

if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need at least bash-4.0 to run this script."
  exit 1
fi

function gnash_remove_if_exists() {
  file_or_dir=$1
  if [[ "$file_or_dir" == "." ]] || [[ "$file_or_dir" == "./" ]] || \
    [[ "$file_or_dir" == "./*" ]] || [[ "$file_or_dir" == "\*" ]] || \
    [[ "$file_or_dir" == "" ]] ; then
    echo "ERROR!"
    echo "Not allowed to run 'rm -rf' with arguement: '$file_or_dir'"
    exit 1
  fi

  if [[ -f $file_or_dir ]] ; then
    rm -rf $file_or_dir
  fi
}

function gnash_intro {
  argc=$1
  argv=($2)
  ver=${BASH_VERSINFO[0]}
  echo "The arguements from the command line invocation:"
  for ((i=0;i<argc;i=i+1)) ; do
    echo "argv of $i: ${argv[$i]}"
  done
  echo "Bash Version: $ver"
  echo "Please be aware that the Bash Manual is very useful @:"
  echo "https://www.gnu.org/software/bash/manual/bash.html"
  echo "Alternatively, run the command 'man bash' in terminal"
}

function gnash_require_param_format_check {
  in=$1
  if [[ "$in" =~ ^[\w_]*$ ]] ; then
    echo "ERROR!"
    echo "parameter name must only include alphanumeric chars and '_'"
    exit 1
  fi
}

function gnash_parse_parameter {
  declare -n dict1="$1"
  in1=$2
  in2=$3
  gnash_require_param_format_check $in1
  dict1[${in1:1:${#in1}-1}]=$in2
}

function gnash_parse_params {
  declare -n dict0="$1"
  cnt="$#"
  argc=$2
  argv=($@)
  argv=(${argv[@]:2:((cnt-1))})
  i=0
  while (( i < argc )) ; do
    item=${argv[$i]}
    if [[ "$item" =~ ^--.* ]] ; then
      gnash_require_param_format_check $item
      gnash_parse_parameter dict0 $item 1
      i=$((i+1))
    elif [[ "$item" =~ ^-.* ]] ; then
      gnash_parse_parameter dict0 $item ${argv[$((i+1))]}
      i=$((i+2))
    else
      echo "ERROR!"
      echo "Expecting command line arguements to have leading -- or -"
      echo "Instead found: '$item'"
      exit 1
    fi
  done
}

function gnash_dict_empty_check {
  declare -n dict0="$1"
  if [[ "$(echo ${!dict0[@]} | wc -w)" == "0" ]] ; then
    echo "ERROR: params are empty"
    exit 1
  fi
}

function gnash_puts_dictionary {
  declare -n dict0="$1"
  echo "Number of dictionary items: $(echo ${!dict0[@]} | wc -w)"
  for i in "${!dict0[@]}" ; do
    echo "key: '$i', value: '${dict0[$i]}'"
  done
}

function gnash_dict_required_check {
  declare -n dict0="$1"
  param=$2
  if [[ "${dict0[$param]}" == "" ]] ; then
    echo "ERROR: $param is a required command line arguement"
    exit 1
  fi
}







