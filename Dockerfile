FROM node:14-alpine as builder
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm build

# rm = 제거
RUN rm /usr/bin/wget
RUN rm /usr/bin/nc
RUN rm /sbin/route
RUN rm /bin/ping

# 컨테이너 내의 OS 계정에 쉘 권한을 제거
RUN apk --no-cache add shadow && usermod --shell /sbin/nologin nobody
# --no-cache : 로컬에 빌드를 캐시하지 않도록 하여, 처음 빌드 할 때와 동일하게 모든 레이어를 다시 빌드하도록
# usermode --shell : 쉘 변경
# /sbin/nologin : 로그인이 안되는 계정

## 디렉토리 권한 변경
RUN chown -R nobody:nobody /usr/src/app

## root 외 계정으로 어플리케이션 구동
USER nobody

EXPOSE 8080
CMD [ "npm", "run", "serve" ]