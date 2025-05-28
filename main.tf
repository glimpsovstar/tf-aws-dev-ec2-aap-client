resource "aws_instance" "rhel_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = data.terraform_remote_state.aws_dev_vpc.outputs.vpc_public_subnets[0]
  key_name      = var.aws_key_pair_name
  tags          = var.ec2_tags
  vpc_security_group_ids = [data.terraform_remote_state.aws_dev_vpc.outputs.security_group-ssh_http_https_allowed]
  iam_instance_profile = "tfstacks-profile"
}

resource "aws_ec2_instance_state" "rhel_instance_state" {
  instance_id = aws_instance.rhel_instance.id
  state       = "running"
}

resource "aws_eip" "instance-eip" {
  instance = aws_instance.rhel_instance.id
  vpc      = true
}

locals {
  vm_names = {
    hostname = "rhel9-vm" # Map with a single key-value pair
  }
}

resource "aap_inventory" "vm_inventory" {
  name        = "Better Together Demo - ${var.TFC_WORKSPACE_ID}"
  description = "Inventory for VMs built with HCP Terraform and managed by AAP"
  variables   = jsonencode({}) # Empty variables block since vm_config is removed
}

resource "aap_host" "vm_host" {
  inventory_id = aap_inventory.vm_inventory.id
  name         = local.vm_names # Use the single hostname from locals

  variables = jsonencode({
    ansible_host = aws_instance.rhel_instance.public_ip # Reference the single EC2 instance
  })

  # Removed groups since aap_group is commented out and not used
  # groups = [] # Uncomment and add group IDs if needed later
}

resource "aap_job" "vm_demo_job" {
  job_template_id = var.job_template_id
  inventory_id    = aap_inventory.vm_inventory.id
  extra_vars      = jsonencode({})
  triggers        = local.vm_names
}