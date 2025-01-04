FROM python:3.13-bookworm
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Download container dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
	curl \
	ca-certificates \
	rustc \
	cargo \
	llvm-14 \
	clang-14

ENV PATH="/root/.local/bin/:$HOME/.cargo/bin/:$PATH"

RUN cargo --version

COPY . /app
WORKDIR /app

# Install dependencies
RUN uv sync --frozen --no-dev --no-cache

CMD ["/app/.venv/bin/fastapi", "run", "txarr/main.py", "--port", "8688", "--host", "0.0.0.0"]