FROM node:14.14.0-alpine
WORKDIR "/app"
COPY ./package.json ./

# ARG WEATHER_API_KEY=1eef195e3a5c0820a311deedd4bba6a8
RUN echo "$WEATHER_API_KEY"
EXPOSE 8000
RUN npm install
COPY ./ ./

CMD ["npm", "run", "start"]