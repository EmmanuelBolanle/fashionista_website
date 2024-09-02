FROM node:14

RUN groupadd -g 111 mygroup && \
    useradd -r -u 111 -g mygroup myuser && \
    mkdir -p /home/myuser/.npm && \
    chown -R myuser:mygroup /home/myuser

USER myuser

WORKDIR /app

COPY package*.json ./

RUN npm config set cache /home/myuser/.npm --unsafe-perm && npm install

COPY . .

EXPOSE 3000
CMD ["node", "app.js"]

