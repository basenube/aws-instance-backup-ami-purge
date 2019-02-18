
![gaze](https://www.basenube.com/archive/assets/images/basenube.png)

# Terraform AWS EC2 Instance Backup an AMI Purge

A Terraform plan that will deploy a set of resources that will...

...search for all instances having a tag with "Backup" or "backup"
on it. As soon as we have the instances list, we loop through each instance
and create an AMI of it. Also, it will look for a "Retention" tag key which
will be used as a retention policy number in days. If there is no tag with
that name, it will use a 7 days default value for each AMI.  After creating the AMI 
it creates a "DeleteOn" tag on the AMI indicating when it will be deleted using the Retention value and another Lambda function will...

...delete that AMI.

This results in a repository of AMI's with a retention for 7 days.

## Resources Created

  This plan includes the creation of the following AWS Resources:

  -- Lambda Function: Backup of Instances with the tag of "Backup"  
  -- Lambda Function: Deletion of Created AMI's  from Backup with a DeleteOn of the specified time duration in days.  
  -- ExecutionRole: Shared by both functions.  
  -- Shceduled Rule: Trigger for Backup function.  
  -- Scheduled Rule: Trigger for purge function.  
  -- Lambda Permissions(2): Permission to Invoke Respective Lamba Functions.  

## Usage

```bash
# Terraform shampoo
terraform init
terraform plan
terraform apply
```

## Legacy
There is also a [Cloudformation Version](https://github.com/basenube/aws-instance-backup-ami-purge/blob/master/cloudformation/basenube-aws-instance-backup-ami-purge-stack.yaml) of this included in case you dont Terraform.


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Author
Contains stolen gists glued together with Stack Overflow an HCL by Ron Sweeney <ron@basenube.com>

## License
[MIT](https://choosealicense.com/licenses/mit/)