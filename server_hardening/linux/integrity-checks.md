# Integrity checking

## Checksums

This stuff substitutes for a poor-man's aide.

Generate SHA1 checksums for all files in current folder and all subfolders

    find . -type f -print0 | xargs -0 sha1sum > /tmp/checksums

Verify the checksums generated above.

    sha1sum -c /tmp/checksums

Verify the checksums of dpkg-managed files on an Ubuntu/Debian system. Only print if files fail the checksum.

    find  /var/lib/dpkg/info/ -name "*.md5sums" | xargs md5sum -c  | grep -v ': OK$'

Verify permissions and checksums of all RPM-managed files on a RPM-based distro. This only prints things that were altered.

    rpm -Va

## Permissions

List the attributes in CSV format of files in the current folder and subfolders
(user.group, mode, size, filetype,modification time,filename):

    find . | xargs -n1 stat  --format="%U.%G,en%a,%s,'%F',%i,'%y','%n'" > /tmp/perms
