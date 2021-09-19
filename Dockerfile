FROM node:14 as builder
WORKDIR /projects
RUN : \
    && apt-get update \
	&& apt-get install -y --no-install-recommends \
		xvfb \
		x11vnc \
		fluxbox \
		dbus-x11 \
		x11-utils \
		x11-xserver-utils \
		xdg-utils \
		fbautostart \
		xterm \
		eterm \
		seahorse \
		libx11-dev \
		libxkbfile-dev \
		libsecret-1-dev \
		libnotify4 \
		libnss3 \
		libxss1 \
		libasound2 \
		libgbm1 \
		xfonts-base \
		xfonts-terminus \
		fonts-noto \
		fonts-wqy-microhei \
		fonts-droid-fallback \
		libgconf2-dev \
		libgtk-3-dev \
		twm \
	&& chown -R node /projects \
	&& :

USER node

RUN : \
	&& git clone --depth 1 https://github.com/gitpod-io/openvscode-server \
	&& cd openvscode-server \
	&& yarn \
	&& yarn gulp server-min \
	&& :
RUN : \
	&& export VSCODE_VERSION=$(node -p -e "require('./server-pkg/package.json').version") \
	&& export OS_VERSION=$(uname | tr  '[:upper:]' '[:lower:]') \
	&& export ARCH_TYPE=$(uname -m | tr  '[:upper:]' '[:lower:]') \
	&& cd /projects \
	&& mv server-pkg "openvscode-server-v${VSCODE_VERSION}-${OS_VERSION}-${ARCH_TYPE}" \
	&& mkdir -p /projects/artifacts \
	&& tar -zcvf "/projects/artifacts/openvscode-server-v${VSCODE_VERSION}-${OS_VERSION}-${ARCH_TYPE}.tar.gz" \
	"openvscode-server-v${VSCODE_VERSION}-${OS_VERSION}-${ARCH_TYPE}" \
	&& :

FROM node:14
USER node
WORKDIR /code
COPY --from=builder /projects/artifacts/* .
CMD tail -f /dev/null
