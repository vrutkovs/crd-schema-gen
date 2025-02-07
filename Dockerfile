FROM registry.svc.ci.openshift.org/openshift/release:golang-1.12 AS builder
WORKDIR /go/src/github.com/openshift/crd-schema-gen
COPY . .
ENV GO_PACKAGE github.com/openshift/crd-schema-gen
RUN go build -o crd-schema-gen cmd/crd-schema-gen/main.go

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/crd-schema-gen/crd-schema-gen /
COPY --from=builder /usr /usr
ENV GOPATH=/go
ENV PATH="/usr/local/go/bin:${PATH}"
ENTRYPOINT ["/crd-schema-gen"]