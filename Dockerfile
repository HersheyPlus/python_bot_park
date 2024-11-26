FROM python:3.12-alpine

# Install system dependencies including X11 and GUI requirements
RUN apk add --no-cache \
    build-base \
    python3-dev \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    openssl-dev \
    gcc \
    musl-dev \
    jpeg-dev \
    zlib-dev \
    # GUI dependencies
    xvfb \
    xvfb-run \
    mesa-gl \
    mesa-dev \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    xorg-server-dev \
    freetype-dev \
    harfbuzz-dev

# Create non-root user
RUN adduser -D -u 1000 botuser

# Set working directory
WORKDIR /bot

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY --chown=botuser:botuser . .

# Create necessary directories
RUN mkdir -p logs downloads \
    && chown -R botuser:botuser logs downloads

# Switch to non-root user
USER botuser

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    BOT_LOG_FILE=/bot/logs/bot.log \
    ERROR_LOG_FILE=/bot/logs/error.log \
    DEFAULT_DOWNLOAD_PATH=/bot/downloads \
    DISPLAY=:99

CMD ["python", "main.py"]