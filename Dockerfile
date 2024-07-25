FROM python:3.8-slim
WORKDIR /app
COPY . /app
RUN apt-get update && \
    apt-get install -y fortune-mod cowsay && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EXPOSE 4499
CMD ["./wisecow.sh"]
