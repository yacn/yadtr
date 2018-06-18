#!/usr/bin/zsh

function plex-ps() {
  # wrapping `p` in `[]` makes it so grep doesn't match itself
  ps aux | grep -i "[p]lex"
}

function plex-thumbnail-progress() {
  local currently_transcoding=$(__plex-transcoding)
  local thumbnail_progress=$(__plex-thumbnail-progress)

  if [[ (-z $currently_transcoding || -z $thumbnail_progress) ]]; then
    __dbg "currently_transcoding: $currently_transcoding"
    __dbg "thumbnail_progress: $thumbnail_progress"
    echo "No thumbnails currently being generated"
  else
    echo "${currently_transcoding} => ${thumbnail_progress}%"
  fi
}

# thank you 'evil otto' for the stack overflow answer here:
#   http://archive.is/EOrkz
# which inspired this solution
function plex-thumbnail-eta() {
  local currently_transcoding=$(__plex-transcoding)
  local interval=1.5
  if [[ ! -z $1 ]]; then
    interval=$1
  fi

  local percent_done=$(__plex-thumbnail-progress)
  local prev_percent_done=$percent_done

  local progress=0.0
  local rate_of_progress=0.0
  local interval_multiplier=1.0
  local estremain='???'

  while [ $(__do-math-stuff "$percent_done < 100.0") -eq 1 ]; do
    prev_percent_done=$percent_done
    percent_done=$(__plex-thumbnail-progress)

    progress=$(__do-math-stuff "$percent_done - $prev_percent_done")

    if [[ $(__do-math-stuff "$progress == 0.0") -eq 1 ]]; then
      interval_multiplier=$(__do-math-stuff "$interval_multiplier + 1.0")
      __print_progress $currently_transcoding $percent_done $estremain
      continue
    fi

    percent_remaining=$(__do-math-stuff "100.0 - $percent_done")

    if [[ $(__do-math-stuff "$interval_multiplier > 1.0") -eq 1 ]]; then
      rate_of_progress=$(__do-math-stuff "$progress / ($interval * $interval_multiplier)")
      interval_multiplier=1.0
    else
      rate_of_progress=$(__do-math-stuff "$progress / $interval")
    fi
    estremain=$(__do-math-stuff "$percent_remaining / $rate_of_progress")
    __print_progress $currently_transcoding $percent_done $estremain
    sleep $interval
  done
  printf "\ndone\n"
}

function plex-transcoding() {
  local currently_transcoding=$(__plex-transcoding)
  if [[ -z $currently_transcoding ]]; then
    echo "Nothing currently transcoding"
  else
    echo "${currently_transcoding}"
  fi
}

################################
#                              #
# `__` functions meant to be   #
#      used by other functions #
#                              #
################################

function __dbg() {
  if [[ "${DEBUG}" == 'true' ]]; then
    echo "$*"
  fi
}

# 0 is false for bc arithmetic comparison...........................
function __do-math-stuff() {
  echo "$*" | bc -l
}

function __print_progress() {
  local file=$1
  local pct_done=$2
  local estremain=$3
  printf "\r$file => $pct_done% complete - est %d:%0.2d remaining\e[K" $(( $estremain/60 )) $(( $estremain%60 ))
}

function __plex-transcoding() {
  local movie_transcoding=$(__plex-movie-transcoding "$(plex-ps)")
  if [[ -z $movie_transcoding ]]; then
    __plex-tv-transcoding "$(plex-ps)"
  else
    echo "${movie_transcoding}" | tr -d '\n'
  fi
}

# example Movie:
#  /movies2/Brigsby Bear (2017)/Brigsby Bear 2017.mkv 
#
function __plex-movie-transcoding() {
  # \K resets starting point for matching
  echo "$*" | grep -Po '/movies[0-9]?\K(\w|\W)+\.mkv' | cut -d '/' -f3

}

# example TV:
#  /tv2/Westworld/Season 1/Westworld - S01E02 - Chestnut Bluray-2160p.mkv
# => Westworld - S01E02 - Chestnut Bluray-2160p.mkv
function __plex-tv-transcoding() {
  #echo "$*" | grep -Po 'Season [0-9]+/\K(\w+|-|\s|[0-9]+)+'
  echo "$*" | grep -Po 'Season [0-9]+/\K(\w|\W)+\.mkv' | cut -d '/' -f3
}

function __plex-thumbnail-progress() {
  local pms_log="${PMS_PLEX_MEDIA_SERVER_LOG}"
  if [[ -z $pms_log ]]; then
    # default to Solus location
    pms_log="/var/lib/plexmediaserver/Plex Media Server/Logs/Plex Media Server.log"
  fi
  __plex-bif-progress "$(tail -5 $pms_log)"
}

# 'bif' index files / 'media index files' / 'Video Preview Thumbnails'
function __plex-bif-progress() {
  echo "$*" | grep -Po '\?progress=\K[0-9]{1,2}\.[0-9]' | tail -1
}
