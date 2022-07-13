#!/bin/bash
gnu=$(date --version 2>/dev/null | grep -i GNU | wc -l) #gnu date different than osx's bsd varient
if [ $gnu -gt 0 ];
then
for hw in `seq 1 5`; do echo "$(xxd -r - <<< "0000000 48 57 0a\n0000003")$(($hw + 2)) $(xxd -r - <<< "0000000 69 73 20 64 75 65 0a\n0000007") $(date -d "$(xxd -r - <<< "0000000 32 30 32 32 2d 30 37 2d 31 31 0a\n000000b") + $((1*$hw)) day" +%F) $(xxd -r - <<< "0000000 62 79 20 6d 69 64 6e 69 67 68 74 0a\n000000c")"; done
else
for hw in `seq 1 5`; do echo "$(xxd -r - <<< "0000000 48 57 0a\n0000003")$(($hw + 2)) $(xxd -r - <<< "0000000 69 73 20 64 75 65 0a\n0000007") $(date -v +$((1*$hw))d -j -f "%Y-%m-%d %H:%M" "$(xxd -r - <<< "0000000 32 30 32 32 2d 30 37 2d 31 31 0a\n000000b") 00:00" +%F) $(xxd -r - <<< "0000000 62 79 20 6d 69 64 6e 69 67 68 74 0a\n000000c")"; done
fi
