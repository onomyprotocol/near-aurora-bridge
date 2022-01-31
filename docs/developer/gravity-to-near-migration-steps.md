# module

"x" and "proto" refactoring

* Module name -> key.go
* Rename the package x.gravity to x.nab
* Rename the package gravity to nab in x/nab folder
* Rename proto/nab -> proto/nab
* Rename in proto gravity.v1 -> nab.v
* Rename in proto module/x/nab -> module/x/nab
* Rename in proto gravity/v1 -> nab/v1
* Regenerate the proto -> make proto-gen
* Replace string "gravity/ to the string "nab/ in the module
* Replace string "gravity0 to "nab0 in the module
* Replace string "gravity.v1 to "nab.v1 in the module
* Replace "gravity" to "nab" all GO files CASE SENSITIVE in the module
* Replace "gravity%s" in nab/client/cli/tx.go to "nab%s"

TODO:
- rename variables
- rename Events (or check whether it is needed)

"cmd" refactoring

* Rename folder cmd/nab -> cmd/nab

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

# makefile

* change gravity -> nab in build config

"tests" (integration)

* change BIN=gravity to BIN=nab

# solidity

Replace /custom/gravity string to -> /custom/nab
Replace /gravity/ -> /nab/

# orchestrator

Replace "gravity" string with "nab"
Replace "gravity{}" string with "nab{}"
Replace "/nab.v1 with "/nab.v1   (can be substituted by normal codegen)
Open orchestrator/proto_build  and cargo run
Replace new import in  gravity_proto/src/lib.rs  : "prost/nab.v1.rs" -> "prost/nab.v1.rs"
Rename gbt folder to nabt
Rename all constants in the project from gbt to nabt

* contrib gravity -> nab

# all files

replace the strung github.com/althea-net/cosmos-gravity-bridge with the github.com/onomyprotocol/near-aurora-bridge

# tests

replace gravity with nab for test
replace gravity in gitignore
replace /nab/solidity to /nab/solidity in orchestrator/test_runner

# docs

replace /gravity with /nab Case sensitive !!!

# workflow

automated-release.yml -> gravity artifact to nab
automated-release.yml -> gbt to nabt