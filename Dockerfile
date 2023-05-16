FROM node:14.14.0-alpine
WORKDIR "/app"
COPY ./package.json ./

ARG WEATHER_API_KEY
ENV WEATHER_API_KEY=${WEATHER_API_KEY}
EXPOSE 8000
RUN npm install
COPY ./ ./
RUN echo "$WEATHER_API_KEY"
CMD ["npm", "run", "start"]