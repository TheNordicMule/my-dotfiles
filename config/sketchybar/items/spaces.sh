#!/bin/bash

SPACE_SIDS=(1 2 3 4 5 6 7 8 9 10)

for sid in "${SPACE_SIDS[@]}"
do
  sketchybar --add space space.$sid left                                 \
             --set space.$sid space=$sid                                 \
                              icon=$sid                                  \
                              label.font="SauceCodePro NF:Regular:16.0" \
                              label.padding_right=2                     \
                              label.y_offset=-1                          \
                              script="$PLUGIN_DIR/space.sh"              
done
