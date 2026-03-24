/**
 * Agent Notification Plugin for OpenCode
 * 
 * Sends audio (ElevenLabs voice) and visual (notify-send) notifications
 * when agent sessions complete.
 * 
 * Uses the agent-notify script from ~/code/work/agents/.shared/
 * 
 * NOTE: Always-on watcher agents (teamswatcher, etc.) are excluded because
 * they go idle after every evaluation cycle, which would spam notifications
 * for every incoming message they process.
 */

// Agents that run continuously and should NOT trigger idle notifications.
// These agents go idle after every evaluation cycle — not when a "task" finishes.
const ALWAYS_ON_AGENTS = new Set([
  "teamswatcher",
])

// Directories that should never trigger agent notifications.
// Headless agent servers (e.g. teamswatcher) use $HOME as cwd to avoid
// matching the agents directory, so suppress that too.
const SUPPRESSED_DIRECTORIES = new Set([
  process.env.HOME,
])

export const AgentNotificationPlugin = async ({ $, directory }) => {
  // Early exit for suppressed directories (headless agent servers)
  if (SUPPRESSED_DIRECTORIES.has(directory)) {
    return {}
  }

  // Extract agent name from directory path
  const getAgentName = (dir) => {
    const agentsDir = `${process.env.HOME}/code/work/agents/`
    
    if (dir && dir.startsWith(agentsDir)) {
      // Extract the agent name from the path
      // e.g., ~/code/work/agents/graphwatcher -> graphwatcher
      const relativePath = dir.slice(agentsDir.length)
      const agentName = relativePath.split("/")[0]
      
      // Skip .shared directory
      if (agentName && agentName !== ".shared") {
        return agentName
      }
    }
    
    return null
  }

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const agentsDir = `${process.env.HOME}/code/work/agents/`
        
        // Only notify for autonomous agents in the agents directory
        // Skip notifications for normal interactive opencode sessions
        if (!directory || !directory.startsWith(agentsDir)) {
          return
        }
        
        const agentName = getAgentName(directory)
        
        // Skip if we couldn't determine a valid agent name
        if (!agentName) {
          return
        }
        
        // Skip always-on watcher agents — they go idle after every
        // evaluation cycle, not when a meaningful task completes
        if (ALWAYS_ON_AGENTS.has(agentName.toLowerCase())) {
          return
        }
        
        // Capitalize first letter for nicer pronunciation
        const displayName = agentName.charAt(0).toUpperCase() + agentName.slice(1)
        
        try {
          // Call agent-notify which handles both audio and desktop notification
          await $`agent-notify ${displayName} "Task completed"`
        } catch (error) {
          // Silently fail - don't interrupt the session for notification errors
          console.error("Agent notification failed:", error.message)
        }
      }
    },
  }
}
