#!/bin/bash
yum update -y
yum install -y nginx aws-cli
systemctl start nginx
systemctl enable nginx

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
IP=$(hostname -I)

# S3 Bucket Name
BUCKET="parvinder-demo-bucket"

# S3 list
S3_BUCKET_LIST=$(aws s3 ls 2>&1)
S3_FILES=$(aws s3 ls s3://$BUCKET 2>&1)

# IAM identity
IAM_ID=$(aws sts get-caller-identity 2>&1)

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>AWS Load Balancer Demo</title>
<style>
body {
  background: linear-gradient(to right, #1e3c72, #2a5298);
  color: white;
  font-family: Arial;
  text-align: center;
  padding-top: 80px;
}
.card {
  background: rgba(0,0,0,0.4);
  padding: 25px;
  border-radius: 15px;
  display: inline-block;
  width: 70%;
}
pre {
  text-align: left;
  background: black;
  padding: 10px;
  border-radius: 10px;
  overflow-x: auto;
}
</style>
</head>
<body>
<div class="card">
  <h1>🚀 AWS Load Balanced App</h1>

  <p><b>Instance ID:</b> $INSTANCE_ID</p>
  <p><b>Private IP:</b> $IP</p>
  <p><b>Availability Zone:</b> $AZ</p>
  <p>Served via Application Load Balancer</p>

  <h3>🔐 IAM Role Identity</h3>
  <pre>$IAM_ID</pre>

  <h3>📦 S3 Buckets List</h3>
  <pre>$S3_BUCKET_LIST</pre>

  <h3>📁 Files in Bucket ($BUCKET)</h3>
  <pre>$S3_FILES</pre>

</div>
</body>
</html>
EOF