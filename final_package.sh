#!/bin/bash


if test x$GPG_KEY_ID = x
then
	echo "You must set the GPG_KEY_ID environment variable before running this script"
	exit 1
fi

export REPO=saoimageds9

mkdir -p "$REPO"
tar -C "$REPO" -xf ds9-flatpak-repo-unsigned.tar

for ref in $(ostree refs --repo="$REPO"); do
    ostree --repo="$REPO" rev-parse "$ref"
done |
sort -u |
while read -r commit; do
    ostree --repo="$REPO" gpg-sign "$commit" "$GPG_KEY_ID"
done

flatpak build-update-repo \
    --gpg-sign="$GPG_KEY_ID" \
    --generate-static-deltas \
    "$REPO"

tar -C "$REPO" -cf saoimageds9.tar .
