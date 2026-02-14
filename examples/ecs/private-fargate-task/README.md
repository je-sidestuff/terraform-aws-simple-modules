# Minimal Fargate Task Example

This example demonstrates how to use the `fargate-task` module to create a minimal ECS Fargate service running an nginx container.

## What this example creates

- A VPC
- An ECS cluster
- An ECS service running on Fargate
- A task definition with an nginx container
- A security group allowing traffic to the container
- An ALB target group for the service

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Clean up when done:
   ```bash
   terraform destroy
   ```

## Requirements

- AWS CLI configured with appropriate credentials
- Terraform with versions required by [the module](../../../modules/ecs/fargate-task/README.md)

## Notes

The nginx container will be accessible on port 80 through load balancer.
Raw HTTP is preferred over HTTPS here for simplicity.
