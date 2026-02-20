/**
 * Agent Notification Plugin for OpenCode
 * 
 * Sends audio (ElevenLabs voice) and visual (notify-send) notifications
 * when agent sessions complete.
 * 
 * Uses the agent-notify script from ~/code/work/agents/.shared/
 */

export const AgentNotificationPlugin = async ({ $, directory }) => {
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
        // Capitalize first letter for nicer pronunciation
        return agentName.charAt(0).toUpperCase() + agentName.slice(1)
      }
    }
    
    // Default fallback
    return "OpenCode"
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
        if (agentName === "OpenCode") {
          return
        }
        
        try {
          // Call agent-notify which handles both audio and desktop notification
          await $`agent-notify ${agentName} "Task completed"`
        } catch (error) {
          // Silently fail - don't interrupt the session for notification errors
          console.error("Agent notification failed:", error.message)
        }
      }
    },
  }
}
