#!/usr/bin/zsh

function plex-ps() {
  # wrapping `p` in `[]` makes it so grep doesn't match itself
  ps aux | grep -i "[p]lex"
}

function plex-transcoding() {
  local currently_transcoding=$(__plex-transcoding)
  if [[ -z $currently_transcoding ]]; then
    echo "Nothing currently transcoding"
  else
    echo "${currently_transcoding}"
  fi
}

function plex-thumbnail-progress() {
  local currently_transcoding=$(__plex-transcoding | tr -d '\n')
  local thumbnail_progress=$(__plex-thumbnail-progress)

  if [[ (-z $currently_transcoding || -z $thumbnail_progress) ]]; then
    echo "No thumbnails currently being generated"
  else
    echo "${currently_transcoding} - ${thumbnail_progress}%"
  fi
}

################################
#                              #
# `__` functions meant to be   #
#      used by other functions #
#                              #
################################

function __plex-transcoding() {
  plex-ps | grep -Po '(?<=movies[0-9]?/)([a-zA-Z]+|[0-9]+|\s|\(|\))+' 2>/dev/null
}

function __plex-thumbnail-progress() {
  local pms_log=$PMS_PLEX_MEDIA_SERVER_LOG
  if [[ -z $pms_log ]]; then
    # default to location of Plex Media Server.log on Solus
    pms_log="/var/lib/plexmediaserver/Plex Media Server/Logs/Plex Media Server.log"
  fi
  tail -5 $pms_log | grep -Po '(?<=\?progress=)[0-9]{2}.[0-9]' 2> /dev/null | tail -1
}

