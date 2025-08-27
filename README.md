Specify parameters in dev.json, prod.json, test.json <br><br>
Specify parameters in dev.json, prod.json, test.json <br><br>

az login <br><br>

Dev: <br>
az deployment group create --resource-group rg-johanhultin --template-file .\main.bicep --parameters '@.\parameters\dev.json' <br><br>

Prod: <br>
az deployment group create --resource-group rg-johanhultin --template-file .\main.bicep --parameters '@.\parameters\prod.json' <br><br>

Test: <br>
az deployment group create --resource-group rg-johanhultin --template-file .\main.bicep --parameters '@.\parameters\test.json' <br><br>

Setting secret: <br><br>

Note: Due to policy of not being able to show account objectId, before setting secret: <br>
In azure portal of chosen keyvault -> Access policies -> Create -> Secret permissions Get, List, Set -> Principal Your account -> Create <br><br>

Dev: <br>
az keyvault secret set --vault-name 'YourVaultName' --name 'SecretName' --value 'YourSecretHere' <br><br>

Prod: <br>
az keyvault secret set --vault-name 'YourVaultName' --name 'SecretName' --value 'YourSecretHere' <br><br>

Test: <br>
az keyvault secret set --vault-name 'YourVaultName' --name 'SecretName' --value 'YourSecretHere' <br><br>
