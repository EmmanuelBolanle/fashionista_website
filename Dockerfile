FROM node:14

WORKDIR /app


USER root
RUN npm config set unsafe-perm true

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]

