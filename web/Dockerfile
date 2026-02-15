FROM node:20-alpine

WORKDIR /app

# Copia arquivos de dependência (se existirem após o nuxi init)
COPY package*.json ./

RUN if [ -f package.json ]; then npm install; fi

COPY . .

EXPOSE 3001

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "3001"]
