# Secure Pipeline Demo

Small Express app used to demonstrate a GitHub Actions pipeline that runs
SAST (Semgrep), SCA (Snyk), and secrets scanning (Gitleaks) on every pull request.

## Run locally

    npm install
    npm start
    curl localhost:3000/health

## Run with Docker

    docker build -t secure-app .
    docker run -p 3000:3000 secure-app

## Pipeline
