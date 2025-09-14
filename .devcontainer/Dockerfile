ARG TERRAGRUNT_VERSION=1.13.1
ARG GO_VERSION=1.25


FROM alpine/terragrunt:${TERRAGRUNT_VERSION} AS terragrunt

FROM mcr.microsoft.com/devcontainers/go:1.25

COPY --from=terragrunt /bin/terraform /usr/local/bin/terragrunt /usr/local/bin/

# Install node and claude code
RUN sudo apt update && sudo apt install -y nodejs npm
RUN npm install -g @anthropic-ai/claude-code
