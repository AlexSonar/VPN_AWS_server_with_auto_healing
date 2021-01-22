# VPN AWS SERVER WITH AUTO HEALING
AWS EC2 instance with VPN server also using auto healing to replace failed Instances

------------------------------------

This tutorial assumes that you are familiar with launching EC2 instances and that you have already created a key pair and a security group.

Optionally, I would recommend considering three options:
 - WireGuard installation
 - Classic OpenVPN installation with Terraform and maintenance with auto-healing configuration
 - Native OpenVPN installation with templates and maintenance with AWS Auto Scaling Group

## About WireGuard
First I would recommend checking the repo like [WireGuard](https://www.wireguard.com/)
and check it best repo [WireGuard VPN installer for Linux servers](https://github.com/angristan/wireguard-install)
and Learn [how to set up your own Wireguard server](https://stanislas.blog/2019/01/how-to-setup-vpn-server-wireguard-nat-ipv6/)


This project is a bash script that aims to set up a WireGuard VPN on a Linux server, as easily as possible!


If WireGuard does not fit your environment? Check out [openvpn-install](https://github.com/angristan/openvpn-install).


# Terraform Automation module 

 In current repository presented scripts that will create in AWS
 a single node OpenVPN Server cluster in a dedicated AWS VPC and subnet. The OpenVPN server is configured to be readily accessible by the users supplied in the Terraform input file. The same Terraform input file can be used to subsequently update the list of authorized users.

## Requirements


Before the start Make sure you have:

 - the actual AWS account
 - the Terraform CLI installed
 - the list of users to provision with OpenVPN access

Moreover, you probably had enough of people snooping on you and want some privacy back or just prefer to have a long-lived static IP.

# CloudWatch and auto healing configuration

It show you how to create a CloudWatch Events rule that monitors for stop and start events invoked by OpsWorks Stacks auto healing.
[Doc CloudWatch and auto healing configuration](https://github.com/AlexSonar/VPN_AWS_server_with_auto_healing/blob/main/docs/Doc_CloudWatch_auto_healing%20_configuration.md)


[User Guide – Securing remote access to AWS VPC](https://openvpn.net/cloud-docs/user-guide-securing-remote-access-to-aws-vpc/)


## Important!
To get started, you can launch a single free tier eligible Linux instance. If you created your AWS account less than 12 months ago, and have not already exceeded the free tier benefits for Amazon EC2, it will not cost you anything to complete this tutorial, because we help you select options that are within the free tier benefits. Otherwise, when you follow this tutorial, you incur the standard Amazon EC2 usage fees from the time that the instance launches until you delete the Auto Scaling group (which is the final task of this tutorial) and the instance status changes to terminated. 

Tasks:

 - Step 1: Create a launch template
 - Step 2: Create an Auto Scaling group
 - Step 3: Verify your Auto Scaling group

using this gude [Getting started with Amazon EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/GettingStartedTutorial.html#gs-create-lt) by 3 steps