# Updated for Railway - with Python support and proper postinstall handling
FROM node:24-bullseye

WORKDIR /app

# Instalar Python y herramientas de compilación
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Enable corepack y pnpm
RUN corepack enable && corepack prepare pnpm@10.33.2 --activate

# Copiar solo archivos de configuración
COPY pnpm-lock.yaml .npmrc* package.json pnpm-workspace.yaml* ./

# Instalar dependencias SIN ejecutar postinstall scripts
RUN pnpm install --frozen-lockfile --ignore-scripts

# Ahora copiar TODO el código (incluyendo scripts/)
COPY . .

# Ejecutar postinstall scripts manualmente
RUN pnpm exec pnpm run -r postinstall || true

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
