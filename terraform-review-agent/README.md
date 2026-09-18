## 🤖 AI Terraform Review Agent on Serverless AWS

An **AI-powered Terraform review agent** that automatically reviews Infrastructure-as-Code changes in Pull Requests and decides whether to **APPROVE**, **APPROVE_WITH_CHANGES**, or **REJECT** them — just like a real DevOps reviewer.

This project combines **Terraform, GitHub Actions, Terrascan, OpenRouter AI, and Serverless AWS** to demonstrate how AI can be embedded directly into modern DevOps workflows.

---

## 🧠 What This Project Does

* Runs **Terrascan** on Terraform code during PRs
* Sends scan results to an **AI agent (via OpenRouter)**
* Applies **risk-based decision logic**
* Automatically:

  * ✅ Approves safe changes
  * ⚠️ Approves with required fixes
  * ❌ Rejects risky infrastructure changes
* Deploys a real application (**Super Mario game**) on **serverless AWS**
* Demonstrates **production-like infra patterns**

---

## 🏗 Architecture Overview

**Serverless AWS Stack**

* **AWS Lambda** → AI review agent
* **Amazon ECS (Fargate)** → Application runtime
* **Application Load Balancer (ALB)** → Traffic routing
* **ACM** → HTTPS certificates
* **Secrets Manager** → OpenRouter API key storage
* **S3 Backend** → Terraform state storage
* **GitHub Actions** → CI/CD pipeline

---

## 📁 Repository Structure

```
terraform-review-agent/
│
├── lambda/
│   ├── lambda_function.py   # AI review logic & prompt
│   └── requirements.txt
│
├── terraform/
│   ├── provider.tf
│   ├── backend.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── networking.tf
│   ├── security.tf
│   ├── alb.tf
│   ├── ecs.tf
│   ├── iam.tf
│   ├── lambda.tf
│   └── secrets.tf
│
└── .github/workflows/
    └── main.yml             # PR-based AI review pipeline
```

---

## ⚙️ Decision Logic (AI Review Policy)

The AI agent follows **strict risk thresholds**:

* ❌ **REJECT** if:

  * Any **HIGH / CRITICAL** issue exists
  * OR **MEDIUM ≥ 4**
  * OR **No HTTPS listener on ALB**
* ⚠️ **APPROVE_WITH_CHANGES** if:

  * MEDIUM issues = **1–3**
* ✅ **APPROVE** if:

  * Only LOW / INFO issues exist

This ensures **security without blocking velocity**.

---

## 🚀 Getting Started

### Prerequisites

* AWS CLI configured
* Terraform installed
* GitHub account
* Terrascan installed
  👉 [https://runterrascan.io/docs/getting-started/](https://runterrascan.io/docs/getting-started/)
* OpenRouter API key ([openrouter.ai/keys](https://openrouter.ai/keys))

---

### 1️⃣ Create Terraform Backend Bucket

```bash
aws s3 mb s3://pravesh-terraform-mario-state
```

(If the bucket name exists, update `backend.tf`.)

---

### 2️⃣ Initialize Terraform

```bash
cd terraform
terraform init
```

---

### 3️⃣ Plan & Apply Infrastructure

```bash
terraform plan -var="openrouter_api_key=YOUR_KEY"
terraform apply -var="openrouter_api_key=YOUR_KEY" --auto-approve
```

Once completed, the **Mario game** will be live on the ALB DNS.

---

## 🔐 Enabling HTTPS (Important)

* Add a **CAA record** before creating ACM certificate:

  ```
  issue "amazonaws.com"
  ```
* Validate ACM via DNS
* Attach certificate to ALB HTTPS listener
* Create DNS CNAME:

  ```
  mario → ALB DNS
  ```

---

## 🔁 Testing the AI Review Agent

1. Create a new branch
2. Make an infra change (e.g., remove HTTPS)
3. Push and open a PR
4. GitHub Actions triggers:

   * Terrascan
   * AI review
   * Verdict is posted
5. PR is **approved or blocked automatically**

---

## 🧹 Cleanup

```bash
terraform destroy -auto-approve -var="openrouter_api_key=YOUR_KEY"
aws s3 rm s3://pravesh-terraform-mario-state --recursive
aws s3 rb s3://pravesh-terraform-mario-state
```

---

## 📖 Blog & Demo

📘 Blog:
👉 [https://dev.to/aws-builders/how-i-built-an-ai-terraform-review-agent-on-serverless-aws-43hc](https://dev.to/aws-builders/how-i-built-an-ai-terraform-review-agent-on-serverless-aws-43hc)

🎥 Video demo coming soon on YouTube!

---

## 🙌 Author

**Pravesh Sudha**

* 🌐 [https://praveshsudha.com](https://praveshsudha.com)
* 💼 LinkedIn: [https://www.linkedin.com/in/pravesh-sudha/](https://www.linkedin.com/in/pravesh-sudha/)
* 🐦 X/Twitter: [https://x.com/praveshstwt](https://x.com/praveshstwt)
* ▶️ YouTube: [https://www.youtube.com/@pravesh-sudha](https://www.youtube.com/@pravesh-sudha)

---