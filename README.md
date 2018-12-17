# AzureOMSWorkspaceIntegration

<p>This template deploys a pre-confgured self-contained POC environment for the purposes of illustrating integration between the F5 BIG-IP and Azure OMS Log Analytics.  Once deployed, the BIG-IP will automatically begin to send WAF security logs to the accompanying OMS workspace.</P>
<P>The deployment consists of: <br> 1 virtual network with a single subnet <br> 1 - OMS workspace w/Dashboard<br> 1- F5 BIG-IP PAYG Virtual Edition (WAF and load balancing services) with NSG and public endpoint<br> 1- Bitnami Apache2 Webserver - (backend Workload)
<br></P><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fgregcoward%2FAzureOMSWorkspaceIntegration%2Fmaster%2Fazuredeploy.json"><img src="http://azuredeploy.net/deploybutton.png"></a>
