FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/flatpak-module-tools@sha256:b786d0168bbf3593c822fd75b375e15f331d144427a347d823c48ca85323ce37 as install

COPY container.yaml /tmp/
RUN \
    flatpak-module container-install \
        --containerspec=/tmp/container.yaml

FROM quay.io/redhat-user-workloads/otaylor-tenant/flatpak-module-tools/flatpak-module-tools@sha256:b786d0168bbf3593c822fd75b375e15f331d144427a347d823c48ca85323ce37 as export

COPY container.yaml /tmp
RUN --mount=type=bind,rw,src=/contents,dst=/contents,from=install \
    --mount=type=bind,rw,z,src=export,dst=/export \
    flatpak-module container-export \
        --containerspec=/tmp/container.yaml \
        --resultdir=/export

FROM oci-archive:export/out.ociarchive

# Need to reference the export stage here to force ordering.
# But since we have to run something anyway, we might as well
# cleanup after ourselves.
RUN --mount=type=bind,from=export,target=/var/tmp \
    --mount=type=bind,rw,z,src=export,dst=/export \
    rm /export/out.ociarchive
