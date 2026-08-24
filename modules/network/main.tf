# Virtual Cloud Network creation
resource "oci_core_vcn" "always_free_vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_id
  display_name   = "always-free-vcn"
  dns_label      = "freevcn"
}

# Internet Gateway to allow external internet traffic
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  display_name   = "always-free-internet-gateway"
  vcn_id         = oci_core_vcn.always_free_vcn.id
}

# Route Table directing external traffic to the Internet Gateway
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.always_free_vcn.id
  display_name   = "always-free-public-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Public Subnet hosting the Ampere compute instance
resource "oci_core_subnet" "public_subnet" {
  cidr_block        = var.subnet_cidr
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.always_free_vcn.id
  display_name      = "always-free-public-subnet"
  dns_label         = "publicsub"
  route_table_id    = oci_core_route_table.public_rt.id
  dhcp_options_id   = oci_core_vcn.always_free_vcn.default_dhcp_options_id
}

# Firewall rule management via Network Security Group (NSG)
resource "oci_core_network_security_group" "vm_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.always_free_vcn.id
  display_name   = "always-free-vm-nsg"
}

# Ingress Security Rule to allow SSH (Port 22) from anywhere
resource "oci_core_network_security_group_security_rule" "ssh_rule" {
  network_security_group_id = oci_core_network_security_group.vm_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}
