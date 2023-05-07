code_dir=$(pwd)
log_file=/tmp/rorboshop.log
rm-f ${log_file}

print_head(){
  echo -e "\e[35m$1"
}