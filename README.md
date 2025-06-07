# ☁️ Vulnerable Azure Terraform Environment for Cloud Security Training

This repository contains a deliberately misconfigured Azure infrastructure, defined using **Terraform**, to help you practice identifying and fixing common security issues in cloud environments.

## 🎯 Purpose

Designed for cloud security professionals, DevSecOps engineers, and students, this repo serves as a hands-on playground for:

- Static code analysis (Checkov, tfsec, Terrascan)
- Runtime environment scanning (Prowler, Microsoft Defender for Cloud)
- CSPM tool testing
- Cybersecurity demos & workshops

## 🚨 Misconfigurations included

- ❌ Public NSG rules (SSH, RDP, MySQL, SQL Server)
- ❌ Hardcoded secrets and plaintext passwords
- ❌ Weak TLS settings on Storage Accounts
- ❌ Key Vaults with missing logging, no network ACLs
- ❌ Unprotected virtual machines (password login enabled)
- ❌ Databases with public exposure and no audit logging
- ❌ Missing resource locks and NSGs
- ...and more

Each vulnerability was intentionally introduced to simulate common real-world misconfigurations.

## 🔧 Tools you can use

| Category         | Tools & Examples                              |
|------------------|------------------------------------------------|
| Static Scanning  | `Checkov`, `tfsec`, `Terrascan`               |
| Runtime Scanning | `Prowler`, `Microsoft Defender for Cloud`     |
| CSPM Demos       | Azure Security Center, Sentinel (optional)    |

## 📦 What's included

- `/modules/` – Modularized Terraform code with intentional misconfigs  
- `/core/` – Sample deployments and resource definitions  
- `README.md` – You’re here  
- `*.tf` files – Including NSG, VM, Storage, SQL, Key Vault, etc.

## ⚠️ Disclaimer

> **Warning:** This infrastructure is intentionally insecure.  
> **Do not deploy in a production or public Azure subscription.**
