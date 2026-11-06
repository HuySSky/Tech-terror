# EXAMPLES — Anti-patterns in Tech Terror

This file guides Claude on "Simplicity First", "Surgical Changes", and "No reinventing the wheel." Learn from these strict contrasts.

## 1. Simplicity vs Over-engineering

**❌ WRONG:** Writing custom validators, helper functions, or throwing errors for data we generated ourselves.

```haxe
class DataValidator { 
    public static function checkBpm(bpm:Float):Bool { ... } 
}
```

**✅ RIGHT:** Map data directly. If the JSON is broken, we fix the JSON file, not the code.

```haxe
var json = haxe.Json.parse(jsonString);
var data = new SongData();
data.bpm = json.bpm; 
data.name = json.name;
```

## 2. No Defensive Programming

**❌ WRONG:** Adding null checks for internal objects guaranteed to exist.

```haxe
if (songData == null) { trace("error"); return; }
if (songData.timeSignature.length != 2) { throw "Invalid signature"; }
```

**✅ RIGHT:** Assume internal data is correct.

```haxe
d.timeSignature = [Std.int(json.timeSignature[0]), Std.int(json.timeSignature[1])];
```

## 3. Surgical Changes Only

**❌ WRONG:** When asked to "Add audio load", you rename variables, add docstrings, change single quotes to double, and reformat.

**✅ RIGHT:** Only add the requested `loadAudio()` function. Touch nothing else.

## 4. Use Built-in Libraries

**❌ WRONG:** Writing custom loops to clamp health.

```haxe
if (curHealth > maxHealth) { curHealth = maxHealth; }
if (curHealth < 0) { curHealth = 0; }
```

**✅ RIGHT:** Use Haxe standard math.

```haxe
curHealth = Math.max(0, Math.min(curHealth, maxHealth));
```

**❌ WRONG:** Writing custom keyboard listeners.

**✅ RIGHT:** 
```haxe
if (FlxG.keys.justPressed.LEFT) { ... }
```