FROM node:14

RUN mkdir -p /home/node/.npm && \
    chown -R node:node /home/node/.npm

WORKDIR /app

COPY package*.json ./

RUN npm config set cache /home/node/.npm --unsafe-perm && \
    npm install --unsafe-perm

COPY . .

USER node

EXPOSE 80
CMD ["npm", "start"]

