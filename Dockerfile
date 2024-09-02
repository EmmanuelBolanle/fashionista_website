FROM node:14

RUN mkdir -p /home/node/.npm && \
    chown -R node:node /home/node/.npm

USER node

WORKDIR /app

COPY --chown=node:node package*.json ./

RUN npm config set cache /home/node/.npm --userconfig /home/node/.npmrc --unsafe-perm && \
    npm install

COPY --chown=node:node . .

CMD ["npm", "start"]

