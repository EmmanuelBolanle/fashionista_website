FROM node:14

USER root

RUN groupadd -r jenkins && useradd -r -g jenkins jenkins

RUN npm config set unsafe-perm true

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

USER jenkins

CMD ["node", "app.js"]

