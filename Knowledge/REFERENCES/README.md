# REFERENCES

Store the Haxe, HaxeFlixel, and dependency documentation/source code supplied by the owner.

## Reference rules

1. Prefer documentation/source matching the exact library version used by the project.
2. Use supplied source code when documentation does not establish the behavior.
3. Do not treat examples for another version or framework as authoritative.
4. If the relevant API cannot be verified, state that and ask for the missing reference.
5. Do not create placeholder files that could be mistaken for official documentation.

## Suggested organization

```text
REFERENCES/
├── README.md
├── HAXE/
├── HAXEFLIXEL/
└── DEPENDENCIES/
```

## API verification note

For APIs central to a feature, record:
- API/class/method and signature
- exact dependency version
- source/documentation file and relevant section
- lifecycle or behavior relied upon
- unresolved uncertainty, if any
