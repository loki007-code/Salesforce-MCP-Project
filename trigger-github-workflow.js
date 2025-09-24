import { MCPClient } from "@nextdrive/github-action-trigger-mcp";

async function triggerWorkflow() {
  const client = new MCPClient({
    serverName: "GitHub Actions Trigger"
  });
  const response = await client.invoke("trigger_github_action", {
    owner: "loki007-code",
    repo: "Salesforce-my-devorg",
    workflow_id: "deploy.yml",
    inputs: { env: "sandbox", feature_branch: "feature/abc" }
  });
  console.log("Workflow trigger response:", response);
}

triggerWorkflow().catch(console.error);
