# OCI Always Free Infrastructure as Code (IaC) with Terraform

This repository contains reusable and modular **Terraform (HCL)** configurations to automate the deployment of a highly cost-efficient and secure compute infrastructure within the **Oracle Cloud Infrastructure (OCI) Always Free Tier**. 

It eliminates human errors during console setups and provides a production-grade blueprint following OCI Security Architecture guidelines.

---

## Architecture Blueprint

The code provisions a fully sandboxed architecture consisting of:
* **Networking (`modules/network`):** 
  * A dedicated Virtual Cloud Network (VCN) with an Internet Gateway.
  * A Public Subnet attached to custom route tables.
  * A strict **Network Security Group (NSG)** configured at the VNIC layer (instead of a broad Security List) to safely expose port `22` (SSH).
* **Compute (`modules/compute`):**
  * One Oracle Linux Compute Instance running on high-performance **Ampere A1 (ARM)** architecture.

---

## Resource Allocation & Free Tier Compliance

The resource limits in this configuration are strictly restricted to the official OCI Always Free resource limits (updated for 2026 quotas), preventing unexpected or accidental billing charges:

| Resource Component | Always Free Max Limit | Terraform Variable Defaults |
| :--- | :--- | :--- |
| **Shape** | `VM.Standard.A1.Flex` (ARM) | `VM.Standard.A1.Flex` |
| **Compute Compute OCPUs** | Up to 2 OCPUs total | `2` |
| **Compute RAM Memory** | Up to 12 GB RAM total | `12 GB` |
| **Boot Volume Storage** | Up to 200 GB total | `50 GB` |

> **Important Capacity Notice:** OCI data centers frequently experience massive demand for Ampere ARM instances. If your deployment fails with an `Out of capacity` error from the Oracle API, it means the hardware is temporarily unavailable in your availability domain. You may need to retry the deployment later or script an automated execution loop.

---

## Repository Structure

```text
oci-always-free-iac/
├── modules/
│   ├── network/
│   │   ├── main.tf                 # VCN, Internet Gateway, Subnet, NSG rules
│   │   ├── variables.tf            # Network parameters
│   │   └── outputs.tf              # Subnet and NSG identifiers
│   └── compute/
│       ├── main.tf                 # Ampere A1 instance setup
│       ├── variables.tf            # Compute configuration
│       └── outputs.tf              # Instance public endpoints
├── main.tf                         # Main module orchestration and provider config
├── variables.tf                    # Root level variables
├── outputs.tf                      # Final public architecture outputs
├── terraform.tfvars.example        # Reference environment file
└── README.md                       # Documentation
```

---

## Quick Start Guide

### Prerequisites
1. An active [Oracle Cloud Free Tier Account](https://oracle.comfree/).
2. [Terraform CLI](https://hashicorp.com) (`>= 1.2.0`) installed locally.
3. An OCI API Key pair configured inside your tenancy user account.

### 1. Clone this Repository
```bash
git clone https://github.com
cd oci-always-free-iac
```

### 2. Configure Environment Variables
Copy the input template file and fill in your unique OCI tenancy parameters (OCIDs), local key file paths, and your deployment region:
```bash
cp terraform.tfvars.example terraform.tfvars
```
Open `terraform.tfvars` in your preferred editor and populate the specific variables.

### 3. Initialize and Plan Infrastructure
Run the initialization step to download the official Oracle provider plugins, followed by an execution plan preview:
```bash
terraform init
terraform plan
```

### 4. Execute the Deployment
Apply the plan to deploy your infrastructure into your Oracle Cloud account:
```bash
terraform apply --auto-approve
```

Once deployment completes, the terminal will print out your new instance's public IP address:
```bash
Outputs:
always_free_vm_ip = "129.153.xx.xx"
```

### 5. Establish Access
Connect securely to your newly hosted cloud resource using the standard Oracle Linux username (`opc`) and the private key corresponding to the public key provided in your variables:
```bash
ssh -i /path/to/your/id_rsa opc@<always_free_vm_ip>
```

---

## Security Best Practices Implemented

* **Least Privilege Access:** Port exposure is locked into independent **Network Security Groups (NSGs)** linked dynamically to the VNIC, isolating resources compared to default broad subnet VCN access lists.
* **Sensitive Data Isolation:** Preconfigured `.gitignore` prevents hardcoded state data, private credentials (`.pem`), or variable definitions (`.tfvars`) from exposing secrets to public repositories.

---

## License
This project is licensed under the MIT License - see the LICENSE file for details.
