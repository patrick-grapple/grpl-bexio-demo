# grapi injections

Files in the folders below are encoded into `chart/values.yaml` by `task patch-values-file`.
`task reset-values-file` removes their generated `content` entries again. Do not edit
generated entries manually.

| Type | Folder | File type |
| --- | --- | --- |
| Controllers | `controllers/` or legacy `injections/` | `*.controller.ts` |
| Service providers | `serviceproviders/` | `*.service.ts` |
| Services | `services/` | `*.service.ts` |
| Cache configuration | `cacheconfigs/` | `*.ts` |
| Datasources | `datasources/` | `*.ts` |
| Discoveries | `discoveries/` | `*.ts` |
| Fuzzy search | `fuzzysearch/` | `*.ts` |
| Models | `models/` | `*.ts` |
| OpenAPI definitions | `openapis/` | `*.ts` |
| Repositories | `repositories/` | `*.ts` |
| REST CRUD configuration | `restcruds/` | `*.ts` |
| Relations | `relations/` | `*.ts` |
| Pre-patches | `prepatches/` | `*.sh` |
| Pre-discovery patches | `prediscoverypatches/` | `*.sh` |
| Pre-relation patches | `prerelationpatches/` | `*.sh` |
| Post-patches | `postpatches/` | `*.sh` |

Use `controllers/` for new controllers. The `injections/` folder remains available for
legacy development sync.

Run `./scripts/test-grapi-injections.sh` to validate patching and reset behaviour.
