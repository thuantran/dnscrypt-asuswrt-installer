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

collect_targets "$@" |
while IFS= read -r target; do
	[ -n "${target}" ] || continue

	if [ ! -f "${target}" ]; then
		echo "Skipping missing target: ${target}" >&2
		continue
	fi

	md5sum "${target}" | awk '{print $1}' > "${target}.md5sum"
	echo "Updated ${target}.md5sum"
done
