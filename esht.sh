inside_code=false
inside_print=false
brackets_stack=0

input_file='./example'

input_size=$( wc -c "${input_file}" | cut -f 1 -d ' ' )
input_index=0

__newline__='
'

_getchars() {
	index=${1:-0}
	count=${2:-1}
	dd if="${input_file}" bs=1 count=${count} skip=${index} 2> /dev/null
}

while [ ${input_index} -lt ${input_size} ]; do
	char=$( _getchars ${input_index} )
	if [ "${inside_print}" == 'true' ] && [ "${inside_code}" == 'false' ]; then
		if [ "${char}" == '$' ]; then
			char=$( _getchars ${input_index} 2 )
			if [ "${char}" == '$[' ]; then
				printf "\'\n"
				inside_print=false
				inside_code=true
				input_index=$(( input_index + 1 ))
			else
				_getchars ${input_index} 2
			fi
		else
			_getchars ${input_index}
		fi
	elif [ "${inside_print}" == 'false' ] && [ "${inside_code}" == 'true' ]; then
		if [ "${char}" == '[' ]; then
			brackets_stack=$(( brackets_stack + 1 ))
		elif [ "${char}" == ']' ] && [ ${brackets_stack} -gt 0 ]; then
			brackets_stack=$(( brackets_stack - 1 ))
		elif [ "${char}" == ']' ] && [ ${brackets_stack} -eq 0 ]; then
			printf "\nprintf \'"
			inside_print=true
			inside_code=false
		else
			_getchars ${input_index}
		fi
	else
		if [ "${char}" == '$' ]; then
			char=$( _getchars ${input_index} 2 )
			if [ "${char}" == '$[' ]; then
				inside_print=false
				inside_code=true
				input_index=$(( input_index + 1 ))
			else
				printf "printf \'"
				_getchars ${input_index}
				inside_print=true
				inside_code=false
			fi
		else
			printf "printf \'"
			_getchars ${input_index}
			inside_print=true
			inside_code=false
		fi
	fi
	input_index=$(( input_index + 1 ))
done

if [ "${inside_print}" == 'true' ] && [ "${inside_code}" == 'false' ]; then
	printf "\'\n"
fi
