FROM node:14


RUN useradd -ms /bin/sh -u 1001 appuser

WORKDIR /app


USER appuser


RUN npm config set unsafe-perm true


COPY --chown=appuser:appuser package*.json ./
RUN npm install


COPY --chown=appuser:appuser . .

EXPOSE 3000

CMD ["npm", "start"]

