# main.tf

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# 1. Criação da Rede (VCN Básica e Segura)
module "network" {
  source         = "./modules/network"
  compartment_id = var.compartment_id
  vcn_cidr       = "10.0.0.0/16"
  subnet_cidr    = "10.0.1.0/24"
}

# 2. Provisionamento da Instância ARM Ampere dentro dos limites Always Free
module "compute_arm" {
  source              = "./modules/compute"
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  subnet_id           = module.network.subnet_id
  nsg_id              = module.network.nsg_id
  
  # Parâmetros rígidos para o teto gratuito atual (2 OCPUs / 12 GB RAM)
  instance_shape      = "VM.Standard.A1.Flex"
  ocpus               = 2
  memory_in_gbs       = 12
  boot_volume_size_gbs = 50 # O limite total free é 200 GB somando todas as VMs
  
  ssh_public_key      = var.ssh_public_key
  instance_image_id   = var.oracle_linux_image_ocid
}
