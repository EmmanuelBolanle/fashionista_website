USER node

WORKDIR /app

COPY --chown=node:node package*.json ./

RUN npm config set cache /home/node/.npm --userconfig /home/node/.npmrc --unsafe-perm && \
    npm install --unsafe-perm

COPY --chown=node:node . .

CMD ["npm", "start"]


