
#----------------------------------------------------------------------
#https://gallery.ecr.aws/docker/library/golang
ARG BASE_IMAGE="public.ecr.aws/docker/library/golang:1.22.0-alpine3.19" 
#----------------------------------------------------------------------
FROM $BASE_IMAGE as builder
#VARIABLES FOR bom
ARG     BOM_VERSION="v0.6.0"

# Install required packages and clean up
#https://pkg.go.dev./sigs.k8s.io/bom@v0.6.0
RUN go install sigs.k8s.io/bom/cmd/bom@${BOM_VERSION} 

# Final stage
FROM alpine:3.19.1
COPY --from=builder /go/bin/bom /usr/local/bin/bom
HEALTHCHECK --interval=120s --timeout=245s --start-period=10s \
CMD     bom version || exit 1
ENTRYPOINT      []
