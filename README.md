# Teamspeak basic config for docker

**This uses sqlite, so you don't need any dedicated db server**



## Requirements
- docker
- docker-compose
- rsync (for backups)

## User files

When you need to upload custom license, you can copy `license.dat` to folder `data`

Under folder `data` will be even saved user data (avatars, channel files)

## Backups
For backups zou can use script `./backup.sh [DATA_PATH] [BACKUP_DIR]`


