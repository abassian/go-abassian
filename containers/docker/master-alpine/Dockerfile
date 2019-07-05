FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 --branch release/1.8 https://github.com/abassian/go-abassian && \
  (cd go-abassian && make gbas) && \
  cp go-abassian/build/bin/gbas /gbas && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-abassian && rm -rf /var/cache/apk/*

EXPOSE 8515
EXPOSE 30313

ENTRYPOINT ["/gbas"]
