FROM golang:1.22 as gobuilder

ENV GOOS=linux\
    GOARCH=amd64

RUN mkdir /go/src/logzio
COPY / /go/src/logzio
WORKDIR /go/src/logzio


FROM fluent/fluent-bit:3.1.4-amd64

COPY --from=gobuilder /go/src/logzio/build/out_logzio-linux.so /fluent-bit/bin/
COPY --from=gobuilder /go/src/logzio/fluentbit/fluent-bit.conf /fluent-bit/etc/
COPY --from=gobuilder /go/src/logzio/fluentbit/plugins.conf /fluent-bit/etc/
COPY --from=gobuilder /go/src/logzio/fluentbit/parsers.conf /fluent-bit/etc/

USER nobody

EXPOSE 2020

CMD ["/fluent-bit/bin/fluent-bit", "--config", "/fluent-bit/etc/fluent-bit.conf"]
