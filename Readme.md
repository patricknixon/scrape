# Strip

Download HLS streams

## _Caveat Emptor_

Strip only vaguely works. You'd be crazy to want to use it.

1. It attempts to download all referenced resources immediately. This tends to
fail for a variety of reasons. It's only likely to work for very short HLS
streams with few variants.
2. It doesn't reload playlists. That means it doesn't remotely follow the HLS
specification. For live streams, it will only download a snapshot of resources
that are exposed at that point in time.
2. It doesn't report progress.
3. It doesn't let you select a variant. It's all or nothing.
4. It doesn't retry on failure.
5. It noisily prints lots of useless information.
6. It never exits except in the case of a few fatal errors. You have to Ctl-C
it, and it doesn't tell you when it's done.

