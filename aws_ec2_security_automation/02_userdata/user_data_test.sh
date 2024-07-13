#!/bin/bash
curl -O https://inspector-agent.amazonaws.com/linux/latest/install
sudo bash install
snap install amazon-ssm-agent --classic
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent
systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent

