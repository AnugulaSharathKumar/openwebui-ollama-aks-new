# Multi-stage build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

FROM node:18-alpine AS runtime
WORKDIR /app

# Install only essential dependencies
RUN apk add --no-cache \
    curl \
    python3 \
    make \
    g++ \
    && addgroup -g 1001 -S nodejs \
    && adduser -S nextjs -u 1001

# Copy built dependencies
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Change ownership
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/api/health || exit 1

# Start application
CMD ["npm", "start"]