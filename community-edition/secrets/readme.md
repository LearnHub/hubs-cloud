AVN Secrets
===========

This folder contains sensitive information that should not be in public source control.

The content of [secret-values.yaml](secret-values.yaml) can be found in Zoho Vault entry *Eduverse HCCE Secret Values*

# Deployments

This folder also contains copies of the hcce.yaml file used for deployments. They are useful to retain for updating because they contain one-time secrets that cause inter-pod issues if they are regenerated.