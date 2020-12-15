#!/bin/bash

BACKUP_DIR=${HOME}/db-backup

mkdir -p ${BACKUP_DIR}
pushd ${BACKUP_DIR}

if [ ! -z "$1" ]; then
DB=$1
else
DB=dcr
fi

export BACKUP_FILE_PATH=`ssh pewebuser@dc-prod-repo1.vmware.com /home/pewebuser/dc-prod-db-backup.sh ${DB}`
echo "downloading ${BACKUP_FILE_PATH} to ${BACKUP_DIR}"
scp pewebuser@dc-prod-repo1.vmware.com:${BACKUP_FILE_PATH} ${BACKUP_DIR}

FILENAME=$(basename "${BACKUP_FILE_PATH}")
LOCAL_BACKUP_FILE="${BACKUP_DIR}/${FILENAME}"

DEST_HOST="dc-test-app1.eng.vmware.com"

echo "replacing $DEST_HOST ${DB} db"
mysql -u root -proot -h $DEST_HOST ${DB} < ${LOCAL_BACKUP_FILE}

popd
