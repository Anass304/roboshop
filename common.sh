code_dir=$(pwd)
log_file=/tmp/rorboshop.log
rm-f ${log_file}

print_head(){
  echo -e "\e[34m$1"
}

status_check(){
if [ $1? -eq 0 ]; then
  echo SUCCESS
  else
    echo FAILURE
    fi
    }