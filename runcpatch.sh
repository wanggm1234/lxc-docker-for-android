#!/bin/bash
RUNC_ADD_FILE=$1
awk '/^static int cgroup_add_file/ { print NR; exit }' "$RUNC_ADD_FILE" > row.txt
awk '/return 0/ { print NR; exit }' "$RUNC_ADD_FILE" > row2.txt
row=$(cat row.txt)
row2=$(cat row2.txt)
row3=$(awk -v r1="$row" -v r2="$row2" 'BEGIN { print r1 + r2 - 1 }')
awk -v r="$row3" -v line1="        if (cft->ss && (cgrp->root->flags & CGRP_ROOT_NOPREFIX) && !(cft->flags & CFTYPE_NO_PREFIX)) {" -v line2="                snprintf(name, CGROUP_FILE_NAME_MAX, \"%s.%s\", cft->ss->name, cft->name);" -v line3="                kernfs_create_link(cgrp->kn, name, kn);" -v line4="        }" 'NR == r { print line1 "\n" line2 "\n" line3 "\n" line4 } 1' "$RUNC_ADD_FILE" > temp.txt
mv temp.txt "$RUNC_ADD_FILE"
rm row.txt row2.txt
