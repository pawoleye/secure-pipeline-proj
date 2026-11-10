FROM node:20-slim

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

ENV NODE_ENV=production
EXPOSE 3000

# Run as the non-root user that ships with the node image
USER node

CMD ["node", "app.js"]
