;; This demo visits edata

(setq forms-file "/home/gregor/audio/pd-projects/work/wavedata/air/blender/edata")
(setq forms-number-of-fields 7)
(setq forms-read-only t)                 ; to make sure
(setq forms-field-sep ":")
;; Don’t allow multi-line fields.
(setq forms-multi-line nil)

(setq forms-format-list
      (list
       "====== /etc/passwd ======\n\n"
       "User : "    1
       "   Uid: "   3
       "   Gid: "   4
       "\n\n"
       "Name : "    5
       "\n\n"
       "Home : "    6
       "\n\n"
       "Shell: "    7
       "\n"))
