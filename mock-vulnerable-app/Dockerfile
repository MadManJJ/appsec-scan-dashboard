# Outdated base image (Triggers Trivy CRITICAL/HIGH findings)
FROM node:14-alpine

WORKDIR /app
COPY app.js .

EXPOSE 3000
CMD ["node", "app.js"]
