#!/bin/bash
current_file=$(basename "$0")

if [[ "$1" == "current" ]]; then

   current_res_cpu=$(kubectl top pod -A --no-headers=true | sed 's/[[:space:]]\{1,\}/,/g' | cut -d, -f3)
   current_res_memory=$(kubectl top pod -A --no-headers=true | sed 's/[[:space:]]\{1,\}/,/g' | cut -d, -f4)

   # echo $current_res
   let current_cpu=0
   let current_memory=0
   for i in ${current_res_cpu[@]}
   do
         numeric_part=$(echo "$i" | sed 's/[^0-9]*//g')
         suffix=$(echo "$i" | sed 's/[0-9]*//g')

         if [[ "$suffix" == "m" ]]; then
            current_cpu=$(( current_cpu + numeric_part ))
         elif [[ "$suffix" == "" ]]; then
            current_cpu=$(( current_cpu + numeric_part*1000 ))
         fi
   done

   for i in ${current_res_memory[@]}
   do
         numeric_part=$(echo "$i" | sed 's/[^0-9]*//g')
         suffix=$(echo "$i" | sed 's/[0-9]*//g')

         # Memory calculation
         if [[ "$suffix" == "Mi" ]]; then
            current_memory=$(( current_memory + numeric_part ))
         elif [[ "$suffix" == "Gi" ]]; then
            current_memory=$(( current_memory + numeric_part*1024 ))
         fi
   done

   echo current cpu - $current_cpu\m
   echo current memory - $current_memory\Mi
   
   exit 0
fi


if [[ -z $1 || -z $2 || -z $3 ]]
then
echo "Some of the arguments are not set
Usage:
bash $current_file requests cpu \"-A\"
bash $current_file limits cpu \"-n kube-system\"
"
exit 1
fi

all=(limits requests)

if [[ "$1" == "all" ]] && [[ -n "$2" ]] && [[ -n "$3" ]]; then
   for resource in ${all[@]}
   do
      # echo $resource
      res=$(kubectl get pods -o=jsonpath="{.items[*].spec.containers[*].resources.$resource.$2}" $3)
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
      echo $2 $resource: ${tot}
   done
   exit 0
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
