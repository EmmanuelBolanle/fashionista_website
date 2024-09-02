FROM node:14

USER root

RUN mkdir -p /home/node/.npm && \
    chown -R node:node /home/node/.npm

USER node

WORKDIR /app

COPY package*.json ./

RUN npm config set cache /home/node/.npm --unsafe-perm && npm install

COPY . .

EXPOSE 3000
CMD ["node", "app.js"]

