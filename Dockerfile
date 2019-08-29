FROM golang:1.12.5 as builder
RUN mkdir /build 
ADD . /build/
WORKDIR /build 
RUN go get "github.com/Travix-International/vault-backend-migrator"
RUN go build -o vault-backend-migrator .

FROM buildpack-deps:stretch-scm
COPY --from=builder /build/vault-backend-migrator /usr/bin/
ENTRYPOINT ["/usr/bin/vault-backend-migrator"]