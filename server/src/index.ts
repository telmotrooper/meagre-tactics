import { serve } from "@hono/node-server"
import { showRoutes } from "hono/dev"
import { logger } from "hono/logger"
import { cors } from "hono/cors"
import { Hono } from "hono"

const app = new Hono()

app.use(logger())
app.use(cors({
  origin: [
    "https://telmotrooper.github.io/meagre-tactics",
    "https://localhost:4443"
  ]
}))

app.get("/health-check", (c) => {
  return c.json({
    status: "available",
    timestamp: new Date().toISOString()
  })
})


serve({
  fetch: app.fetch,
  port: 3000
}, (info) => {
  showRoutes(app)
  console.log(`\nServer is running on http://localhost:${info.port}`)
})
