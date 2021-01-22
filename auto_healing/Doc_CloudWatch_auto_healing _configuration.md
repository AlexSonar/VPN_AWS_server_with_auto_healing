# CloudWatch and auto healing configuration

It show you how to create a CloudWatch Events rule that monitors for stop and start events invoked by OpsWorks Stacks auto healing.

 [OpsWorks Stacks](https://docs.aws.amazon.com/opsworks/latest/userguide/monitoring-cloudwatch-events.html) using CloudWatch event sources to trigger events or notifications, including events triggered by auto healing. You can use these event sources to trigger events or notifications, including events triggered by auto healing.

Previously, you had to orchestrate calls to multiple APIs to trigger events in response to OpsWorks Stacks events. Now, you can use CloudWatch Events to trigger an event when an OpsWorks Stacks instance, deployment, or command state changes. In addition you can use CloudWatch Events to indicate that an OpsWorks Stacks service error was raised.

Events patterns in CloudWatch Events are represented as JSON objects. The following AWS OpsWorks Stacks event types are supported in CloudWatch Events.


 - Instance state changes: Includes states such as “requested”, “online”, “stopped”.
 - Command execution results: Includes states such as “successful”, “failed”, “expired”.
 - Deployment results: Includes states such as “running”, “successful”, “failed”.
 - Alerts: Indicates an OpsWorks Stacks service error was raised.

## Set up the solution

To create CloudWatch rules, you first need to create a target. In this solution we will use an Amazon SNS topic, but Amazon SQS and AWS Lambda functions are other possibilities.

Create an [SNS](http://docs.aws.amazon.com/sns/latest/dg/CreateTopic.html) topic named OpsWorksAutoHealingNotifier. To receive messages published to the topic, you have to [subscribe](https://docs.aws.amazon.com/sns/latest/dg/welcome.html) an endpoint to that topic. Complete the subscription by opening the confirmation message from AWS Notifications, and then click the link to confirm your subscription.

<img align="left" alt="" width="30px" src="https://github.com/AlexSonar/VPN_AWS_server_with_auto_healing/blob/main/auto_healing/imgs/rules-autohealing-expl-001.png" />
<img align="left" alt="" width="30px" src="https://raw.githubusercontent.com/AlexSonar/VPN_AWS_server_with_auto_healing/blob/main/auto_healing/imgs/rules-autohealing-expl-001.png" />
# IMG https://github.com/AlexSonar/VPN_AWS_server_with_auto_healing/blob/main/auto_healing/imgs/rules-autohealing-expl-001.png

Now we are ready to create our CloudWatch Rule.

To create the rule using the AWS Management Console:

 - Open the AWS Management Console, and go to the Amazon CloudWatch console.
 - In the left navigation pane, chose Events.
 - Choose Create Rule, and then choose Show advanced options.
 - Choose Edit the JSON version of the pattern.
 - Paste the contents of the OpsWorksAutoHealingPattern.json file in the text box.
 - Choose Add target under the Targets section. Select the SNS Topic OpsWorksAutoHealingNotifier from the list.
 - Choose Configure details.
 - Name the rule as OpsWorks-AutoHealing.

To create the rule with the AWS CLI:

## 1. Save the following event pattern as a file named OpsWorksAutoHealingPattern.json.

```
{
  "source": [
    "aws.opsworks"
  ],
  "detail": {
    "initiated_by": [
      "auto-healing"
    ]
  }
}
```

## 2. Create a rule named OpsWorks-AutoHealing by running the following command.

```
$ aws events put-rule 
--name OpsWorks-AutoHealing 
--description OpsWorks-AutoHealing 
--event-pattern file://OpsWOrksAutoHealingPattern.json

```
## 3. Make the SNS Topic, OpsWorksAutoHealingNotifier, that you created earlier the target of the rule by running the following command.

```
$ aws events put-targets 
--rule OpsWorks-AutoHealing 
--target Id=1,Arn=arn:aws:sns:<Region>:<AccountNumber>:OpsWorksAutoHealingNotifier
```

4. Save the following policy as a file named OpsWorksAutoHealingPolicy.json.

```
{
  "Version": "2008-10-17",
  "Id": "OWAH",
  "Statement": [{
    "Sid": "TrustCWEToPublishEventsToMyTopicOWAH",
    "Effect": "Allow",
    "Principal": {
      "Service": "events.amazonaws.com"
    },
    "Action": "sns:Publish",
    "Resource": "arn:aws:sns:<Region>:<AccountNumber>:OpsWorksAutoHealingNotifier"
  }]
}

```
## 5. Use the following command to add permission to the SNS topic, so that CloudWatch Events can invoke and publish a notification to the topic.
```
$ aws sns set-topic-attributes 
--topic-arn "arn:aws:sns:<Region>:<AccountNumber>:OpsWorksAutoHealingNotifier" 
--attribute-name "Policy" 
--attribute-value file://OpsWOrksAutoHealingPolicy.json
```
Make sure to use a different ID for the second target if you are using the AWS CLI, or choose Add Target one more time in the AWS Management Console. If you use the AWS CLI, add resource-based policies for CloudWatch Events to invoke each of the targets.

## Example notifications as Stopping:

{
  "version": "0",
  "id": "050b15cf-2850-61cf-d7df-f8a1d9939ad6",
  "detail-type": "OpsWorks Instance State Change",
  "source": "aws.opsworks",
  "account": "1234567890123 ",
  "time": "2018-02-20T07:21:08Z",
  "region": "us-east-1",
  "resources": ["arn:aws:opsworks:us-east-1:1234567890123:instance/af3ee636-485a-4035-91f4-ff9c2bd46a59"],
  "detail": {
    "initiated_by": "auto-healing",
    "hostname": "abc1",
    "stack-id": "9fe94e79-ca26-4335-ad17-9d0f5e448fea",
    "layer-ids": ["214da842-8636-4e8c-8501-af05d1fcd182"],
    "instance-id": "af3ee636-485a-4035-91f4-ff9c2bd46a59",
    "ec2-instance-id": "i-0eb8f70b1865667a0",
    "status": "stopping"
  }
} 
## Example notifications as Requested:

{
  "version": "0",
  "id": "d6e873c2-7ec2-29b6-845e-ce98cc7bc873",
  "detail-type": "OpsWorks Instance State Change",
  "source": "aws.opsworks",
  "account": "1234567890123",
  "time": "2018-02-20T07:21:53Z",
  "region": "us-east-1",
  "resources": ["arn:aws:opsworks:us-east-1:1234567890123:instance/cdc6fb9d-32c8-4534-a365-a9924cf90b37"],
  "detail": {
    "initiated_by": "auto-healing",
    "hostname": "abc2",
    "stack-id": "9fe94e79-ca26-4335-ad17-9d0f5e448fea",
    "layer-ids": ["214da842-8636-4e8c-8501-af05d1fcd182"],
    "instance-id": "cdc6fb9d-32c8-4534-a365-a9924cf90b37",
    "ec2-instance-id": "i-01f56c8e04684c8c2",
    "status": "requested"
  }
}

## Next steps

Create notifications when instances are in start_failed or stop_failed status by setting up notifications.

# IMG

One example of a situation in which you could build a custom event pattern is when an instance times out when stopping.

{
  "version": "0",
  "id": "f99faa6f-0e27-e398-95bb-8f190806d275",
  "detail-type": "OpsWorks Alert",
  "source": "aws.opsworks",
  "account": "123456789012",
  "time": "2018-01-20T16:51:29Z",
  "region": "us-east-1",
  "resources": [],
  "detail": {
    "stack-id": "2f48f2be-ac7d-4dd5-80bb-88375f94db7b",
    "instance-id": "986efb74-69e8-4c6d-878e-5b77c054cbb0",
    "type": "InstanceStop",
    "message": "The shutdown of the instance timed out. Please try stopping it again."
  }
}
