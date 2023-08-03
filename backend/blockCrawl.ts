import { parseAbiItem, type Hex } from 'viem'
import { decodeLogs } from './transform/decodeLogs'
import { viemClient } from './viem/client'
import { databaseAbiEventsArray } from './constants/events'
import { writeToDatabase } from './prisma'

export const blockCrawl = () => {
  databaseAbiEventsArray.forEach((event: string) => {
    const parsedEvent = parseAbiItem([event])
    viemClient.watchEvent({
      address: process.env.DATABASE_ADDRESS as Hex,
      event: parsedEvent,
      onLogs: (logs) => {
        writeToDatabase(decodeLogs(logs))
      },
    })
  })
}
