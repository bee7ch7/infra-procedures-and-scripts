#!/bin/bash
current_file=$(basename "$0")
if [[ -z $1 || -z $2 || -z $3 ]]
then
echo "Some of the arguments are not set
Usage:
bash $current_file requests cpu \"-A\"
bash $current_file limits cpu \"-n kube-system\"
"
exit 1
fi

res=$(kubectl get pods -o=jsonpath="{.items[*].spec.containers[*].resources.$1.$2}" $3)
let tot=0
for i in $res
do
# CPU calculation
   numeric_part=$(echo "$i" | sed 's/[^0-9]*//g')
   suffix=$(echo "$i" | sed 's/[0-9]*//g')

   if [[ "$suffix" == "m" ]]; then
      tot=$(( tot + numeric_part ))
   elif [[ "$suffix" == "" ]]; then
      tot=$(( tot + numeric_part*1000 ))
   fi
   
# Memory calculation
   if [[ "$suffix" == "Mi" ]]; then
      tot=$(( tot + numeric_part ))
   elif [[ "$suffix" == "Gi" ]]; then
      tot=$(( tot + numeric_part*1024 ))
   fi
done
echo $2 $1: ${tot}
