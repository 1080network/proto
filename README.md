# Mica protos

The public API definitions for the [Mica](https://mica.io) network. Mica is a gRPC API secured with mutual
TLS; these protobuf files define every service and message that issuers and acceptors use.

## Using the API

Pick the role you play, and use the SDK for your language:

| Language | Repository |
| --- | --- |
| Go | [1080network/golang](https://github.com/1080network/golang) |
| Kotlin / Java | [1080network/kotlin](https://github.com/1080network/kotlin) |
| Python | [1080network/python](https://github.com/1080network/python) |
| C# / .NET | [1080network/dotnet](https://github.com/1080network/dotnet) |

The SDKs are generated from the protos in this repository. If your language isn't listed, or you want to
generate the code yourself, see [Building your own SDK](docs/build-your-own-sdk.md).

## Layout

- `mica/issuer`, `mica/acceptor`: the APIs for each role
- `mica/member`, `mica/common`, `micashared`: shared by every role
- `buf.gen.yaml`, `generate.sh`: generate client code for every supported language
- `docs/`: guides

Releases are tagged `vX.Y.Z`, with pre-releases tagged `vX.Y.Z-preN`.

## Linting

```bash
make lint
```
