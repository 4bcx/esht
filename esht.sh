#!/bin/sh
# esht - Embeddable SHell Tags parser thingie
# Licensed under the The Unlicense.
# For more information, please refer to <https://unlicense.org>

# This script should not be sourced, make sure to change the string 'esht.sh'
#   to match this file's name
[ 'esht.sh' == $( basename "$0" ) ] || return 1

SCRIPT=$( basename "$0" )
VERSION="1.0.0"
URL="https://gitlab.com/4bcx/esht"

print_help () {
	cat << END_OF_HELP_TEXT
"${SCRIPT}" v"${VERSION}"
Embeddable SHell Tags parser thingie
Licensed under the The Unlicense.
For more information, please refer to <https://unlicense.org>

Usage: ${SCRIPT} SOURCE [OUTPUT]
Compile SOURCE into shell script OUTPUT or standard output.

Mandatory arguments to long options are mandatory for short options too.
  -h, --help                    display this help text and exit
  -v, --version                 print version and exit

Project homepage: <"${URL}">
END_OF_HELP_TEXT
}

print_version () {
	printf '%s v%s\n' "${SCRIPT}" "${VERSION}"
}

print_error () {
	ERROR_MSG=${1:-Unknown error}
	printf '%s: %s\n' "${SCRIPT}" "${ERROR_MSG}" >&2
}

write_to_file() {
	printf "$@" >> "${OUTPUT_FILE}"
}

write_to_stdout() {
	printf "$@" >&1
}

script_main () {
	BLOCK=''
	PCHAR=''
	STACK=0
	TRAIL=0
	ISIZE=$( wc -c "${INPUT_FILE}" | cut -f 1 -d ' ' )

	od -v -c -w1 -Ad "${INPUT_FILE}" | while read -r INDEX ICHAR; do
		if [ "${BLOCK}" == 'shell' ]; then
			if [ "${ICHAR}" == '[' ]; then
				STACK=$(( STACK + 1 ))
			elif [ "${ICHAR}" == ']' ] && [ ${STACK} -eq 0 ]; then
				${write_output} '\n'
				TRAIL=0
				BLOCK=''
				continue
			elif [ "${ICHAR}" == ']' ] && [ ${STACK} -gt 0 ]; then
				STACK=$(( STACK - 1 ))
			elif [ "${PCHAR}${ICHAR}" == '$[' ] && [ ${STACK} -eq 0 ]; then
				PCHAR='$['
				continue
			elif [ -z "${ICHAR}" ]; then
				TRAIL=$(( TRAIL + 1 ))
				continue
			elif [ -n "${ICHAR}" ] && [ ${TRAIL} -gt 0 ]; then
				${write_output} "%${TRAIL}s"
				TRAIL=0
			fi

			${write_output} "${ICHAR}"

		elif [ "${BLOCK}" == 'print' ]; then
			if [ "${ICHAR}" == '\' ]; then
				PCHAR='\'
				continue
			elif [ "${PCHAR}${ICHAR}" == '\$' ]; then
				PCHAR='\$'
				continue
			elif [ "${PCHAR}${ICHAR}" == '\$[' ]; then
				PCHAR='\'
				ICHAR='$['
			elif [ "${ICHAR}" == '$' ]; then
				PCHAR='$'
				continue
			elif [ "${PCHAR}${ICHAR}" == '$[' ]; then
				PCHAR='$['
				${write_output} "\'\n"
				BLOCK='shell'
				continue
			fi

			if [ ${INDEX} -eq ${ISIZE} ]; then
				${write_output} "\'\n"
			else
				${write_output} '%s' "${ICHAR:= }"
			fi

		else
			if [ "${ICHAR}" == '$' ]; then
				PCHAR='$'
				continue
			elif [ "${PCHAR}${ICHAR}" == '$[' ]; then
				PCHAR='$['
				BLOCK='shell'
				continue
			else
				BLOCK='print'
				${write_output} "printf \'"
				if [ "${PCHAR}" == '$' ]; then
					${write_output} '$'
				fi
			fi
			${write_output} '%s' "${ICHAR:= }"
		fi
		
		PCHAR="${ICHAR}"
	done
}

INPUT_FILE=''

if [ $# -eq 0 ]; then
	print_error "Missing source filename"
	print_help
	exit 5
elif [ $# -gt 2 ]; then
	print_error "${3}: Cannot use more than two arguments"
	print_help
	exit 22
else
	case "${1}" in
		-h|--help)
			print_help
			exit 0
			;;
		-v|--version)
			print_version
			exit 0
			;;
		*)
			if [ -f "${1}" ]; then
				INPUT_FILE="${1}"
			else
				print_error "${1}: File cannot be opened or does not exist"
				exit 2
			fi
	esac

	if [ -n "${2}" ]; then
		if [ -f "${2}" ]; then
			print_error "${2}: File exists and will be overwritten"
		fi
		OUTPUT_FILE="${2}"
		: > "${OUTPUT_FILE}"
		write_output='write_to_file'
	else
		write_output='write_to_stdout'
	fi
fi

trap "print_error 'Interrupt signal detected, output may be incomplete'" SIGINT

script_main
