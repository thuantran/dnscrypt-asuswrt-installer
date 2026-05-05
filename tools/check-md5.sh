#!/bin/sh
set -eu

collect_targets() {
	if [ "$#" -gt 0 ]; then
		for target do
			printf '%s\n' "${target}"
		done
		return 0
	fi

	find . -name '*.md5sum' -type f -print |
	sed 's#^./##; s#\.md5sum$##' |
	sort
}

status_file=$(mktemp)
targets_file=$(mktemp)
trap 'rm -f "${status_file}" "${targets_file}"' EXIT HUP INT TERM
printf '0\n' > "${status_file}"
collect_targets "$@" > "${targets_file}"

while IFS= read -r target; do
	[ -n "${target}" ] || continue
	sum_file="${target}.md5sum"

	if [ ! -f "${target}" ]; then
		echo "Missing target for ${sum_file}: ${target}" >&2
		printf '1\n' > "${status_file}"
		continue
	fi

	if [ ! -f "${sum_file}" ]; then
		echo "Missing md5sum file for ${target}: ${sum_file}" >&2
		printf '1\n' > "${status_file}"
		continue
	fi

	expected=$(sed -n '1s/[[:space:]].*$//p' "${sum_file}")
	actual=$(md5sum "${target}" | awk '{print $1}')

	if [ "${expected}" != "${actual}" ]; then
		echo "MD5 mismatch: ${target}" >&2
		echo "  expected: ${expected}" >&2
		echo "  actual:   ${actual}" >&2
		printf '1\n' > "${status_file}"
	else
		echo "MD5 ok: ${target}"
	fi
done < "${targets_file}"

exit "$(cat "${status_file}")"
