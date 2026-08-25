#!/bin/bash

export REPO=saoimageds9
TARFILE=ds9-flatpak-repo-unsigned.tar

if test x$GPG_KEY_ID = x
then
	echo "You must set the GPG_KEY_ID environment variable before running this script"
	exit 1
fi

if test -f ${TARFILE}
then
  :
else
    echo "Cannot find tar file."
    exit 1
fi

mkdir -p "$REPO"
tar -C "$REPO" -xf ${TARFILE}

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

gpg --batch --export "$GPG_KEY_ID" > "$REPO/saoimageds9.gpg"
GPG_KEY_B64=$(base64 --wrap=0 < "$REPO/saoimageds9.gpg")
cat > "$REPO/saoimageds9.flatpakrepo" <<EOF
[Flatpak Repo]
Title=SAOImageDS9
Url=https://ds9.si.edu/beta/flatpak/
Homepage=https://ds9.si.edu/
Comment=SAOImageDS9 Flatpak Repository
Description=Official SAOImageDS9 Flatpak Repository
GPGKey=${GPG_KEY_B64}
Nodelete=false
EOF


tar -C "$REPO" -cf saoimageds9.tar .
