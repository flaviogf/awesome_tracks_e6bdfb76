awesome_tracks_api generated code

```sh
grpc_tools_ruby_protoc -I ./weather_service/protos/ --ruby_out=./awesome_tracks_api/lib/awesome_tracks_api/repositories/ --grpc_out=./awesome_tracks_api/lib/awesome_tracks_api/repositories/ ./weather_service/protos/weather_service.proto
grpc_tools_ruby_protoc -I ./tracks_service/protos/ --ruby_out=./awesome_tracks_api/lib/awesome_tracks_api/repositories/ --grpc_out=./awesome_tracks_api/lib/awesome_tracks_api/repositories/ ./tracks_service/protos/tracks_service.proto
```

tracks_service generated code

```sh
grpc_tools_ruby_protoc -I ./tracks_service/protos/ --ruby_out=./tracks_service/bin/ --grpc_out=./tracks_service/bin/ ./tracks_service/protos/tracks_service.proto
```

weather_service generated code

```sh
grpc_tools_ruby_protoc -I ./weather_service/protos/ --ruby_out=./weather_service/bin/ --grpc_out=./weather_service/bin/ ./weather_service/protos/weather_service.proto
```
