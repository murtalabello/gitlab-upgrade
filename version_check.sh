name: GitLab Upgrade Workflow

on:
  push:
    branches:
      - master
  workflow_dispatch:  # Allow manual triggering of the workflow

jobs:
  upgrade:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout the repository
      - name: Checkout Code
        uses: actions/checkout@v3

      # Step 2: Install Ansible
      - name: Install Ansible
        run: |
          sudo apt-get update
          sudo apt-get install -y ansible

      # Step 3: Configure SSH Connection
      - name: Configure SSH Connection
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" | tr -d '\r' > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H ${{ secrets.GITLAB_HOST }} >> ~/.ssh/known_hosts

      # Step 4: Validate Upgrade Path
      - name: Validate Upgrade Path
        run: |
          ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no azureuser@${{ secrets.GITLAB_HOST }} "sudo bash -s" < version_check.sh || echo "Intermediate upgrade needed."
        env:
          GITLAB_HOST: ${{ secrets.GITLAB_HOST }}

      # Step 5: Run Ansible Playbook for Intermediate Upgrade to 17.0
      - name: Run Ansible Playbook to Upgrade to 17.0
        if: always()  # Proceed regardless of validation step output
        run: |
          ansible-playbook -i inventory gitlab_upgrade.yml -e "ansible_python_interpreter=/usr/bin/python3 target_version=17.0"
        env:
          ANSIBLE_HOST_KEY_CHECKING: "False"

      # Step 6: Validate Upgrade Path to 17.3
      - name: Re-Validate Upgrade Path
        run: |
          ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no azureuser@${{ secrets.GITLAB_HOST }} "sudo bash -s" < version_check.sh
        env:
          GITLAB_HOST: ${{ secrets.GITLAB_HOST }}

      # Step 7: Run Ansible Playbook for Final Upgrade to 17.3
      - name: Run Ansible Playbook to Upgrade to 17.3
        run: |
          ansible-playbook -i inventory gitlab_upgrade.yml -e "ansible_python_interpreter=/usr/bin/python3 target_version=17.3"
        env:
          ANSIBLE_HOST_KEY_CHECKING: "False"

      # Step 8: Verify GitLab Version
      - name: Verify GitLab Version
        run: |
          ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no azureuser@${{ secrets.GITLAB_HOST }} "sudo /opt/gitlab/bin/gitlab-rake gitlab:env:info | grep 'Version:'"
        env:
          GITLAB_HOST: ${{ secrets.GITLAB_HOST }}
