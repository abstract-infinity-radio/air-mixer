
CREATE SEQUENCE airfront_card_airc_seq;
CREATE SEQUENCE airfront_recording_airr_seq;

CREATE TABLE card(
airc integer PRIMARY KEY DEFAULT nextval('airfront_card_airc_seq'), -- air catalogue number
title text,
authors text,
performers text,
date date,
ts timestamptz DEFAULT current_timestamp
);


CREATE TABLE recording(
airc integer REFERENCES card(airc) ON DELETE CASCADE ON UPDATE CASCADE, -- (global) air catalogue number
airr integer PRIMARY KEY DEFAULT nextval('airfront_recording_airr_seq'), -- (global) air recording number 
host text,
path text,
channels integer,
samplerate integer,
duration time,
duration_ms float,
bitrate integer,
encoding text,
type text,
ts timestamptz DEFAULT current_timestamp
);


CREATE TABLE source(
airr integer PRIMARY KEY REFERENCES recording(airr) ON DELETE CASCADE ON UPDATE CASCADE,
host text,
path text,
channels integer,
samplerate integer,
duration time,
duration_ms float,
bitrate integer,
encoding text,
type text,
ts timestamptz DEFAULT current_timestamp
);


CREATE FUNCTION reseq () RETURNS TABLE (airc bigint,airr bigint) AS $$
DECLARE
mairc integer := max(c.airc) FROM card c;
mairr integer := max(r.airr) FROM recording r;
mairr_src integer := max(s.airr) FROM source s;
rec record;

BEGIN
IF mairr_src > mairr THEN
mairr := mairr_src;
END IF;

RETURN QUERY SELECT
       setval('airfront_card_airc_seq',COALESCE ((mairc + 1),1), FALSE) AS airc,
       setval('airfront_recording_airr_seq',COALESCE ((mairr + 1),1), FALSE) AS airr;
END
$$ LANGUAGE plpgsql;

CREATE VIEW reseq AS SELECT * FROM reseq();




-- INSERT INTO card VALUES(DEFAULT,'First Project','Some Composer','Some Performer',current_timestamp::date);

-- INSERT INTO card VALUES(DEFAULT,'Second Project','Some Other Composer','Some Other Performer',current_timestamp::date);

-- INSERT INTO card VALUES(DEFAULT,'Third Project','Some OtherOther Composer','Some OtherOther Performer',current_timestamp::date);

-- INSERT INTO recording VALUES (1,DEFAULT,'h','/my/recording/destination1.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO source VALUES (1,'h','/my/recording/source1.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO recording VALUES (2,DEFAULT,'h','/my/recording/destination2.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO source VALUES (2,'h','/my/recording/source2.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO recording VALUES (3,DEFAULT,'h','/my/recording/destination3.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO source VALUES (3,'h','/my/recording/source3.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO recording VALUES (3,DEFAULT,'h','/my/recording/destination3.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO source VALUES (4,'h','/my/recording/source3.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO recording VALUES (3,DEFAULT,'h','/my/recording/destination3.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');

-- INSERT INTO source VALUES (5,'h','/my/recording/source3.wav',2,48000,'00:04:32',2312321.22,16,'PCM','wav');








