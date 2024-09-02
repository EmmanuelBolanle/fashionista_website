FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm config set cache /tmp/npm-cache --global && \
    npm config set userconfig /tmp/.npmrc --global

RUN npm install --unsafe-perm

COPY . .

EXPOSE 80
CMD ["npm", "start"]

