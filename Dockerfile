FROM node:24-bullseye

WORKDIR /app

# Instalar Python y otras herramientas necesarias
RUN apt-get update && apt-get install -y \
    python3 \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Enable corepack y pnpm
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

# Copiar archivos de configuración
COPY pnpm-lock.yaml .npmrc* package.json pnpm-workspace.yaml* ./

# Instalar dependencias
RUN pnpm install --frozen-lockfile

# Copiar el resto del código
COPY . .

# Build de Next.js
RUN pnpm build

# Crear directorio para artifacts
RUN mkdir -p .od/artifacts

# Limpiar caché para reducir tamaño
RUN pnpm prune --production

# Exponer puertos
EXPOSE 3000 7456

# Variables de entorno
ENV NODE_ENV=production
ENV PORT=3000

# Start
CMD ["pnpm", "tools-dev", "run", "web"]
