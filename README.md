# Mica protos

The public API definitions for the [Mica](https://mica.io) network. Mica is a gRPC API secured with mutual
TLS; these protobuf files define every service and message that issuers and acceptors use.

## Using the API

Pick the role you play, and use the SDK for your language:

| Language | Repository |
| --- | --- |
| Go | [1080network/golang](https://github.com/1080network/golang) |
| Kotlin / Java | [1080network/kotlin](https://github.com/1080network/kotlin) |
| C# / .NET | [1080network/dotnet](https://github.com/1080network/dotnet) |
| Node.js / TypeScript | [1080network/node](https://github.com/1080network/node) |
| Python | [1080network/python](https://github.com/1080network/python) |
| Ruby | [1080network/ruby](https://github.com/1080network/ruby) |
| Rust | [1080network/rust](https://github.com/1080network/rust) |
| PHP | [1080network/php](https://github.com/1080network/php) |
| C++ | [1080network/cpp](https://github.com/1080network/cpp) |

Each SDK is split by role, so you install only the code for the roles you play. The SDKs are generated from the protos in this repository (the C++ SDK builds them with CMake against your own protobuf and gRPC). If your language isn't listed, or you want to
generate the code yourself, see [Building your own SDK](docs/build-your-own-sdk.md).

## Layout

- `mica/issuer`, `mica/acceptor`: the APIs for each role
- `mica/member`, `mica/common`, `micashared`: shared by every role
- `buf.gen.yaml`, `generate.sh`: generate client code for the supported languages (C++ is built from the protos with CMake instead, see the C++ SDK)
- `docs/`: guides

Releases are tagged `vX.Y.Z`, with pre-releases tagged `vX.Y.Z-preN`.

## Linting

```bash
make lint
```
