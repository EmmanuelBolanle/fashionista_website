FROM node:14

WORKDIR /app

COPY package*.json ./

RUN npm config set cache /home/node/.npm --unsafe-perm \
    && npm install

COPY . .

EXPOSE 80
CMD ["npm", "start"]

