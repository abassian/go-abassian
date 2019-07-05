FROM ubuntu:xenial

ENV PATH=/usr/lib/go-1.9/bin:$PATH

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang-1.9 git make gcc libc-dev ca-certificates && \
  git clone --depth 1 https://github.com/abassian/go-abassian && \
  (cd go-abassian && make gbas) && \
  cp go-abassian/build/bin/gbas /gbas && \
  apt-get remove -y golang-1.9 git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /go-abassian

EXPOSE 8515
EXPOSE 30313

ENTRYPOINT ["/gbas"]
