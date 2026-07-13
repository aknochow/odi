# ODI — OpenShell Developer Image
# Cloud development environment for OpenShell and OGO operator development.
#
# Build:  podman build -t quay.io/aknochow/odi:latest .
# Push:   podman push quay.io/aknochow/odi:latest

FROM quay.io/devfile/universal-developer-image:ubi10-latest

ARG GO_VERSION=1.24.5
ARG GOLANGCI_LINT_VERSION=v2.1.0
ARG K9S_VERSION=v0.50.9
ARG GH_VERSION=2.74.1

USER root

RUN dnf -y install \
        bind-utils hostname jq make \
    && dnf -y clean all \
    && rm -rf /var/cache /var/log/dnf* && \
# Go
    curl -LsSf "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
        | tar -C /usr/local -xzf - && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt && \
# golangci-lint
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh \
        | sh -s -- -b /usr/local/bin ${GOLANGCI_LINT_VERSION} && \
# OpenShell CLI
    curl -LsSf https://github.com/NVIDIA/OpenShell/releases/latest/download/openshell-x86_64-unknown-linux-musl.tar.gz \
        | tar xz -C /usr/local/bin/ && \
# k9s
    curl -LsSf "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" \
        | tar xz -C /usr/local/bin/ k9s && \
# gh CLI
    TARBALL="gh_${GH_VERSION}_linux_amd64.tar.gz" && \
    curl -fsSL -o "/tmp/${TARBALL}" \
        "https://github.com/cli/cli/releases/download/v${GH_VERSION}/${TARBALL}" && \
    tar -xzf "/tmp/${TARBALL}" -C /usr/local/bin \
        --strip-components=2 "gh_${GH_VERSION}_linux_amd64/bin/gh" && \
    rm "/tmp/${TARBALL}" && \
# Prompt
    echo "git_branch() { git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'; }" \
        > /etc/profile.d/odi_prompt.sh && \
    echo 'export PS1="\n\[\033[01;32m\]\u\[\033[00m\]@\h [\[\033[34m\]\w\[\033[00m\]] \[\033[33m\]\$(git_branch)\[\033[00m\]\n \$ "' \
        >> /etc/profile.d/odi_prompt.sh && \
    echo 'printf "ODI — OpenShell Developer Image (built on '$(date)')\n\n"' \
        > /etc/profile.d/built_on.sh

# Let's Encrypt YR1 intermediate trust for OpenShell CLI
ENV SSL_CERT_FILE=/etc/pki/tls/certs/ca-bundle.crt

USER user
