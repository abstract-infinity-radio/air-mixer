#!/bin/sh
# AIROSCOPE sample script

# INFILE OUTFILE PARAM and START are airoscope's global receivers.
# PARAM should be mapped to a specific tool: (temper|pitcher|dynoz|beater|bonker)
# OUTFILE should be provided as a path with the root-filename upon which the extensions for each analysis are added
# Don't forget "START bang;" to actually run the process


pd -nogui -send "
INFILE /home/gregor/audio/pd-projects/work/wavedata/air/testfile/beethoven-0.wav;
OUTFILE /home/gregor/audio/pd-projects/work/wavedata/air/testfile/beethoven-0;
PARAM temper fiforange 0 300;
PARAM temper fifosize 5;
PARAM temper transition_threshold 0.8;
PARAM temper aubio_threshold 0.35;
START bang;
" gpp-airoscope.pd

