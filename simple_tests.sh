aws ec2 create-security-group \
        --group-name c03-aws01-sg \
        --description "Allow connection to port 80" \
        --vpc-id vpc-027019faaf6756407 \
        --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=c03-aws01-sg},{Key=DevopsClass,Value=c03}]"

aws ec2 authorize-security-group-ingress \
    --group-id sg-098dda5e94f8a3855 \
    --cidr 0.0.0.0/0 \
    --port 80 \
    --protocol tcp

aws autoscaling create-launch-configuration \
    --launch-configuration-name devops-init-instance-data \
    --user-data file://user-data.txt \
    --image-id ami-088ff0e3bde7b3fdf \
    --instance-type t2.micro \
    --security-groups sg-098dda5e94f8a3855

aws autoscaling create-auto-scaling-group \
        --auto-scaling-group-name asg-devops \
        --min-size 1 --max-size 2 --desired-capacity 2 \
        --launch-configuration-name devops-init-instance-data \
        --vpc-zone-identifier "subnet-0f82d6e49b9a6dafd" \
        --tags Key=DevopsClass,Value=c03 \
               Key=Name,Value=devops-asg

aws elbv2 register-targets \
        --target-group-arn arn:aws:elasticloadbalancing:ap-southeast-2:097922957316:targetgroup/devopsacademy-lb-tg/f53590c0090c6267 \
        --targets Id=i-002286df2fc343a9b Id=i-070dfcd5233b94cda

watch aws elbv2 describe-target-health \
    --target-group-arn arn:aws:elasticloadbalancing:ap-southeast-2:097922957316:targetgroup/devopsacademy-lb-tg/f53590c0090c6267


aws route53 test-dns-answer --hosted-zone-id Z0196050222F6QCNUZ2I2 --record-type CNAME --record-name test.alan-devops.tk