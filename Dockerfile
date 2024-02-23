FROM node:16

WORKDIR /rioba-app
COPY package.json .
RUN npm install
COPY . .
CMD npm start