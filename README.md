## Sending Logs from Your ECS Containers to Logz.io using fluentbit logging sidecar
To send logs from your ECS containers to Logz.io with fluentbit logging sidecar, follow these steps:

* Add the Fluent Bit Sidecar Container Definition:
  Add the following Fluent Bit sidecar container definition to your application task definition:

```json
{
  "name": "log_router",
  "image": "public.ecr.aws/logzio/ecs-fluentbit-sidecar:1.0.8-amd64",
  "memoryReservation": 100,
  "portMappings": [],
  "essential": true,
  "environment": [
    {
      "name": "CLUSTER",
      "value": "<<CLUSTER>>"
    },
    { 
      "name": "SERVICE_NAME", 
      "value": "<<SERVICE_NAME>>"
    },
    { 
      "name": "LOGZIO_LOGS_TOKEN",
      "value": "<<LOGZIO_LOGS_TOKEN>>"
    },
    { 
      "name": "DEPLOYMENT_VERSION", 
      "value": "<<DEPLOYMENT_VERSION>>"
    },
    { 
      "name": "LOGZIO_LOGS_LISTENER", 
      "value": "<<LOGZIO_LISTENER_URL>>"
    },
    { 
      "name": "LOGS_PATH", 
      "value": "<<LOGS_PATH>>"
    }
  ],
  "mountPoints": [
    { 
      "sourceVolume": "<<VOLUME_NAME>>", 
      "containerPath": "<<MOUNT_CONTAINER_PATH>>", 
      "readOnly": true
    }
  ],
  "dockerLabels": { "sidecar": "true" }
}
```
The Fluent Bit image is stored in AWS Public ECR and contains the Logz.io output plugin.
https://gallery.ecr.aws/logzio/ecs-fluentbit-sidecar
- amd64: `public.ecr.aws/logzio/ecs-fluentbit-sidecar:1.0.8-amd64`
- arm64: `public.ecr.aws/logzio/ecs-fluentbit-sidecar:1.0.8-arm64`

Ensure you have a matching volume on your application container.

* Replace Variables

Replace the following variables with your specific Logz.io attributes:

- `<<CLUSTER>>`: Your ECS cluster name.
- `<<SERVICE_NAME>>`: Your service name.
- `<<LOGZIO_LOGS_TOKEN>>`: Your Logz.io logs token.
- `<<DEPLOYMENT_VERSION>>`: Your deployment version.
- `<<LOGZIO_LISTENER_URL>>`: The Logz.io listener URL, for us account https://listener.logz.io:8071.
- `<<LOGS_PATH>>`: The path to your log files, e.g., /var/log/*.log.
- `<<MOUNT_CONTAINER_PATH>>`: the volume path you want to mount
- `<<VOLUME_NAME>>`: the volume name you want to mount

* After deploying your updated task definition, check your Logz.io account for incoming log data to verify that everything is set up correctly.

By following these steps, you can efficiently send logs from your ECS containers to Logz.io for better observability and monitoring.

### Adding cloudwatch logs
You can add `awslogs` `LogConfiguration` to your task definition to send logs to cloudwatch logs. Here is an example of how you can add it to your task definition.
```json
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "/ecs/<<SERVICE_NAME>>",
      "awslogs-region": "<<AWS_REGION>>",
      "awslogs-stream-prefix": "ecs"
    }
  }
```

### Using firelens
To forward logs using firelens you can look at this doc https://docs.logz.io/docs/shipping/aws/aws-ecs-fargate/#alternative-configure-aws-fargate-task-manually-to-send-logs-to-logzio


