airmix 1 mon
airmix 2 mon
airmix 3 mon
airmix 4 mon
airmix all dir /home/gregor/audio/pd-projects/work/wavedata/air/testfile/
airmix 1 play bach.wav 0:30 0:50
airmix 2 play pinknoise.wav
airmix 3 play zorbas.wav 0:30 0:50
airmix 4 play doors.wav 0:30 0:50
airmix 1 fader 1 3000 sin
airmix 2 fader 1 2000 log
airmix 3 fader 1 2500 hsin
airmix 4 fader 1 4000 pow
airmix 1 pan 1 2000 pow
airmix 2 pan .5 4000 sin
airmix 3 pan .7 5000 log
airmix 4 pan .3 1000


