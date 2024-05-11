FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/flatpak-module-tools@sha256:34b6bfca9d1023b64d1171e24eff4505a60b0f863d64f6c467e085a6ab82a531 as install

COPY container.yaml /tmp/
RUN \
    flatpak-module container-install \
        --containerspec=/tmp/container.yaml

FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/flatpak-module-tools@sha256:34b6bfca9d1023b64d1171e24eff4505a60b0f863d64f6c467e085a6ab82a531 as export

COPY container.yaml /tmp
RUN --mount=type=bind,src=/contents,dst=/contents,from=install \
    --mount=type=bind,rw,z,src=export,dst=/export \
    flatpak-module container-export \
        --containerspec=/tmp/container.yaml \
        --resultdir=/export

FROM oci-archive:export/out.ociarchive
