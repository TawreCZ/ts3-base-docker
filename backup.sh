#!/bin/sh

SOURCE_DIR=$1
BACKUP_DIR=$2
DAY=$(date +%Y%m%d)
SOURCE_BASENAME=$(basename $SOURCE_DIR)

if [ ! -d $BACKUP_DIR ] ; then
  mkdir -p $BACKUP_DIR/incr
  mkdir $BACKUP_DIR/full
  mkdir $BACKUP_DIR/full-latest
  ln -s $BACKUP_DIR/full-latest $BACKUP_DIR/$SOURCE_BASENAME
  ln -s /dev/null $BACKUP_DIR/full.tar.bz2
fi

if [ -d $BACKUP_DIR/incr/$DAY ] ; then
  rm -rf $BACKUP_DIR/incr/$DAY
fi

rsync -a --delete --inplace --backup --backup-dir=$BACKUP_DIR/incr/$DAY $SOURCE_DIR/ $BACKUP_DIR/full-latest/

if [ $(date +%u) -eq 7 ] ; then

  if [ -e $BACKUP_DIR/full/$DAY.tar.bz2 ] ; then
    rm -f $BACKUP_DIR/full/$DAY.tar.bz2
  fi

  BACKUP_ARCHIVE=$BACKUP_DIR/full/$DAY.tar.bz2

  cd $BACKUP_DIR
  tar czfh $BACKUP_ARCHIVE $SOURCE_BASENAME/
  ln -sf $BACKUP_ARCHIVE $BACKUP_DIR/full.tar.bz2
fi


#rotating backups
if [ $(ls -l $BACKUP_DIR/incr | wc -l) -gt 2 ] ; then
  find $BACKUP_DIR/incr/* -maxdepth 1 -type d -ctime +14 -exec rm -rf {} \;
fi

if [ $(ls -l $BACKUP_DIR/full | wc -l) -gt 2 ] ; then
  find $BACKUP_DIR/full/* -maxdepth 1 -type f -ctime +140 -exec rm -f {} \;
fi
