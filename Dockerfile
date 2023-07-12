FROM node:14.14.0-alpine
WORKDIR "/app"
COPY ./package.json ./

EXPOSE 8000
RUN npm install
COPY ./ ./

CMD ["npm", "run", "start"]