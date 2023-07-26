FROM node:14.14.0-alpine

ARG WEATHER_API_KEY
ENV WEATHER_API_KEY=${WEATHER_API_KEY}

WORKDIR "/app"
COPY ./package.json ./

EXPOSE 8000
RUN npm install
COPY ./ ./

CMD ["npm", "run", "start"]