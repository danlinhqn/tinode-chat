# Docker file builds an image with a tinode chat server.
FROM alpine:3.17

ARG VERSION=0.22.11
ENV VERSION=$VERSION
ARG BINVERS=$VERSION

LABEL maintainer="Tinode Team <info@tinode.co>"
LABEL name="TinodeChatServer"
LABEL version=$VERSION

# Build-time options.

# Database selector. Builds for MySQL by default.
ARG TARGET_DB=mongodb
ENV TARGET_DB=$TARGET_DB

# Specifies the database host:port pair to wait for before running Tinode.
# Ignored if empty.
ENV WAIT_FOR=

# An option to reset database.
ENV RESET_DB=false

# An option to upgrade database.
ENV UPGRADE_DB=false

# Option to skip DB initialization when it's missing.
ENV NO_DB_INIT=false

# Load sample data to database from data.json.
ARG SAMPLE_DATA=data.json
ENV SAMPLE_DATA=$SAMPLE_DATA

# Default country code to use in communication.
ENV DEFAULT_COUNTRY_CODE=US

# Disable chatbot plugin by default.
ENV PLUGIN_PYTHON_CHAT_BOT_ENABLED=false

# Default handler for large files
ENV MEDIA_HANDLER=fs

# Whitelisted domains for file and S3 large media handler.
ENV FS_CORS_ORIGINS='["*"]'
ENV AWS_CORS_ORIGINS='["*"]'

# AWS S3 parameters -> Lưu hình ảnh, cũng như video khi nhắn tin
ENV AWS_ACCESS_KEY_ID="6GQQBFCWHH4HGZHLM5A3"
ENV AWS_SECRET_ACCESS_KEY="AnlFj1IM5zWCEDIMuvN6Wdk2W2bfckL91cgcFcJK"
ENV AWS_REGION="us-east-1"
ENV AWS_S3_BUCKET="tinode-chat"

# Default externally-visible hostname for email verification.
ENV SMTP_HOST_URL='http://localhost:6060'
# Email parameters decalarations.
ENV SMTP_SERVER=
ENV SMTP_PORT=
ENV SMTP_SENDER=
ENV SMTP_LOGIN=
ENV SMTP_PASSWORD=
ENV SMTP_AUTH_MECHANISM=
ENV SMTP_HELO_HOST=
ENV EMAIL_VERIFICATION_REQUIRED=
ENV DEBUG_EMAIL_VERIFICATION_CODE=

# Whitelist of permitted email domains for email verification (empty list means all domains are permitted)
ENV SMTP_DOMAINS=''

# Various encryption and salt keys. Replace with your own in production.

# Salt used to generate the API key. Don't change it unless you also change the
# API key in the webapp & Android.
ENV API_KEY_SALT=T713/rYYgW7g4m3vG6zGRh7+FM1t0T8j13koXScOAj4=

# Key used to sign authentication tokens.
ENV AUTH_TOKEN_KEY=wfaY2RgF2S1OQI/ZlK+LSrp1KB2jwAdGAIHQ7JZn+Kc=

# Key to initialize UID generator
ENV UID_ENCRYPTION_KEY=la6YsO+bNX/+XIkOqc5Svw==

# Disable TLS by default.
ENV TLS_ENABLED=false
ENV TLS_DOMAIN_NAME=
ENV TLS_CONTACT_ADDRESS=

# Disable push notifications by default.
ENV FCM_PUSH_ENABLED=false
# Declare FCM-related vars -> Tại đây đang lấy VD firebase của Opinvn , viết lại Docs cách lấy 6 thông số này.
ENV FCM_API_KEY="AIzaSyAiMhY9OpuMfbQDZ4uddJDqiH8ltmz5hjc"
ENV FCM_APP_ID="1:776695965906:web:5d02e47d17afecba09e50b"
ENV FCM_SENDER_ID="776695965906"
ENV FCM_PROJECT_ID="chat-tinode-44461"
ENV FCM_VAPID_KEY="BGFibaWMLJAbPJRljSW35ARlIEf6JTEvBX5jtTbLp4URi6IpMa2c-QjhatSgdRvlDaBH4MJnAtUheV_Y5KEab8M"
ENV FCM_MEASUREMENT_ID="G-G4TTNYMYJ3"

# Enable Android-specific notifications by default.
ENV FCM_INCLUDE_ANDROID_NOTIFICATION=true

# Disable push notifications via Tinode Push Gateway.
ENV TNPG_PUSH_ENABLED=false

# Tinode Push Gateway authentication token.
ENV TNPG_AUTH_TOKEN=

# Tinode Push Gateway organization name as registered at console.tinode.co
ENV TNPG_ORG=

# Video calls configuration.
ENV WEBRTC_ENABLED=false
ENV ICE_SERVERS_FILE=

# Use the target db by default.
# When TARGET_DB is "alldbs", it is the user's responsibility
# to set STORE_USE_ADAPTER to the desired db adapter correctly.
ENV STORE_USE_ADAPTER=$TARGET_DB

# Url path for exposing the server's internal status. E.g. '/status'
ENV SERVER_STATUS_PATH=''

# Garbage collection of unfinished account registrations.
ENV ACC_GC_ENABLED=false

# Install root certificates, they are needed for email validator to work
# with the TLS SMTP servers like Gmail or Mailjet. Also add bash and grep.
RUN apk update && \
	apk add --no-cache ca-certificates bash grep

WORKDIR /opt/tinode

# Copy config template to the container.
COPY config.template .
COPY credentials.sh .
COPY entrypoint.sh .

# Make scripts runnable
RUN chmod +x credentials.sh
RUN chmod +x config.template
RUN chmod +x entrypoint.sh

# Biên dịch lại qua Linux
RUN dos2unix entrypoint.sh

# Get Source Tại Đây
COPY web-mongodb /opt/tinode

# Create directory for chatbot data.
RUN mkdir /botdata

# Generate config from template and run the server.
#ENTRYPOINT ["./entrypoint.sh"]

# Dùng trên macbook
ENTRYPOINT ./entrypoint.sh 

# HTTP, gRPC, cluster ports
EXPOSE 6060 16060 12000-12003