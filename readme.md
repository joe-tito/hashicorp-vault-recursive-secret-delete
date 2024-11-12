# Instructions

1. Open generate-delete-commands.sh and update envs_to_delete variable to include the list of environments that you wish to generate delete commands for (i.e. DEV, SAI, PROD).
2. Login to Vault on CLI
3. Run the following to generate delete commands
   ```
   ./generate-delete-commands.sh
   ```
4. Validate the list of generated delete commands to ensure it is only generating commands for expected secrets
5. Run the delete commands in a terminal or shell script
