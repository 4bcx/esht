block=''
pchar=''
stack=0
trail=0

input='./example'
isize=$( wc -c "${input}" | cut -f 1 -d ' ' )

od -v -c -w1 -Ad "${input}" | while read -r index ichar; do
	if [ "${block}" == 'shell' ]; then
		[ "${ichar}" == '[' ] && stack=$(( stack + 1 ))
		[ "${ichar}" == ']' ] && [ ${stack} -eq 0 ] && printf '\n' && trail=0 && block='' && continue
		[ "${ichar}" == ']' ] && [ ${stack} -gt 0 ] && stack=$(( stack - 1 ))
		[ "${pchar}${ichar}" == '$[' ] && [ ${stack} -eq 0 ] && pchar='$[' && continue
		[ -z "${ichar}" ] && trail=$(( trail + 1 )) && continue
		[ ${index} -lt ${isize} ] && printf "%${trail}s" && trail=0 && printf "${ichar:= }"
	elif [ "${block}" == 'print' ]; then
		[ "${ichar}" == '\' ] && pchar='\' && continue
		[ "${pchar}${ichar}" == '\$' ] && pchar='\$' && continue
		[ "${pchar}${ichar}" == '\$[' ] && pchar='\' && ichar='$['
		[ "${ichar}" == '$' ] && pchar='$' && continue
		[ "${pchar}${ichar}" == '$[' ] && pchar='$[' && printf "\'\n" && block='shell' && continue
		[ ${index} -lt ${isize} ] && printf '%s' "${ichar:= }" || printf "\'\n"
	else
		[ "${ichar}" == '$' ] && pchar='$' && continue
		[ "${pchar}${ichar}" == '$[' ] && pchar='$[' && block='shell' && continue
		block='print'
		printf "printf \'"
		[ "${pchar}" == '$' ] && printf '$'
		printf '%s' "${ichar:= }"
	fi
	pchar="${ichar}"
done
