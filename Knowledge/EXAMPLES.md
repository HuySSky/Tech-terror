# EXAMPLES — Anti-patterns in Tech Terror
> Guides: Simplicity, Surgical Changes, No Reinventing.

## 1. Simplicity vs Over-engineering

❌ Custom validators/helpers/errors for self-generated data:
```haxe
class DataValidator { 
    public static function checkBpm(bpm:Float):Bool { ... } 
}
```

✅ Map directly. Broken JSON → fix JSON file, not code:
```haxe
var json = haxe.Json.parse(jsonString);
var data = new SongData();
data.bpm = json.bpm; 
data.name = json.name;
```

## 2. No Defensive Programming

❌ Null checks for guaranteed-internal objects:
```haxe
if (songData == null) { trace("error"); return; }
if (songData.bpm <= 0) { throw "Invalid BPM"; }
```

✅ Assume internal data correct:
```haxe
d.bpm = json.bpm;
d.name = json.name;
d.timeSignature = json.timeSignature; // String "4/4", parsed by TimeSignature class
```

## 3. Surgical Changes Only

❌ "Add audio load" → rename vars, docstrings, quote changes, reformat.
✅ Only add requested `loadAudio()`. Touch nothing else.

## 4. Use Built-in Libraries

❌ Custom health clamp:
```haxe
if (curHealth > maxHealth) { curHealth = maxHealth; }
if (curHealth < 0) { curHealth = 0; }
```
✅ `curHealth = Math.max(0, Math.min(curHealth, maxHealth));`

❌ Custom keyboard listeners.
✅ `if (FlxG.keys.justPressed.LEFT) { ... }`

## 5. Object Self-Instantiation

❌ Separate Loader:
```haxe
var jsonData = FileLoader.load("song.json"); 
var song = new SongData(jsonData);
```

✅ Object self-loads:
```haxe
var song = new SongData("songName"); // or SongData.load("songName")
```