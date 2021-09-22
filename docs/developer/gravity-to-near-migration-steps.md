# module

"x" and "proto" refactoring

* Module name -> key.go
* Rename the package x.gravity to x.nab
* Rename the package gravity to nab in x/nab folder 
* Rename proto/gravity -> proto/nab
* Rename in proto gravity.v1 -> nab.v
* Rename in proto module/x/gravity -> module/x/nab
* Rename in proto gravity/v1 -> nab/v1
* Regenerate the proto -> make proto-gen
* Replace string "gravity/ to the string "nab/ in the module
* Replace string "gravity0 to "nab0 in the module
* Replace string "gravity.v1 to "nab.v1 in the module 
* Replace "gravity" to "nab" all GO files CASE SENSITIVE in the module
* Replace "gravity%s" in nab/client/cli/tx.go to "nab%s"

TODO:
- rename variables
- rename docs (spec folder)
- rename Events (or check whether it is needed)

"cmd" refactoring   

* Rename folder cmd/gravity -> cmd/nab
  
"app" refactoring

* Replace string ".gravity" to ".nab" in app
* Replace string "gravityparams" to "nabgravityparams" in app
* Replace string "gravitytypes" to "nabtypes" in app
* Replace string "gravityKeeper" tp "nabKeeper" in app
* Rename/Refactor the struct name type Gravity struct in app -> Nab
* Rename/Refactor func NewGravityApp -> func NewNabApp
  
"cmd"

* Rename/Refactorvar gravity *app.Nab -> func nab gravity *app.Nab in root.go
* Replace string "gravitytypes" to "nabtypes" in cmd


"makefile"

* change gravity -> nab in build config

"tests" (integration)

* change BIN=gravity to BIN=nab

"solidity"

Replace /custom/gravity string to -> /custom/nab

"orchestrator"

Replace "gravity" string with "nab"
Replace "gravity{}" string with "nab{}"
Replace "/gravity.v1 with "/nab.v1   (can be substituted by normal codegen)
Open orchestrator/proto_build  and cargo run 
Replace new import in  gravity_proto/src/lib.rs  : "prost/gravity.v1.rs" -> "prost/nab.v1.rs"

...TODO

* update docs (gravity -> nab) ???
* contrib gravity -> nab