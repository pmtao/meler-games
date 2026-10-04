#!/bin/sh
# Rebuild the game and publish only referenced runtime audio.
set -e
cd "$(dirname "$0")/.."
SRC="${1:-../pelican-racing}"
(cd "$SRC" && python3 build.py)
cp "$SRC/dist/pelican-racing.html" pelican-racing/index.html
mkdir -p pelican-racing/music
cp "$SRC"/dist/music/* pelican-racing/music/
python3 - "$SRC" <<'PY'
import json,shutil,sys
from pathlib import Path
src=Path(sys.argv[1]);destination=Path('pelican-racing');assets={}
for name in ['voice-assets','voice-overrides']:
 s=(src/'js/audio'/f'{name}.js').read_text();assets.update(json.JSONDecoder().raw_decode(s[s.index('{'):])[0])
paths={url.split('?',1)[0] for url in assets.values()}
for name in paths:
 p=Path(name)
 if p.parts[:2] not in [('voice','zh'),('voice','en')] or '..' in p.parts:raise RuntimeError('Unexpected recording path')
 if not (src/name).is_file():raise RuntimeError('Recording missing: '+name)
for name in paths:
 target=destination/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src/name,target)
for language in ['zh','en']:
 folder=destination/'voice'/language
 for target in folder.rglob('*.m4a'):
  if target.relative_to(destination).as_posix() not in paths:target.unlink()
print('Updated game, music and',len(paths),'runtime voice recordings.')
PY
