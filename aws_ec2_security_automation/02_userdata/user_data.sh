# Placez votre script user_data dans un fichier (par exemple, user_data.sh)
echo '#!/bin/bash
curl -O https://inspector-agent.amazonaws.com/linux/latest/install
sudo bash install

snap install amazon-ssm-agent --classic
systemctl start snap.amazon-ssm-agent.amazon-ssm-agent
              systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
              wget https://inspector-agent.amazonaws.com/linux/latest/install
              bash install
              systemctl start awsagent
              systemctl enable awsagent
' > user_data_test.sh


# Encodez le contenu en Base64
base64 -w 0 user_data_test.sh


# wget https://d1wk0tztpsntt1.cloudfront.net/linux/latest/install
# chmod +x install
# sudo ./install

#!/bin/bash
# Check SSM Agent status
ssm_status=$(systemctl is-active snap.amazon-ssm-agent.amazon-ssm-agent)
echo "SSM Agent status: $ssm_status"

# Check AWS Inspector Agent status
inspector_status=$(systemctl is-active awsagent)
echo "Inspector Agent status: $inspector_status"