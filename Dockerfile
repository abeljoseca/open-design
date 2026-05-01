# Updated for Railway - with Python support and proper build handling
FROM node:24-bullseye

WORKDIR /app

# Instalar Python y herramientas de compilación
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Enable corepack y pnpm
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

# Copiar archivos de configuración
COPY pnpm-lock.yaml .npmrc* package.json pnpm-workspace.yaml* ./

# Instalar dependencias (permitir postinstall)
RUN pnpm install --frozen-lockfile

# Copiar TODO el código
COPY . .

# Reinstalar en el directorio de la app web para asegurar que todo esté
RUN pnpm install --frozen-lockfile

# Build de Next.js
RUN pnpm build

# Crear directorio para artifacts
RUN mkdir -p .od/artifacts

# Exponer puertos
EXPOSE 3000 7456

# Variables de entorno
ENV NODE_ENV=production
ENV PORT=3000

# Start
CMD ["pnpm", "tools-dev", "run", "web"]
