#!/bin/bash
dir_path="";
name="";
usage="Usage: $(basename $0) -d dir_path -n script_name [-h for help]"
if [ -z "$1" ]; then
   echo "$usage"
   exit 1
fi
while getopts ':d:n:h' opt; do
  case "$opt" in
    d)
      dir_path="$OPTARG"
      ;;
    n)
      name="$OPTARG"
      ;;
    h)
      echo $usage
      exit 0
      ;;
    :)
      echo -e "option requires an argument.\n$usage"
      exit 1
      ;;
    ?)
      echo -e "Invalid command option.\n$usage"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
tar_file="$(pwd)/$name.tar.gz"
tar -czvf $tar_file -C $dir_path .
touch $name.sh
echo '#!/bin/bash' >> $name.sh
echo "base64_archive=$(tar -czvf - $dir_path | base64)" >> $name.sh
echo 'dir_path=$(pwd)' >> $name.sh
printf 'usage="Usage: $(basename $0) [-o dir_path] [-h for help]"
      while getopts ":o:h" opt; do
        case "$opt" in
          o)
            dir_path="$OPTARG"
            ;;
          h)
            echo $usage
            exit 0
            ;;
          :)
            echo -e "option requires an argument.\n$usage"
            exit 1
            ;;
          ?)
            echo -e "Invalid command option.\n$usage"
            exit 1
            ;;
        esac
      done
      shift "$(($OPTIND -1))"' >> $name.sh
echo "" >> $name.sh
echo "tar_path="'$dir_path'"/$name.tar.gz" >> $name.sh
echo 'echo $base64_archive | base64 -d >> $tar_path' >> $name.sh
echo 'tar -xzvf $tar_path -C $dir_path' >> $name.sh
echo 'rm -f $tar_path' >> $name.sh
chmod +x $name.sh
rm -f $tar_file


