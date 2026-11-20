# Building your own SDK

Mica publishes ready-made SDKs (see the [README](../README.md)). If your language isn't covered, or you
prefer to generate the code yourself, everything you need is in this repository: the Mica API is plain
[gRPC](https://grpc.io) over mutual TLS, defined by the `.proto` files here.

## What to generate

| Directory | Contents | Needed by |
| --- | --- | --- |
| `mica/issuer` | Services an issuer calls on Mica, and Mica calls on an issuer | Issuers |
| `mica/acceptor` | Services an acceptor calls on Mica, and Mica calls on an acceptor | Acceptors |
| `mica/member` | Ping and authentication services shared by every member | Everyone |
| `mica/common` | Messages shared between roles | Everyone |
| `micashared` | Shared messages and enums | Everyone |
| `validate`, `google` | Third-party imports (validation annotations, protobuf and HTTP options) | Everyone |

Generate `mica/member`, `mica/common`, `micashared` and the role directories you play. Use this repository's
root as the import path (`-I .`), because the protos import each other as `mica/...` and `micashared/...`.

Packages are versioned by directory, for example `mica/issuer/service/v2`. A new major version is a new
package, so v1 and v2 code can coexist during a migration.

## With buf (what we use)

[`buf.gen.yaml`](../buf.gen.yaml) generates every language we support. Install [buf](https://buf.build/docs/installation)
and run:

```bash
./generate.sh          # all languages, output in ./gen/<language>
./generate.sh python   # just one
```

To adapt it, copy `buf.gen.yaml`, delete the plugins you don't need, and change `out:` and the Go
`go_package_prefix` overrides to match your project. Any plugin from the
[Buf Schema Registry](https://buf.build/plugins) can be added the same way.

## With protoc

If you'd rather not use buf, plain `protoc` works. From the root of this repository:

```bash
# Go
protoc -I . --go_out=gen/go --go_opt=paths=source_relative \
       --go-grpc_out=gen/go --go-grpc_opt=paths=source_relative \
       $(find mica/member mica/common mica/issuer micashared -name '*.proto')

# Python (pip install grpcio-tools)
python -m grpc_tools.protoc -I . --python_out=gen/python --pyi_out=gen/python --grpc_python_out=gen/python \
       $(find mica/member mica/common mica/issuer micashared validate -name '*.proto')
```

Notes:

- `validate/validate.proto` is imported by most of the protos for field validation annotations. In Go it
  resolves to the `github.com/envoyproxy/protoc-gen-validate` module, so add that dependency and don't
  generate it. In Python, generate it as above (or `pip install protoc-gen-validate`).
- The `go_package` options in these files are relative. Override them for your module with
  `--go_opt=Mmica/issuer/service/v2/issuer_to_mica_service.proto=your/module/path;servicev2` (one `M` flag per
  file), or generate with buf managed mode as `buf.gen.yaml` does.
- **C#**: add the `.proto` files to your project with the `Grpc.Tools` package and set `ProtoRoot` to this
  repository's root.
- **Java/Kotlin**: use the `com.google.protobuf` Gradle plugin, or `protobuf-maven-plugin` with Maven, and
  point the proto source directory at a checkout of this repository.
- Other languages: any [gRPC-supported language](https://grpc.io/docs/languages/) works with its own
  `protoc` plugin; the steps above are the same.

## Connecting

Every member connects with a client certificate issued by Mica, and verifies Mica's server certificate
against the root CA Mica gives you. You will need the root CA, your certificate and your private key.
In every language the steps are the same:

1. Build channel credentials from the root CA, your certificate chain and your private key.
2. Open a secure channel to your environment's endpoint.
3. Create a stub for `mica.member.ping.v1.PingService` and call `Ping`. A `STATUS_SUCCESS` response with the
   service type and build version confirms that connectivity and certificates work.

If you are an issuer or acceptor, you also need to run a gRPC server implementing the `*_from_mica`
service for your role, protected with the same mutual TLS.

## Keeping up to date

Each release is tagged `vX.Y.Z` (pre-releases `vX.Y.Z-preN`). Regenerate against the tag you target.
