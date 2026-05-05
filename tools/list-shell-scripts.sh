#!/bin/sh
set -eu

is_shell_script() {
	_file=$1
	[ -f "${_file}" ] || return 1

	case "${_file}" in
		*.md5sum|*.tar|*.tar.*|*.tgz|*.gz|*.bz2|*.zip|*.png|*.jpg|*.jpeg|*.gif|*.ico|LICENSE|README.md)
			return 1
			;;
	esac

	_first_line=$(sed -n '1p' "${_file}" 2>/dev/null || true)
	case "${_first_line}" in
		'#!'*'/sh'|'#!'*'/sh '*|'#!'*' sh'|'#!'*' sh '*|\
		'#!'*'/ash'|'#!'*'/ash '*|'#!'*' ash'|'#!'*' ash '*|\
		'#!'*'/dash'|'#!'*'/dash '*|'#!'*' dash'|'#!'*' dash '*|\
		'#!'*'/bash'|'#!'*'/bash '*|'#!'*' bash'|'#!'*' bash '*)
			return 0
			;;
	esac

	case "${_file}" in
		*.sh|installer|S[0-9][0-9]*|rc.func.*)
			return 0
			;;
	esac

	return 1
}

find . \
	-path './.git' -prune -o \
	-path './.github' -prune -o \
	-path './tools' -prune -o \
	-type f -print |
sed 's#^./##' |
sort |
while IFS= read -r file; do
	if is_shell_script "${file}"; then
		printf '%s\n' "${file}"
	fi
done
